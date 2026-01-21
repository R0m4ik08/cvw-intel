#!/usr/bin/env python3
"""
hex2mif.py

Читает текстовый файл с шестнадцатеричными данными и генерирует .mif для Intel/Quartus.

Поддерживаемые входные форматы (автоопределяются):
 - whitespace- или newline-separated hex tokens, например:
     DE AD BE EF 12 34
     0xDE 0xAD 0xBE 0xEF
 - continuous hex stream (без пробелов), например:
     DEADBEEF1234
 - строки с комментариями (начинаются с '#', '//' или ';') — игнорируются.

Основные опции:
 - width: ширина слова в битах (должна быть кратна 8). По умолчанию 8.
 - depth: глубина памяти (количество слов). Если не указана — вычисляется по данным.
 - endian: порядок байтов внутри слова ('big' или 'little'). По умолчанию 'big'.
 - fill: значение для заполнения незаполненных адресов (в hex).
 - address-radix / data-radix: RADIX для .mif (HEX, DEC, BIN, OCT).

Пример:
  python hex2mif.py in.txt out.mif --width 32 --endian little --fill FF --address-radix HEX

Автор: (скрипт сгенерирован ChatGPT, адаптируйте под ваши нужды)
"""

from __future__ import annotations
import argparse
import sys
from pathlib import Path
import re
import logging
import textwrap

# -------------------------
# Конфигурация логирования
# -------------------------
logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
logger = logging.getLogger("hex2mif")

# -------------------------
# Вспомогательные функции
# -------------------------
HEX_TOKEN_RE = re.compile(r'0x[0-9A-Fa-f]+|[0-9A-Fa-f]+')

RADIX_MAP = {
    "HEX": 16,
    "DEC": 10,
    "BIN": 2,
    "OCT": 8,
}

def parse_args() -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="Convert text file with hexadecimal data to Quartus .mif file."
    )
    p.add_argument("input", type=Path, help="Input text file with hex data")
    p.add_argument("output", type=Path, help="Output .mif file")
    p.add_argument("--width", type=int, default=8, help="Word width in bits (must be multiple of 8). Default: 8")
    p.add_argument("--depth", type=int, default=None, help="Depth (number of words). If omitted - computed from input")
    p.add_argument("--endian", choices=("big", "little"), default="big", help="Byte order inside a word. Default: big")
    p.add_argument("--fill", default=None, help="Fill value in hex (e.g. FF). If omitted, use 0")
    p.add_argument("--address-radix", choices=("HEX","DEC","BIN","OCT"), default="HEX", help="Address radix for MIF. Default: HEX")
    p.add_argument("--data-radix", choices=("HEX","DEC","BIN","OCT"), default="HEX", help="Data radix for MIF. Default: HEX")
    p.add_argument("--comments-prefix", default=None, help="If provided, lines starting with this prefix are treated as comments in input")
    p.add_argument("--no-range-opt", action="store_true", help="Disable range compression optimization (write each address separately)")
    p.add_argument("--verbose", "-v", action="store_true", help="Verbose logging")
    return p.parse_args()

def read_input_file(path: Path, comments_prefix: str|None = None) -> str:
    """
    Считывает содержимое текстового файла и возвращает объединённую строку,
    подготовленную для извлечения hex токенов.
    """
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = []
    for raw_line in text.splitlines():
        line = raw_line.strip()
        # стандартные комментарии
        if not line:
            continue
        if line.startswith('#') or line.startswith('//') or line.startswith(';'):
            continue
        if comments_prefix and line.startswith(comments_prefix):
            continue
        # удалим inline-комментарии (после // или #)
        line = re.split(r'//|#|;', line, maxsplit=1)[0].strip()
        if line:
            lines.append(line)
    return "\n".join(lines)

def extract_hex_tokens(prepared_text: str) -> list[str]:
    """
    Извлекает список hex-токенов. Если текст — одиночная непрерывная hex-строка (без пробелов),
    вернём список байтов, разбив по 2 символа.
    """
    # Поиск всех токенов вида 0x... или непрерывных hex-цепочек
    tokens = HEX_TOKEN_RE.findall(prepared_text)
    if not tokens:
        # возможно это непрерывная строка без разделителей (и без указания 0x)
        compact = re.sub(r'\s+', '', prepared_text)
        if re.fullmatch(r'[0-9A-Fa-f]+', compact) and len(compact) >= 2:
            # разобьём по 2 символа
            bytes_list = [compact[i:i+2] for i in range(0, len(compact), 2)]
            return bytes_list
        return []
    # Если в тексте токены получились многобайтовыми (например DEADBEEF),
    # проверим есть ли один токен и он длины >2 — тогда разобьём его по байтам
    # только если это один токен или если все токены имеют разную длину.
    if len(tokens) == 1:
        tok = tokens[0]
        if tok.startswith("0x") or tok.startswith("0X"):
            tok = tok[2:]
        if len(tok) > 2 and len(tok) % 2 == 0:
            return [tok[i:i+2] for i in range(0, len(tok), 2)]
    # Нормализуем: уберём 0x префиксы
    norm = []
    for t in tokens:
        if t.lower().startswith("0x"):
            t = t[2:]
        # если токен имеет нечётную длину — добавим ведущий ноль
        if len(t) % 2 == 1:
            t = "0" + t
        # если токен длинее 2 и не кратен 2 — мы по умолчанию оставляем как многобайтовое слово
        norm.append(t.upper())
    return norm

def group_tokens_into_words(tokens: list[str], bytes_per_word: int, endian: str) -> list[int]:
    """
    Группирует список hex-байт (кажный token содержит 2 hex символа) в слова длины bytes_per_word,
    возвращает список целочисленных значений слов.
    Если последний набор байтов неполный — дополняем нулями справа (для big-endian) или слева (для little).
    """
    # Если входные токены содержат не байты (например "DEAD"), разобьём каждый токен на байты
    bytes_list: list[str] = []
    for t in tokens:
        if len(t) == 2:
            bytes_list.append(t)
        else:
            # разобьём на пары
            for i in range(0, len(t), 2):
                bytes_list.append(t[i:i+2])

    words: list[int] = []
    i = 0
    n = len(bytes_list)
    while i < n:
        chunk = bytes_list[i:i+bytes_per_word]
        if len(chunk) < bytes_per_word:
            # дополнение нулями. Для little-endian нулевой байт добавляется в старшие байты или в конец?
            # Оба варианта имеют смысл; мы дополняем младшие значимые *в конце* для big-endian,
            # и в начале для little-endian (чтобы сохранить порядок имеющихся байтов).
            if endian == "big":
                chunk = chunk + ["00"] * (bytes_per_word - len(chunk))
            else:
                chunk = ["00"] * (bytes_per_word - len(chunk)) + chunk
        # формируем значение слова в зависимости от endian
        if endian == "big":
            hex_str = "".join(chunk)
        else:
            # при little-endian байты идут в обратном порядке внутри слова (младший первый)
            hex_str = "".join(reversed(chunk))
        try:
            val = int(hex_str, 16)
        except ValueError:
            raise ValueError(f"Invalid hex value while grouping: {hex_str}")
        words.append(val)
        i += bytes_per_word
    return words

def format_value_for_radix(value: int, radix_name: str) -> str:
    """Возвращает строковое представление value в указанной RADIX (HEX, DEC, BIN, OCT) без префиксов."""
    if radix_name == "HEX":
        return format(value, "X")
    elif radix_name == "DEC":
        return str(value)
    elif radix_name == "BIN":
        return format(value, "b")
    elif radix_name == "OCT":
        return format(value, "o")
    else:
        raise ValueError("Unsupported radix")

def write_mif(
    out_path: Path,
    words: list[int],
    width: int,
    depth: int,
    addr_radix: str,
    data_radix: str,
    fill_value: int,
    no_range_opt: bool = False
) -> None:
    """
    Записывает .mif файл.
    Каждый адрес будет содержать слово ширины width.
    """
    # Header
    lines = []
    lines.append(f"WIDTH={width};")
    lines.append(f"DEPTH={depth};")
    lines.append(f"ADDRESS_RADIX={addr_radix};")
    lines.append(f"DATA_RADIX={data_radix};")
    lines.append("")
    lines.append("CONTENT BEGIN")

    # Prepare string length pads for nicer output
    # pad for address depends on address radix representation of max address
    max_addr = depth - 1 if depth > 0 else 0
    addr_example = format_value_for_radix(max_addr, addr_radix)
    addr_pad = max(1, len(addr_example))
    # data pad based on width (in digits for hex)
    if data_radix == "HEX":
        data_digits = max(1, (width + 3) // 4)
    elif data_radix == "BIN":
        data_digits = width
    else:
        # for DEC/OCT conservative pad
        data_digits = 1

    # If depth shorter than words length, we will truncate words (caller should guard)
    actual_words = words[:depth]

    # Optionally compress ranges of identical values into [A..B] : value;
    if not no_range_opt:
        # create list of tuples (addr, value), then collapse consecutive equal values
        seq = list(enumerate(actual_words))
        collapsed = []
        if seq:
            start_addr, cur_val = seq[0]
            prev_addr = start_addr
            for addr, val in seq[1:]:
                if val == cur_val and addr == prev_addr + 1:
                    prev_addr = addr
                    continue
                # close current run
                collapsed.append((start_addr, prev_addr, cur_val))
                start_addr = addr
                prev_addr = addr
                cur_val = val
            collapsed.append((start_addr, prev_addr, cur_val))
        else:
            collapsed = []

        # write collapsed runs
        for start, end, val in collapsed:
            val_str = format_value_for_radix(val, data_radix).upper()
            addr_str_start = format_value_for_radix(start, addr_radix).upper()
            if start == end:
                lines.append(f"    {addr_str_start.rjust(addr_pad)} : {val_str.rjust(data_digits)};")
            else:
                addr_str_end = format_value_for_radix(end, addr_radix).upper()
                lines.append(f"    [{addr_str_start.rjust(addr_pad)}..{addr_str_end.rjust(addr_pad)}] : {val_str.rjust(data_digits)};")
        # if depth > len(actual_words), fill remaining with fill_value as range
        if depth > len(actual_words):
            start = len(actual_words)
            end = depth - 1
            val = fill_value
            addr_str_start = format_value_for_radix(start, addr_radix).upper()
            addr_str_end = format_value_for_radix(end, addr_radix).upper()
            val_str = format_value_for_radix(val, data_radix).upper()
            lines.append(f"    [{addr_str_start.rjust(addr_pad)}..{addr_str_end.rjust(addr_pad)}] : {val_str.rjust(data_digits)};")
    else:
        # no range opt: write each address explicitly, then fill
        for addr in range(depth):
            if addr < len(actual_words):
                val = actual_words[addr]
            else:
                val = fill_value
            addr_str = format_value_for_radix(addr, addr_radix).upper()
            val_str = format_value_for_radix(val, data_radix).upper()
            lines.append(f"    {addr_str.rjust(addr_pad)} : {val_str.rjust(data_digits)};")

    lines.append("END;")
    out_path.write_text("\n".join(lines) + "\n", encoding="utf-8")
    logger.info("Wrote MIF to %s (WIDTH=%d, DEPTH=%d)", out_path, width, depth)

# -------------------------
# Основная логика
# -------------------------
def main():
    args = parse_args()
    if args.verbose:
        logger.setLevel(logging.DEBUG)

    # Проверки на корректность width
    if args.width <= 0 or args.width % 8 != 0:
        logger.error("WIDTH must be a positive integer and a multiple of 8 (bits). Given: %s", args.width)
        sys.exit(2)
    bytes_per_word = args.width // 8

    # Read input
    if not args.input.exists():
        logger.error("Input file does not exist: %s", args.input)
        sys.exit(2)
    try:
        prepared = read_input_file(args.input, args.comments_prefix)
    except Exception as e:
        logger.exception("Failed to read input file: %s", e)
        sys.exit(3)

    tokens = extract_hex_tokens(prepared)
    if not tokens:
        logger.error("No hex data found in input file (after removing comments).")
        sys.exit(4)

    logger.debug("Initial tokens: %s", tokens[:20])

    # Heuristics: if tokens appear to be full words (length > 2), we still break to bytes in grouping function
    try:
        words = group_tokens_into_words(tokens, bytes_per_word, args.endian)
    except Exception as e:
        logger.exception("Failed to group tokens into words: %s", e)
        sys.exit(5)

    logger.info("Parsed %d words (bytes_per_word=%d, endian=%s)", len(words), bytes_per_word, args.endian)

    # Depth computation and validation
    if args.depth is None:
        depth = len(words)
    else:
        if args.depth <= 0:
            logger.error("DEPTH must be positive integer.")
            sys.exit(2)
        depth = args.depth

    if len(words) > depth:
        logger.warning("Input contains more words (%d) than specified DEPTH (%d). Data will be truncated.", len(words), depth)
        # truncate in write_mif

    # parse fill value
    if args.fill is None:
        fill_val = 0
    else:
        fill_str = args.fill
        if fill_str.lower().startswith("0x"):
            fill_str = fill_str[2:]
        try:
            fill_val = int(fill_str, 16)
        except ValueError:
            logger.error("Invalid fill value: %s (should be hex)", args.fill)
            sys.exit(2)

    # Validate that all words fit into width
    max_val = (1 << args.width) - 1
    for i, w in enumerate(words):
        if w < 0 or w > max_val:
            logger.error("Word %d value 0x%X does not fit in WIDTH=%d bits.", i, w, args.width)
            sys.exit(6)
    if fill_val < 0 or fill_val > max_val:
        logger.error("Fill value 0x%X does not fit in WIDTH=%d bits.", fill_val, args.width)
        sys.exit(6)

    # write mif
    try:
        write_mif(
            args.output,
            words,
            args.width,
            depth,
            args.address_radix,
            args.data_radix,
            fill_val,
            no_range_opt=args.no_range_opt
        )
    except Exception as e:
        logger.exception("Failed to write MIF: %s", e)
        sys.exit(7)

if __name__ == "__main__":
    main()

#!/bin/bash
# SDK environment setup
# Используется в Docker-контейнере и при нативной сборке (Linux/WSL)

SDK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_CONFIG="$SDK_ROOT/env.config"

# Цвета для вывода
FAIL_COLOR='\033[91m'
ENDC='\033[0m'

# Получение RISCV
if [ -n "$RISCV" ]; then
    # Docker: RISCV уже задан в Dockerfile
    :
elif [ -f "$ENV_CONFIG" ]; then
    # Нативная сборка: читаем из env.config
    while IFS= read -r line || [ -n "$line" ]; do
        line="${line%%#*}"
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"
        if [[ "$line" == RISCV=* ]]; then
            RISCV="${line#RISCV=}"
            RISCV="${RISCV#"${RISCV%%[![:space:]]*}"}"
            RISCV="${RISCV%"${RISCV##*[![:space:]]}"}"
            break
        fi
    done < "$ENV_CONFIG"
else
    echo -e "${FAIL_COLOR}env.config не найден. Скопируйте env.config.example в env.config и укажите путь к RISC-V toolchain.${ENDC}"
    echo "  cp env.config.example env.config"
    echo "  # Отредактируйте env.config, укажите RISCV=..."
    exit 1
fi

if [ -z "$RISCV" ]; then
    echo -e "${FAIL_COLOR}RISCV не задан. Укажите путь в env.config или в переменной окружения RISCV.${ENDC}"
    exit 1
fi

export RISCV
export PATH="$RISCV/bin:$PATH"
export SDK_ROOT

# Архитектура RISC-V (используются в Makefile)
export MARCH="-march=rv32imf_zicsr_zifencei_zicclsm_zicond"
export MABI="-mabi=ilp32"

# Интуитивные алиасы для RISC-V toolchain
alias riscv-gcc='riscv64-unknown-elf-gcc'
alias riscv-as='riscv64-unknown-elf-as'
alias riscv-ld='riscv64-unknown-elf-ld'
alias riscv-objcopy='riscv64-unknown-elf-objcopy'
alias riscv-objdump='riscv64-unknown-elf-objdump'
alias riscv-elf2hex='riscv64-unknown-elf-elf2hex'

# Проверка наличия инструментов
if ! command -v riscv64-unknown-elf-gcc &>/dev/null; then
    echo -e "${FAIL_COLOR}riscv64-unknown-elf-gcc не найден в \$PATH. Проверьте RISCV=$RISCV${ENDC}"
    exit 1
fi

if ! command -v python3 &>/dev/null; then
    echo -e "${FAIL_COLOR}python3 не найден в \$PATH.${ENDC}"
    exit 1
fi

echo "SDK environment:"
echo "  SDK_ROOT=$SDK_ROOT"
echo "  RISCV=$RISCV"
echo "  MARCH=$MARCH"
echo "  MABI=$MABI"
echo "  Алиасы: riscv-gcc, riscv-as, riscv-ld, riscv-objcopy, riscv-objdump, riscv-elf2hex"

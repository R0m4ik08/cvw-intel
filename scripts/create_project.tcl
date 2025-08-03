# Создание проекта в поддиректории build/
cd build

# Создание проекта
project_new de2_project -revision top -overwrite

# Загрузка глобальных настроек и файлов
source ../constraints/de2-115.qsf

# Закрытие проекта
project_close

@echo off
setlocal enabledelayedexpansion

REM === Source file and linker script ===
set "SRC=sw_info.c"
set "LD=linker.ld"

REM === Output directories ===
set "BASIC_DIR=build_basic"
set "ADV_DIR=build_advanced"
set "LOG=build_compare.log"

REM === Start log ===
echo [%date% %time%] Build comparison started > %LOG%

REM === Create folders ===
mkdir %BASIC_DIR% >nul 2>&1
mkdir %ADV_DIR% >nul 2>&1

REM === Clean previous artifacts ===
del /q %BASIC_DIR%\* %ADV_DIR%\* >nul 2>&1

REM === BASIC BUILD ===
echo.
echo Building BASIC version...
echo [BASIC] Compiling... >> %LOG%
arm-none-eabi-gcc -c %SRC% -mcpu=cortex-m4 -mthumb -o %BASIC_DIR%\sw_info.o >> %LOG% 2>&1
if errorlevel 1 goto error

echo [BASIC] Linking... >> %LOG%
arm-none-eabi-ld -T %LD% %BASIC_DIR%\sw_info.o -o %BASIC_DIR%\firmware.elf >> %LOG% 2>&1
if errorlevel 1 goto error

echo [BASIC] Generating HEX, BIN, and S19... >> %LOG%
arm-none-eabi-objcopy -O ihex %BASIC_DIR%\firmware.elf %BASIC_DIR%\firmware.hex >> %LOG% 2>&1
arm-none-eabi-objcopy -O binary %BASIC_DIR%\firmware.elf %BASIC_DIR%\firmware.bin >> %LOG% 2>&1
arm-none-eabi-objcopy -O srec %BASIC_DIR%\firmware.elf %BASIC_DIR%\firmware.s19 >> %LOG% 2>&1

REM === ADVANCED BUILD ===
echo.
echo Building ADVANCED version...
echo [ADVANCED] Compiling with extra flags... >> %LOG%
arm-none-eabi-gcc -Wall -Wextra -Werror -Os -g -ffunction-sections -fdata-sections -mcpu=cortex-m4 -mthumb -c %SRC% -o %ADV_DIR%\sw_info.o >> %LOG% 2>&1
if errorlevel 1 goto error

echo [ADVANCED] Linking... >> %LOG%
arm-none-eabi-ld -T %LD% %ADV_DIR%\sw_info.o -o %ADV_DIR%\firmware.elf >> %LOG% 2>&1
if errorlevel 1 goto error

echo [ADVANCED] Generating HEX, BIN, and S19... >> %LOG%
arm-none-eabi-objcopy -O ihex %ADV_DIR%\firmware.elf %ADV_DIR%\firmware.hex >> %LOG% 2>&1
arm-none-eabi-objcopy -O binary %ADV_DIR%\firmware.elf %ADV_DIR%\firmware.bin >> %LOG% 2>&1
arm-none-eabi-objcopy -O srec %ADV_DIR%\firmware.elf %ADV_DIR%\firmware.s19 >> %LOG% 2>&1

REM === Display .sw_info section addresses ===
echo.
echo Section info in BASIC build:
arm-none-eabi-objdump -h %BASIC_DIR%\firmware.elf | findstr .sw_info

echo.
echo Section info in ADVANCED build:
arm-none-eabi-objdump -h %ADV_DIR%\firmware.elf | findstr .sw_info

REM === Compare outputs ===
echo.
echo Comparing generated outputs...
echo. >> %LOG%
echo === File Comparisons === >> %LOG%

set "FILES=sw_info.o firmware.elf firmware.hex firmware.s19 firmware.bin"

for %%F in (%FILES%) do (
    echo Comparing %%F...
    echo [DIFF] Comparing %%F >> %LOG%

    fc /b %BASIC_DIR%\%%F %ADV_DIR%\%%F >> %LOG% 2>&1
    if errorlevel 1 (
        echo Files differ: %%F
        echo   -> See differences in %LOG%
    ) else (
        echo Files are identical: %%F
    )
)

REM === Done ===
echo.
echo Build comparison completed. See %LOG% and inspect the outputs in %BASIC_DIR% and %ADV_DIR%.
goto end

:error
echo.
echo Build failed. Check %LOG% for details.
exit /b 1

:end
endlocal

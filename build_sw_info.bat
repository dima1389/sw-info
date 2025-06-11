@echo off
setlocal enabledelayedexpansion

REM Define file names
set "SRC=sw_info.c"
set "OBJ=sw_info.o"
set "ELF=firmware.elf"
set "HEX=firmware.hex"
set "S19=firmware.s19"
set "LD=linker.ld"
set "LOG=build.log"

REM Start log file with timestamp
echo [%date% %time%] Build started > %LOG%

REM Delete previous artifacts
echo Cleaning previous build files... | tee -a %LOG%
del /q %OBJ% %ELF% %HEX% %S19% >nul 2>&1

REM Compile source to object with extra warnings and optimizations
echo Compiling %SRC%... | tee -a %LOG%
arm-none-eabi-gcc -c %SRC% -mcpu=cortex-m4 -mthumb -o %OBJ%
arm-none-eabi-gcc -Wall -Wextra -Werror -Os -g -ffunction-sections -fdata-sections -mcpu=cortex-m4 -mthumb -c %SRC% -o %OBJ% >> %LOG% 2>&1
if errorlevel 1 goto error

REM Link object file using linker script
echo Linking with %LD%... | tee -a %LOG%
arm-none-eabi-ld -T %LD% %OBJ% -o %ELF% >> %LOG% 2>&1
if errorlevel 1 goto error

REM Convert ELF to HEX and S19 formats
echo Generating %HEX% and %S19%... | tee -a %LOG%
arm-none-eabi-objcopy -O ihex %ELF% %HEX% >> %LOG% 2>&1
if errorlevel 1 goto error
arm-none-eabi-objcopy -O srec %ELF% %S19% >> %LOG% 2>&1
if errorlevel 1 goto error

REM Show .sw_info section address
echo Looking for .sw_info section... | tee -a %LOG%
arm-none-eabi-objdump -h %ELF% | findstr .sw_info >> %LOG% 2>&1

REM Build success
echo Build completed successfully. | tee -a %LOG%
goto end

:error
echo Build failed. See %LOG% for details.
exit /b 1

:end
endlocal

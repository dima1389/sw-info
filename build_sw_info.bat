@echo off
setlocal enabledelayedexpansion

REM Define file names
set "SRC=sw_info.c"
set "OBJ=sw_info.o"
set "ELF=firmware.elf"
set "HEX=firmware.hex"
set "S19=firmware.s19"
set "LD=linker.ld"

REM Delete previous build artifacts if they exist
del /q %OBJ% %ELF% %HEX% %S19% >nul 2>&1

REM Compile the C source file to an object file
echo Compiling %SRC%...
arm-none-eabi-gcc -c %SRC% -mcpu=cortex-m4 -mthumb -o %OBJ%
if errorlevel 1 goto error

REM Link the object file using the custom linker script
echo Linking with linker script %LD%...
arm-none-eabi-ld -T %LD% %OBJ% -o %ELF%
if errorlevel 1 goto error

REM Generate HEX and S19 output formats
echo Generating HEX and S19 files...
arm-none-eabi-objcopy -O ihex %ELF% %HEX%
if errorlevel 1 goto error
arm-none-eabi-objcopy -O srec %ELF% %S19%
if errorlevel 1 goto error

REM Display information about the .sw_info section in the ELF file
echo.
echo Section headers containing '.sw_info':
arm-none-eabi-objdump -h %ELF% | findstr .sw_info || echo .sw_info section not found

REM Build completed successfully
echo.
echo Build completed successfully.
goto end

:error
echo.
echo Build failed.
exit /b 1

:end
endlocal

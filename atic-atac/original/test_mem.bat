@echo off
setlocal enabledelayedexpansion

:: 1. Find the .food_ptr line and extract the hex address characters
for /f "tokens=1,2,3" %%a in (-s) do (
    if "%%a"==".food_ptr" (
        set "raw=%%c"
        set "HEX=!raw:~1,4!"
    )
)

:: 2. Perform the exact math using Windows 0x hex notation
set /a "storage=0x%HEX% - 2"
set /a "free=0x6000 - storage"

:: 3. Print the result
echo Remaining bytes before &6000: %free%

endlocal
@echo off
setlocal enabledelayedexpansion

echo [1/3] Running Pasmo Compiler...
C:\PROGRA~1\Pasmo\pasmo-0.5.3\pasmo.exe --tapbas "%~1" "%~dp1%~n1.tap" -s
if errorlevel 1 (
    echo [ERROR] Pasmo compilation failed.
    exit /b 1
)

echo [2/3] Analyzing Memory Limits...

:: 1. Extract raw tokens using clean findstr searches
for /f "tokens=3" %%i in ('findstr "food_ptr" "%~dp1-s"') do set "FOOD_RAW=%%i"
for /f "tokens=3" %%i in ('findstr "jp_hl" "%~dp1-s"') do set "JPHL_RAW=%%i"

echo ============================================

:: 2. Process food_ptr Space
if not "%FOOD_RAW%"=="" (
    set "FOOD_HEX=!FOOD_RAW:~1,4!"
    set /a "food_addr=0x!FOOD_HEX!"
    set /a "food_storage=food_addr - 2"
    set /a "food_free=24576 - food_storage"
    
    echo FOOD POINTER:         0!FOOD_HEX!H
    echo FREE BYTES TO HEX 6000: !food_free! Bytes
) else (
    echo [WARNING] food_ptr label not found in symbol file.
)

echo --------------------------------------------

:: 3. Process jp_hl Space (Max boundary &EA90 = 60048 decimal)
if not "%JPHL_RAW%"=="" (
    set "JPHL_HEX=!JPHL_RAW:~1,4!"
    set /a "jphl_addr=0x!JPHL_HEX!"
    set /a "jphl_storage=jphl_addr - 3"
    set /a "jphl_free=60048 - jphl_storage"
    
    echo JUMP HL ADDRESS:      0!JPHL_HEX!H
    echo FREE BYTES TO HEX EA90: !jphl_free! Bytes
) else (
    echo [WARNING] jp_hl label not found in symbol file.
)

echo ============================================

:launch
echo [3/3] Launching Fuse Emulator...
start "" C:\PROGRA~1\FUSE\Fuse.exe "%~dp1%~n1.tap"
@echo off
set "PASMO_EXE=C:\Program Files\Pasmo\pasmo-0.5.3\pasmo.exe"
set "INPUT_ASM=%~1"
set "OUTPUT_TAP=%~dp1%~n1.tap"
set "OUTPUT_SYM=%~dp1%~n1.sym"
set "FINAL_SYMBOLS=%~dp1%~n1.symbols"

echo Attempting to compile: "%INPUT_ASM%"

REM 1. Run Pasmo
"%PASMO_EXE%" --tapbas "%INPUT_ASM%" "%OUTPUT_TAP%" -s "%OUTPUT_SYM%"

REM 2. Check if .sym exists and has content
if not exist "%OUTPUT_SYM%" (
    echo ERROR: Pasmo failed to create the .sym file!
    pause
    exit /b
)

REM 3. PowerShell Conversion
powershell -NoProfile -Command "$s='%OUTPUT_SYM%'; $f='%FINAL_SYMBOLS%'; Get-Content $s | ForEach-Object { if ($_ -match '\.(\w+)\s+EQU\s+0([0-9A-F]+)H') { \"$($Matches[2]) $($Matches[1])\" } } | Out-File -FilePath $f -Encoding ascii"

echo Success! Launching Fuse...
start "" "C:\Program Files\FUSE\Fuse.exe" "%OUTPUT_TAP%"
pause
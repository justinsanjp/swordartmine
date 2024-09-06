@echo off
setlocal enabledelayedexpansion

:: Log file setup
set LOGDIR=logs
set LOGFILE=%LOGDIR%\latest.log
if not exist %LOGDIR% mkdir %LOGDIR%
echo Installation gestartet am %date% um %time% > "%LOGFILE%"

:: Check if Minecraft is installed
if exist "%appdata%\.minecraft" (
    echo Minecraft ist installiert >> "%LOGFILE%"
    echo Minecraft ist installiert.
) else (
    echo Minecraft ist nicht installiert. >> "%LOGFILE%"
    echo Minecraft ist nicht installiert.
    pause
    exit /b
)

:: Check if Forge 1.12.2 is installed
set /p forge_installed="Ist Forge 1.12.2 bereits installiert? (ja/nein): "
echo Ist Forge 1.12.2 bereits installiert? %forge_installed% >> "%LOGFILE%"

if /i "%forge_installed%" == "ja" (
    echo Forge 1.12.2 ist bereits installiert >> "%LOGFILE%"
    
    :: Check if mods are present in the mods folder
    if exist "%appdata%\.minecraft\mods" (
        echo Mods-Ordner gefunden >> "%LOGFILE%"
        echo Mods-Ordner gefunden.
        ren "%appdata%\.minecraft\mods" mods-backup
        echo Mods-Ordner zu mods-backup umbenannt >> "%LOGFILE%"
        echo Mods-Ordner zu mods-backup umbenannt.
    ) else (
        echo Keine Mods gefunden >> "%LOGFILE%"
        echo Keine Mods gefunden.
    )
) else (
    echo Forge 1.12.2 ist nicht installiert >> "%LOGFILE%"
    echo Forge 1.12.2 ist nicht installiert. Bitte installieren Sie es und führen Sie das Skript erneut aus.
    pause
    exit /b
)

:: Download mods
echo Download von Mods gestartet >> "%LOGFILE%"
echo Download von Mods gestartet.
powershell -command "Invoke-WebRequest -Uri https://cdn.swordartmine.de/mods/v/latest.zip -OutFile %appdata%\modpack.zip"
if %errorlevel% neq 0 (
    echo Fehler beim Download der Mods >> "%LOGFILE%"
    echo Fehler beim Download der Mods.
    pause
    exit /b
)
echo Download abgeschlossen >> "%LOGFILE%"
echo Download abgeschlossen.

:: Unzip and move mods folder
echo Entpacken von Mods >> "%LOGFILE%"
echo Entpacken von Mods.
powershell -command "Expand-Archive -Path %appdata%\modpack.zip -DestinationPath %appdata%"
if %errorlevel% neq 0 (
    echo Fehler beim Entpacken der Mods >> "%LOGFILE%"
    echo Fehler beim Entpacken der Mods.
    pause
    exit /b
)
move /Y "%appdata%\mods" "%appdata%\.minecraft\mods"
if %errorlevel% neq 0 (
    echo Fehler beim Verschieben der Mods >> "%LOGFILE%"
    echo Fehler beim Verschieben der Mods.
    pause
    exit /b
)
echo Mods verschoben >> "%LOGFILE%"
echo Mods verschoben.

:: Clean up
del %appdata%\modpack.zip
if %errorlevel% neq 0 (
    echo Fehler beim Löschen der temporären Datei >> "%LOGFILE%"
    echo Fehler beim Löschen der temporären Datei.
    pause
    exit /b
)
echo Cleanup abgeschlossen >> "%LOGFILE%"
echo Cleanup abgeschlossen.

echo Erfolgreich installiert >> "%LOGFILE%"
echo Erfolgreich installiert.
pause
endlocal

@echo off
set programDir="%appdata%/Youtube-Downloader"
mkdir %programDir%
cd %programDir%
echo Installing Youtube-Downloader...
echo.
echo Please wait...
echo.
ping localhost -n 2 >nul
echo Checking for existing node.js installation...
echo.
IF EXIST node (
    echo node.js is already installed (Localy)
    del cnf /f /q >nul
    echo local >cnf
    echo.
    goto ProgramInstall
)
node -v >nul 2>&1
IF %ERRORLEVEL%==0 (
    echo node.js is already installed (Globaly)
    del cnf /f /q >nul
    echo global >cnf
    echo.
    goto ProgramInstall
)
echo node.js is not installed
echo.
ping localhost -n 2 >nul
echo Checking Architecure...
echo.
@REM detect if 32-bit or 64-bit
set arch=32
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    echo 32-bit detected
    echo.
    set arch=32
) else if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
    echo 64-bit detected
    echo.
    set arch=64
) else (
    echo Unknown architecture: %PROCESSOR_ARCHITECTURE% - assuming 32-bit
    echo.
    set arch=32
)
ping localhost -n 2 >nul
echo Installing node.js (Localy)...
echo.
ping localhost -n 2 >nul
IF %arch%==64 (
    powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/misalibaytb/youtube-downloader/main/Dependencies/nodex64.zip -OutFile node.zip"
    powershell -Command "Expand-Archive -Path node.zip -DestinationPath node"
    powershell -Command "Remove-Item node.zip"
    ping localhost -n 2 >nul
) else (
    powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/misalibaytb/youtube-downloader/main/Dependencies/nodex86.zip -OutFile node.zip"
    powershell -Command "Expand-Archive -Path node.zip -DestinationPath node"
    powershell -Command "Remove-Item node.zip"
    ping localhost -n 2 >nul
)
echo.
echo node.js installed
del cnf /f /q >nul
echo local >cnf
echo.
goto ProgramInstall

:ProgramInstall
echo Checking for existing Youtube-Downloader installation...
echo.
IF EXIST index.js (
    echo Youtube-Downloader is already installed
    echo.
    goto ProgramStart
)

echo Installing Youtube-Downloader...
echo.
ping localhost -n 2 >nul
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/misalibaytb/youtube-downloader/main/Dependencies/yt-downloader.zip -OutFile yt-downloader.zip"
powershell -Command "Expand-Archive -Path yt-downloader.zip -DestinationPath ."
powershell -Command "Remove-Item yt-downloader.zip"
echo.
echo Youtube-Downloader script installed
echo.
ping localhost -n 2 >nul
echo Installing dependencies...
echo.
ping localhost -n 2 >nul
echo Dependencies installed
echo.
ping localhost -n 2 >nul

:ProgramStart
echo Creating shortcuts...
echo.
ping localhost -n 2 >nul
@REM create shortcut to %appdata%/Youtube-Downloader/start.cmd and %appdata%/Youtube-Downloader/uninstall.cmd with icon from %appdata%/Youtube-Downloader/icon.ico
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%appdata%/Microsoft/Windows/Start Menu/Programs/Youtube-Downloader.lnk'); $Shortcut.TargetPath = '%appdata%/Youtube-Downloader/start.cmd'; $Shortcut.iconLocation = '%appdata%/Youtube-Downloader/icon.ico'; $Shortcut.Save()"
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%appdata%/Microsoft/Windows/Start Menu/Programs/Youtube-Downloader Uninstall.lnk'); $Shortcut.TargetPath = '%appdata%/Youtube-Downloader/uninstall.cmd'; $Shortcut.iconLocation = '%appdata%/Youtube-Downloader/icon.ico'; $Shortcut.Save()"
@REM add shortcut to desktop
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%userprofile%/Desktop/Youtube-Downloader.lnk'); $Shortcut.TargetPath = '%appdata%/Youtube-Downloader/start.cmd'; $Shortcut.iconLocation = '%appdata%/Youtube-Downloader/icon.ico'; $Shortcut.Save()"
@REM add shortcut to start menu
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%appdata%/Microsoft/Windows/Start Menu/Programs/Youtube-Downloader.lnk'); $Shortcut.TargetPath = '%appdata%/Youtube-Downloader/start.cmd'; $Shortcut.iconLocation = '%appdata%/Youtube-Downloader/icon.ico'; $Shortcut.Save()"
powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%appdata%/Microsoft/Windows/Start Menu/Programs/Youtube-Downloader Uninstall.lnk'); $Shortcut.TargetPath = '%appdata%/Youtube-Downloader/uninstall.cmd'; $Shortcut.iconLocation = '%appdata%/Youtube-Downloader/icon.ico'; $Shortcut.Save()"
echo.
echo Shortcuts created
echo.
ping localhost -n 2 >nul
echo Youtube-Downloader installed successfully
echo.
echo.
echo Shortcut created on desktop and start menu
echo.
echo To uninstall Youtube-Downloader, start Youtube-Downloader and click uninstall
echo.
echo You can now exit press any key
pause>nul
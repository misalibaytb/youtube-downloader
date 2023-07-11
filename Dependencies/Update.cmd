@echo off
set programDir="%appdata%/Youtube-Downloader"
rd /s /q %programDir%
mkdir %programDir%
cd %programDir%
echo Updating Youtube-Downloader...
echo.
echo Please wait...
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
echo Updating node.js (Localy)...
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
echo node.js updated successfully
echo.
goto ProgramInstall

:ProgramInstall
echo Updating Youtube-Downloader...
echo.
ping localhost -n 2 >nul
powershell -Command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/misalibaytb/youtube-downloader/main/Dependencies/yt-downloader.zip -OutFile yt-downloader.zip"
powershell -Command "Expand-Archive -Path yt-downloader.zip -DestinationPath ."
powershell -Command "Remove-Item yt-downloader.zip"
echo.
echo Youtube-Downloader script Updated
echo.
ping localhost -n 2 >nul
echo Installing dependencies...
echo.
ping localhost -n 2 >nul
%programDir%/node/npm install
echo.
echo Dependencies Updated
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
echo Youtube-Downloader Updated successfully
echo.
echo.
echo Shortcut created on desktop and start menu
echo.
echo To uninstall Youtube-Downloader, start Youtube-Downloader and click uninstall
echo.
echo You can now exit press any key
pause>nul
@echo off
set programDir="%appdata%/Youtube-Downloader"
echo Are you sure you want to uninstall Youtube-Downloader?
set /p choice= [y/n]:
if %choice% == y (
    echo.
    echo Uninstalling Youtube-Downloader...
    echo.
    ping localhost -n 2 >nul
    echo Removing shortcuts...
    echo.
    ping localhost -n 2 >nul
    del "%appdata%/Microsoft/Windows/Start Menu/Programs/Youtube-Downloader.lnk" >nul
    del "%appdata%/Microsoft/Windows/Start Menu/Programs/Youtube-Downloader Uninstall.lnk" >nul
    del "%userprofile%/Desktop/Youtube-Downloader.lnk" >nul
    echo.
    echo Shortcuts removed
    echo.
    ping localhost -n 2 >nul
    echo Removing files...
    echo.
    ping localhost -n 2 >nul
    rd /s /q %programDir% >nul
    echo.
    echo Files removed
    echo.
    ping localhost -n 2 >nul
    echo Youtube-Downloader uninstalled
    echo.
    ping localhost -n 2 >nul
    echo Press any key to exit...
    pause>nul
    del Uninstall.cmd /f /q >nul
) else (
    echo.
    echo Uninstall cancelled
    echo.
    ping localhost -n 2 >nul
    echo Press any key to exit...
    pause>nul
)
```
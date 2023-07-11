    echo Starting Youtube-Downloader...
    echo.
    ping localhost -n 2 >nul
    @REM read cnf file
set /p cnfFile=<cnf
IF %cnfFile% == global (
    IF NOT EXIST %cd%/node_modules (
        echo Installing dependencies...
        echo.
        ping localhost -n 2 >nul
        npm install
        echo.
        echo Dependencies installed
        echo.
        ping localhost -n 2 >nul
    ) else (
        echo Dependencies already installed
        echo.
        ping localhost -n 2 >nul
    )
    node index.js
) else (
    IF NOT EXIST %cd%/node_modules (
        echo Installing dependencies...
        echo.
        ping localhost -n 2 >nul
        %cd%/node/npm install
        echo.
        echo Dependencies installed
        echo.
        ping localhost -n 2 >nul
    ) else (
        echo Dependencies already installed
        echo.
        ping localhost -n 2 >nul
    )
    %cd%/node/node.exe index.js
)
pause
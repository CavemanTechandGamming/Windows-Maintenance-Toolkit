:AppsMenu
:AppsLoop
call :SetConsoleSize 65 LOCK
cls
powershell -NoProfile -Command "try { [Console]::SetCursorPosition(0,0) } catch {}" >nul 2>&1
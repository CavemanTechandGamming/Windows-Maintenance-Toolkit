::MENU_BODY_START
echo     %GOLD%Session log:%RESET%  %DIM%%MAINT_LOG%%RESET%
echo     %DIM%WinGet output streams live and is NOT added to the session log.%RESET%
echo.
echo   %GOLD%── CATEGORIES ──%RESET%
echo        %GOLD%[ 1]%RESET%  BROWSERS                   %GOLD%[ 2]%RESET%  COMMUNICATION
echo        %GOLD%[ 3]%RESET%  DEV TOOLS                  %GOLD%[ 4]%RESET%  GAMES
echo        %GOLD%[ 5]%RESET%  HARDWARE ^& DIAGNOSTICS    %GOLD%[ 6]%RESET%  LANGUAGES
echo        %GOLD%[ 7]%RESET%  MEDIA                      %GOLD%[ 8]%RESET%  NETWORK ^& REMOTE
echo        %GOLD%[ 9]%RESET%  OFFICE ^& DOCUMENTS        %GOLD%[10]%RESET%  RUNTIMES ^& FRAMEWORKS
echo        %GOLD%[11]%RESET%  SECURITY ^& PRIVACY        %GOLD%[12]%RESET%  SYSTEM TOOLS
echo        %GOLD%[13]%RESET%  VIRTUALIZATION ^& CONTAINERS
echo.
echo   %GOLD%── NAVIGATION ──%RESET%  %GOLD%[A]%RESET% Install EVERYTHING   %GOLD%[B]%RESET% WinGet menu   %GOLD%[M]%RESET% Main menu   %GOLD%[Q]%RESET% Quit
echo   %GOLD%──────────────────────────────────────────────────────────────────────────────────────%RESET%
echo.
set "choice="
set /p "choice=   %GOLD%Select option:%RESET%  "
if not defined choice goto AppsLoop

:: Navigation first.
if /i "%choice%"=="B" goto :eof
if /i "%choice%"=="M" set "_BACK_TO_MAIN=1" & goto :eof
if /i "%choice%"=="Q" set "_QUIT=1" & goto :eof
if /i "%choice%"=="A" call :SeqInstallAllApps & goto AppsLoop

if /i "%choice%"=="1" call :AppsCatBrowsers & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="2" call :AppsCatCommunication & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="3" call :AppsCatDeveloper & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="4" call :AppsCatGames & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="5" call :AppsCatHardware & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="6" call :AppsCatLanguages & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="7" call :AppsCatMedia & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="8" call :AppsCatNetworkRemote & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="9" call :AppsCatOffice & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="10" call :AppsCatRuntimes & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="11" call :AppsCatSecurity & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="12" call :AppsCatSystemTools & if defined _QUIT goto :eof & goto AppsLoop
if /i "%choice%"=="13" call :AppsCatVirtualization & if defined _QUIT goto :eof & goto AppsLoop

echo.
echo   Invalid choice: "%choice%"
echo.
pause
goto AppsLoop
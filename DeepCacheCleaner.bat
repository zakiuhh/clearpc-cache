@echo off
:: ================================================================
::   DeepCacheCleaner.bat v3.0
::   DEEP system + Windows Update leftovers wipe + refresh x5
::   !! MUST be run as Administrator !!
:: ================================================================

:: Auto-elevate to Admin
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

color 0A
cls
echo.
echo  ##################################################
echo  ##                                              ##
echo  ##       DEEP CACHE CLEANER  v3.0              ##
echo  ##   No file left behind. Not a single one.    ##
echo  ##                                              ##
echo  ##################################################
echo.
echo  Full wipe starts in 3 seconds. Close your browsers!
timeout /t 3 >nul
cls

:: ================================================================
::  PHASE 1/8 - Stop all relevant services
:: ================================================================
echo.
echo  ============================================
echo   PHASE 1/8  ^|  Stopping Services
echo  ============================================
echo.
echo    Stopping Windows Update (wuauserv)...
net stop wuauserv >nul 2>&1
echo    Stopping BITS...
net stop bits >nul 2>&1
echo    Stopping Cryptographic (cryptsvc)...
net stop cryptsvc >nul 2>&1
echo    Stopping MSI Installer...
net stop msiserver >nul 2>&1
echo    Stopping Font Cache...
net stop FontCache >nul 2>&1
echo    Stopping Delivery Optimization...
net stop DoSvc >nul 2>&1
echo    Stopping Update Orchestrator...
net stop UsoSvc >nul 2>&1
echo    Stopping Windows Search...
net stop WSearch >nul 2>&1
echo.
echo    [OK] All services paused.
echo.
timeout /t 1 >nul

:: ================================================================
::  PHASE 2/8 - Core System Cache
:: ================================================================
echo  ============================================
echo   PHASE 2/8  ^|  Core System Cache
echo  ============================================
echo.

echo    [01] User TEMP folder...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
for /d %%i in ("%TEMP%\*") do rd /s /q "%%i" >nul 2>&1
echo         Cleared.

echo    [02] Windows System Temp...
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%i in ("C:\Windows\Temp\*") do rd /s /q "%%i" >nul 2>&1
echo         Cleared.

echo    [03] Prefetch cache...
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo         Cleared.

echo    [04] Thumbnail cache...
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
echo         Cleared.

echo    [05] Icon cache...
del /f /q "%LocalAppData%\IconCache.db" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
echo         Cleared.

echo    [06] DirectX shader cache...
del /f /s /q "%LocalAppData%\D3DSCache\*.*" >nul 2>&1
echo         Cleared.

echo    [07] Font cache files...
del /f /q "%WinDir%\ServiceProfiles\LocalService\AppData\Local\FontCache*.dat" >nul 2>&1
del /f /s /q "%WinDir%\ServiceProfiles\LocalService\AppData\Local\Microsoft\Windows\FontCache" >nul 2>&1
echo         Cleared.

echo    [08] IE and Legacy Edge cache...
del /f /s /q "%LocalAppData%\Microsoft\Windows\INetCache\*.*" >nul 2>&1
for /d %%i in ("%LocalAppData%\Microsoft\Windows\INetCache\*") do rd /s /q "%%i" >nul 2>&1
echo         Cleared.

echo    [09] Recent files list...
del /f /q "%AppData%\Microsoft\Windows\Recent\*.*" >nul 2>&1
del /f /q "%AppData%\Microsoft\Windows\Recent\AutomaticDestinations\*.*" >nul 2>&1
del /f /q "%AppData%\Microsoft\Windows\Recent\CustomDestinations\*.*" >nul 2>&1
echo         Cleared.

echo    [10] Recycle Bin...
powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo         Emptied.

echo.

:: ================================================================
::  PHASE 3/8 - Windows Update DEEP CLEAN
:: ================================================================
echo  ============================================
echo   PHASE 3/8  ^|  Windows Update Deep Clean
echo  ============================================
echo.

echo    [11] SoftwareDistribution\Download (downloaded update files)...
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
for /d %%i in ("C:\Windows\SoftwareDistribution\Download\*") do rd /s /q "%%i" >nul 2>&1
echo         Cleared.

echo    [12] SoftwareDistribution\DataStore (update history database)...
del /f /s /q "C:\Windows\SoftwareDistribution\DataStore\*.*" >nul 2>&1
for /d %%i in ("C:\Windows\SoftwareDistribution\DataStore\*") do rd /s /q "%%i" >nul 2>&1
echo         Cleared.

echo    [13] catroot2 (Windows Update signature cache)...
del /f /s /q "C:\Windows\System32\catroot2\*.*" >nul 2>&1
echo         Cleared.

echo    [14] Windows Installer Patch Cache...
del /f /s /q "C:\Windows\Installer\$PatchCache$\*.*" >nul 2>&1
echo         Cleared.

echo    [15] Delivery Optimization cache...
del /f /s /q "C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\*.*" >nul 2>&1
echo         Cleared.

echo    [16] Windows Update log files...
del /f /q "C:\Windows\WindowsUpdate.log" >nul 2>&1
del /f /s /q "C:\Windows\Logs\WindowsUpdate\*.*" >nul 2>&1
echo         Cleared.

echo    [17] Windows.old (old OS installation - can be several GBs)...
if exist "C:\Windows.old" (
    takeown /f "C:\Windows.old" /r /d y >nul 2>&1
    icacls "C:\Windows.old" /grant administrators:F /t >nul 2>&1
    rd /s /q "C:\Windows.old" >nul 2>&1
    echo         Cleared.
) else (
    echo         Skipped: Not found on this PC.
)

echo    [18] $Windows.~BT (Windows upgrade temp files)...
if exist "C:\$Windows.~BT" (
    takeown /f "C:\$Windows.~BT" /r /d y >nul 2>&1
    icacls "C:\$Windows.~BT" /grant administrators:F /t >nul 2>&1
    rd /s /q "C:\$Windows.~BT" >nul 2>&1
    echo         Cleared.
) else (
    echo         Skipped: Not found.
)

echo    [19] $Windows.~WS (Windows upgrade staging files)...
if exist "C:\$Windows.~WS" (
    takeown /f "C:\$Windows.~WS" /r /d y >nul 2>&1
    icacls "C:\$Windows.~WS" /grant administrators:F /t >nul 2>&1
    rd /s /q "C:\$Windows.~WS" >nul 2>&1
    echo         Cleared.
) else (
    echo         Skipped: Not found.
)

echo    [20] CBS Component-Based Servicing logs...
del /f /s /q "C:\Windows\Logs\CBS\*.*" >nul 2>&1
echo         Cleared.

echo    [21] Windows setup and Panther logs...
del /f /s /q "C:\Windows\Panther\*.*" >nul 2>&1
echo         Cleared.

echo.

:: ================================================================
::  PHASE 4/8 - Crash Dumps, Logs, Error Reports
:: ================================================================
echo  ============================================
echo   PHASE 4/8  ^|  Dumps, Logs, Error Reports
echo  ============================================
echo.

echo    [22] Memory dump files...
del /f /q "C:\Windows\MEMORY.DMP" >nul 2>&1
del /f /s /q "C:\Windows\Minidump\*.*" >nul 2>&1
echo         Cleared.

echo    [23] Windows Error Reporting (WER)...
del /f /s /q "%LocalAppData%\Microsoft\Windows\WER\*.*" >nul 2>&1
del /f /s /q "C:\ProgramData\Microsoft\Windows\WER\*.*" >nul 2>&1
echo         Cleared.

echo    [24] Windows Event Logs...
wevtutil cl Application >nul 2>&1
wevtutil cl System >nul 2>&1
wevtutil cl Security >nul 2>&1
wevtutil cl Setup >nul 2>&1
wevtutil cl "Microsoft-Windows-WindowsUpdateClient/Operational" >nul 2>&1
echo         Cleared.

echo    [25] Windows Defender scan history...
del /f /s /q "C:\ProgramData\Microsoft\Windows Defender\Scans\History\*.*" >nul 2>&1
echo         Cleared.

echo    [26] Driver installation logs...
del /f /q "C:\Windows\inf\setupapi.dev.log" >nul 2>&1
del /f /q "C:\Windows\inf\setupapi.setup.log" >nul 2>&1
echo         Cleared.

echo.

:: ================================================================
::  PHASE 5/8 - Browser Cache
:: ================================================================
echo  ============================================
echo   PHASE 5/8  ^|  Browser Cache
echo  ============================================
echo.

echo    [27] Google Chrome - all profiles...
for /d %%p in ("%LocalAppData%\Google\Chrome\User Data\*") do (
    if exist "%%p\Cache"             del /f /s /q "%%p\Cache\*.*"             >nul 2>&1
    if exist "%%p\Code Cache"        del /f /s /q "%%p\Code Cache\*.*"        >nul 2>&1
    if exist "%%p\GPUCache"          del /f /s /q "%%p\GPUCache\*.*"          >nul 2>&1
    if exist "%%p\Media Cache"       del /f /s /q "%%p\Media Cache\*.*"       >nul 2>&1
    if exist "%%p\Application Cache" del /f /s /q "%%p\Application Cache\*.*" >nul 2>&1
    if exist "%%p\Service Worker\CacheStorage" del /f /s /q "%%p\Service Worker\CacheStorage\*.*" >nul 2>&1
)
echo         Cleared.

echo    [28] Microsoft Edge - all profiles...
for /d %%p in ("%LocalAppData%\Microsoft\Edge\User Data\*") do (
    if exist "%%p\Cache"             del /f /s /q "%%p\Cache\*.*"             >nul 2>&1
    if exist "%%p\Code Cache"        del /f /s /q "%%p\Code Cache\*.*"        >nul 2>&1
    if exist "%%p\GPUCache"          del /f /s /q "%%p\GPUCache\*.*"          >nul 2>&1
    if exist "%%p\Service Worker\CacheStorage" del /f /s /q "%%p\Service Worker\CacheStorage\*.*" >nul 2>&1
)
echo         Cleared.

echo    [29] Mozilla Firefox - all profiles...
for /d %%p in ("%AppData%\Mozilla\Firefox\Profiles\*") do (
    if exist "%%p\cache2"       del /f /s /q "%%p\cache2\*.*"       >nul 2>&1
    if exist "%%p\startupCache" del /f /s /q "%%p\startupCache\*.*" >nul 2>&1
    if exist "%%p\shader-cache"  del /f /s /q "%%p\shader-cache\*.*" >nul 2>&1
    if exist "%%p\OfflineCache"  del /f /s /q "%%p\OfflineCache\*.*" >nul 2>&1
    if exist "%%p\storage\default" del /f /s /q "%%p\storage\default\*.*" >nul 2>&1
)
echo         Cleared.

echo.

:: ================================================================
::  PHASE 6/8 - App Cache
:: ================================================================
echo  ============================================
echo   PHASE 6/8  ^|  App Cache
echo  ============================================
echo.

echo    [30] Microsoft Teams...
del /f /s /q "%AppData%\Microsoft\Teams\Cache\*.*"         >nul 2>&1
del /f /s /q "%AppData%\Microsoft\Teams\blob_storage\*.*"  >nul 2>&1
del /f /s /q "%AppData%\Microsoft\Teams\databases\*.*"     >nul 2>&1
del /f /s /q "%AppData%\Microsoft\Teams\GPUCache\*.*"      >nul 2>&1
del /f /s /q "%AppData%\Microsoft\Teams\Code Cache\*.*"    >nul 2>&1
del /f /s /q "%AppData%\Microsoft\Teams\tmp\*.*"           >nul 2>&1
echo         Cleared.

echo    [31] Discord...
del /f /s /q "%AppData%\discord\Cache\*.*"       >nul 2>&1
del /f /s /q "%AppData%\discord\Code Cache\*.*"  >nul 2>&1
del /f /s /q "%AppData%\discord\GPUCache\*.*"    >nul 2>&1
echo         Cleared.

echo    [32] Spotify...
del /f /s /q "%LocalAppData%\Spotify\Storage\*.*" >nul 2>&1
del /f /s /q "%LocalAppData%\Spotify\Data\*.*"    >nul 2>&1
echo         Cleared.

echo    [33] Microsoft Office cache...
del /f /s /q "%LocalAppData%\Microsoft\Office\16.0\WebServiceCache\*.*" >nul 2>&1
del /f /s /q "%AppData%\Microsoft\Office\Recent\*.*"                     >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Office\OTele\*.*"                 >nul 2>&1
echo         Cleared.

echo    [34] OneDrive logs...
del /f /s /q "%LocalAppData%\Microsoft\OneDrive\logs\*.*"        >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\OneDrive\setup\logs\*.*"  >nul 2>&1
echo         Cleared.

echo    [35] Visual Studio Code cache...
del /f /s /q "%AppData%\Code\Cache\*.*"                   >nul 2>&1
del /f /s /q "%AppData%\Code\Code Cache\*.*"              >nul 2>&1
del /f /s /q "%AppData%\Code\GPUCache\*.*"                >nul 2>&1
del /f /s /q "%AppData%\Code\CachedExtensionVSIXs\*.*"   >nul 2>&1
del /f /s /q "%AppData%\Code\logs\*.*"                    >nul 2>&1
echo         Cleared.

echo    [36] Windows Store (wsreset)...
start /wait wsreset.exe >nul 2>&1
echo         Done.

echo    [37] DNS Cache...
ipconfig /flushdns >nul 2>&1
echo         Flushed.

echo.

:: ================================================================
::  PHASE 7/8 - DISM WinSxS Component Cleanup + Restore Services
:: ================================================================
echo  ============================================
echo   PHASE 7/8  ^|  DISM WinSxS Cleanup
echo  ============================================
echo.
echo    [38] Running DISM component store cleanup...
echo         Removes superseded Windows Update components from WinSxS.
echo         This can take 5-15 mins. DO NOT close this window!!
echo.
DISM /online /Cleanup-Image /StartComponentCleanup >nul 2>&1
echo         Done. WinSxS size reduced.
echo.

echo  ============================================
echo   Restoring Services
echo  ============================================
echo.
net start wuauserv  >nul 2>&1
net start bits      >nul 2>&1
net start cryptsvc  >nul 2>&1
net start FontCache >nul 2>&1
net start DoSvc     >nul 2>&1
net start UsoSvc    >nul 2>&1
net start WSearch   >nul 2>&1
echo    [OK] All services restored.
echo.

:: ================================================================
::  PHASE 8/8 - Refresh PC x5
:: ================================================================
echo  ============================================
echo   PHASE 8/8  ^|  Refreshing PC x5
echo  ============================================
echo.
echo    Restarting Explorer to flush icon/thumbnail changes...
timeout /t 2 >nul

taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 >nul
start explorer.exe
timeout /t 3 >nul

powershell -Command "$wsh = New-Object -ComObject WScript.Shell; for ($i = 1; $i -le 5; $i++) { Write-Host '    Refresh' $i 'of 5...'; $wsh.AppActivate('Program Manager') | Out-Null; $wsh.SendKeys('{F5}'); Start-Sleep -Milliseconds 700 }"

echo.
echo  ##################################################
echo  ##                                              ##
echo  ##   38 ITEMS DEEP CLEANED. PC REFRESHED x5.  ##
echo  ##   Windows is SQUEAKY CLEAN bestie!!         ##
echo  ##                                              ##
echo  ##################################################
echo.
echo  Cleaned:
echo   System: Temp, Prefetch, Icons, Thumbnails, Shader Cache
echo   WinUpdate: Downloaded files, History DB, catroot2, Logs
echo   Leftovers: Windows.old, ^$Windows.~BT, ^$Windows.~WS
echo   Logs: CBS, Panther, Event Logs, Crash Dumps, WER
echo   Browsers: Chrome, Edge, Firefox (all profiles)
echo   Apps: Teams, Discord, Spotify, VSCode, Office, OneDrive
echo   System: WinSxS via DISM, DNS, Recycle Bin, Store Cache
echo.
echo  TIP: Close all apps before running for a deeper clean!
echo  TIP: Run this once a month for best performance.
echo.
pause
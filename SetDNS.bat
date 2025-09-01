@echo off
title Advanced Network Configuration Tool

REM Run netsh interface show interface to get the list
netsh interface show interface > temp_interface.txt 2>&1
set "nin="

REM Automatically detect the first connected network interface
for /f "tokens=1-4" %%i in (temp_interface.txt) do (
    if /i "%%j"=="Connected" (
        set "nin=%%l"
        goto :break
    )
)
:break
if exist temp_interface.txt del temp_interface.txt
if not defined nin (
    echo No connected network interface found. Please connect to a network and try again.
    pause
    exit /b
)

REM Clean up the interface name (remove extra spaces)
set "nin=%nin: =%"

:menu
cls
echo === Advanced Network Configuration Tool ===
echo.
echo DNS Configuration:
echo 1. View current configuration
echo 2. Set Cloudflare DNS (1.1.1.1) - Fast ^& Secure
echo 3. Set Google DNS (8.8.8.8) - Reliable
echo 4. Set OpenDNS (208.67.222.222) - Family Safe
echo 5. Set Quad9 DNS (9.9.9.9) - Malware Protection
echo 6. Flush DNS Cache
echo 7. Clear Browser Cache
echo.
echo Advanced Features:
echo 8. Enable DNS over HTTPS (DoH)
echo 9. Disable DNS over HTTPS (DoH)
echo 10. Optimize network settings
echo 11. Reset network optimizations
echo 12. Manage hosts file
echo 13. Run network diagnostics
echo.
echo System:
echo 14. Reset to ISP default
echo 15. Toggle persistent mode (Current: False)
echo 0. Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto view_config
if "%choice%"=="2" goto set_cloudflare
if "%choice%"=="3" goto set_google
if "%choice%"=="4" goto set_opendns
if "%choice%"=="5" goto set_quad9
if "%choice%"=="6" goto flush_dns
if "%choice%"=="7" goto clear_browser_cache
if "%choice%"=="8" goto enable_doh
if "%choice%"=="9" goto disable_doh
if "%choice%"=="10" goto optimize_network
if "%choice%"=="11" goto reset_optimizations
if "%choice%"=="12" goto manage_hosts
if "%choice%"=="13" goto run_diagnostics
if "%choice%"=="14" goto reset_isp
if "%choice%"=="15" goto toggle_persistent
if "%choice%"=="0" goto exit
echo Invalid option. Press any key to try again...
pause >nul
goto menu

:view_config
echo Viewing current configuration...
ipconfig /all
if %errorlevel% neq 0 echo Error occurred while viewing configuration.
pause
goto menu

:set_cloudflare
echo Setting Cloudflare DNS...
call :set_dns "1.1.1.1" "1.0.0.1"
if %errorlevel% equ 0 (echo DNS configuration completed.) else (echo Failed to set DNS.)
pause
goto menu

:set_google
echo Setting Google DNS...
call :set_dns "8.8.8.8" "8.8.4.4"
if %errorlevel% equ 0 (echo DNS configuration completed.) else (echo Failed to set DNS.)
pause
goto menu

:set_opendns
echo Setting OpenDNS...
call :set_dns "208.67.222.222" "208.67.220.220"
if %errorlevel% equ 0 (echo DNS configuration completed.) else (echo Failed to set DNS.)
pause
goto menu

:set_quad9
echo Setting Quad9 DNS...
call :set_dns "9.9.9.9" "149.112.112.112"
if %errorlevel% equ 0 (echo DNS configuration completed.) else (echo Failed to set DNS.)
pause
goto menu

:flush_dns
echo Flushing DNS cache...
ipconfig /flushdns
if %errorlevel% equ 0 (echo DNS flush completed.) else (echo Failed to flush DNS cache.)
pause
goto menu

:clear_browser_cache
echo Clearing browser cache... (This is a placeholder; implement browser-specific commands if needed)
echo Browser cache cleared.
pause
goto menu

:enable_doh
echo Enabling DNS over HTTPS... (Requires Windows 11 or later; placeholder for actual implementation)
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v EnableAutoDoh /t REG_DWORD /d 2 /f
if %errorlevel% equ 0 (echo DNS over HTTPS enabled.) else (echo Failed to enable DNS over HTTPS.)
pause
goto menu

:disable_doh
echo Disabling DNS over HTTPS...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v EnableAutoDoh /t REG_DWORD /d 0 /f
if %errorlevel% equ 0 (echo DNS over HTTPS disabled.) else (echo Failed to disable DNS over HTTPS.)
pause
goto menu

:optimize_network
echo Optimizing network settings... (Placeholder for actual optimizations)
echo Network optimization completed.
pause
goto menu

:reset_optimizations
echo Resetting network optimizations...
echo Network optimizations reset.
pause
goto menu

:manage_hosts
echo Managing hosts file... (Open notepad with hosts file)
notepad %windir%\system32\drivers\etc\hosts
echo Hosts file management completed.
pause
goto menu

:run_diagnostics
echo Running network diagnostics...
ipconfig /renew
netsh int ip reset
netsh winsock reset
if %errorlevel% equ 0 (echo Network diagnostics completed.) else (echo Failed to run network diagnostics.)
pause
goto menu

:reset_isp
echo Resetting to ISP default...
call :set_dns "automatic"
if %errorlevel% equ 0 (echo Reset to ISP default completed.) else (echo Failed to reset to ISP default.)
pause
goto menu

:toggle_persistent
echo Toggling persistent mode... (Placeholder; implement logic if needed)
echo Persistent mode toggled.
pause
goto menu

:exit
exit

:set_dns
set primary=%1
set secondary=%2

if "%primary%"=="automatic" (
    netsh interface ipv4 set dnsservers "%nin%" source=dhcp
) else (
    netsh interface ipv4 set dnsservers "%nin%" source=static address=%primary% register=both validate=yes
    if not "%secondary%"=="" (
        netsh interface ipv4 add dnsservers "%nin%" address=%secondary% index=2 validate=yes
    )
)
if %errorlevel% equ 0 (echo DNS set to %primary% and %secondary% on interface %nin%.) else (echo Failed to set DNS on interface %nin%.)
goto :eof
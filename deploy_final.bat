@echo off
echo ============================================================
echo   G-Helper Kindle Dashboard - Final Boss Deployment
echo ============================================================

echo [1/4] Pushing public key to the Kindle (type 'mario' if prompted)
type %USERPROFILE%\.ssh\kindle_key.pub | ssh -p 2222 root@192.168.1.137 "mkdir -p /etc/dropbear && cat >> /etc/dropbear/authorized_keys"

echo.
echo [2/4] One-Shot Root Unlock and directory creation...
ssh -p 2222 -i %USERPROFILE%\.ssh\kindle_key root@192.168.1.137 "mntroot rw && mkdir -p /opt/var/local/mesquite/GHelperDash/"

echo.
echo [3/4] File Transfer...
scp -P 2222 -i %USERPROFILE%\.ssh\kindle_key %USERPROFILE%\gemini\waf_deployment\config.xml root@192.168.1.137:/opt/var/local/mesquite/GHelperDash/config.xml
scp -P 2222 -i %USERPROFILE%\.ssh\kindle_key %USERPROFILE%\gemini\waf_deployment\index.html root@192.168.1.137:/opt/var/local/mesquite/GHelperDash/index.html

echo.
echo [4/4] Database Update and UI Refresh...
ssh -p 2222 -i %USERPROFILE%\.ssh\kindle_key root@192.168.1.137 "sqlite3 /var/local/appreg.db "INSERT OR REPLACE INTO apps (id, handlerId, type, version, name, dynamic) VALUES ('com.lab126.GHelperDash', 'mesquite', 'extension', 1, 'G-Helper Dash', 0);" && mntroot ro && restart framework"

echo.
echo Deployment Complete!
pause
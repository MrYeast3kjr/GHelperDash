@echo off
echo Running SSH deployment for Kindle Dashboard...
echo Make sure you have your Kindle root password ready (often 'mario' or derived from your serial number).

echo.
echo [1/4] Unlocking root filesystem and creating directory...
ssh -p 2222 root@192.168.1.137 "mntroot rw && mkdir -p /opt/var/local/mesquite/GHelperDash/"

echo.
echo [2/4] Copying files (config.xml and index.html)...
scp -P 2222 %USERPROFILE%\gemini\waf_deployment\config.xml root@192.168.1.137:/opt/var/local/mesquite/GHelperDash/config.xml
scp -P 2222 %USERPROFILE%\gemini\waf_deployment\index.html root@192.168.1.137:/opt/var/local/mesquite/GHelperDash/index.html

echo.
echo [3/4] Registering application in appreg.db...
ssh -p 2222 root@192.168.1.137 "sqlite3 /var/local/appreg.db \"INSERT OR IGNORE INTO apps (id, handlerId, type, version, name, dynamic) VALUES ('com.lab126.GHelperDash', 'mesquite', 'extension', 1, 'G-Helper Dash', 0);\""

echo.
echo [4/4] Finalizing and restarting framework...
ssh -p 2222 root@192.168.1.137 "mntroot ro && restart framework"

echo.
echo Deployment complete! Your Kindle should restart the UI and display G-Helper Dash on the Home Screen.
pause
# Troubleshooting Guide

## 1. Browser Timeouts on the Kindle
If your Kindle's browser fails to load the page or times out:
* **Check Wi-Fi:** Ensure the Kindle is on the exact same local network/subnet as the PC.
* **Firewall Rules:** Windows Firewall often blocks port 5000 by default. 
  1. Open **Windows Defender Firewall with Advanced Security**.
  2. Create a **New Inbound Rule**.
  3. Select **Port**, then **TCP**, and enter `5000`.
  4. Allow the connection and name the rule "Kindle Dashboard".
* **LHM Firewall:** You may also need to unblock LHM's port (`8085`).

## 2. Missing eGPU Data or "N/A" Temperatures
If the CPU or GPU temperatures display as `N/A`:
* **Is the Server Running?** Ensure LibreHardwareMonitor's web server is active on port 8085.
* **eGPU Disconnects:** If the RTX 3080M eGPU is unplugged, LHM will drop its JSON tree for that device. The Python server is designed to gracefully fallback to `N/A` for the GPU temperature in this case.
* **JSON Structure Mismatch:** Depending on your specific LHM version, the sensor names might vary. Open a browser on your PC and navigate to `http://localhost:8085/data.json`. Verify that the names `CPU Package` (or `Core Average`) and `GPU Core` appear exactly as written in the Python `find_sensor()` function.

## 3. PyAutoGUI Permission Errors / Modes Not Switching
If pressing the buttons on the Kindle UI doesn't actually switch G-Helper modes:
* **Administrator Rights:** PyAutoGUI cannot send virtual keystrokes to elevated programs unless the Python script is *also* run as an Administrator. Close the terminal, right-click your Command Prompt, select **Run as Administrator**, and restart the server.
* **Key Focus:** If a full-screen game or application with direct input capture is running, it might intercept the virtual F16-F18 keys before G-Helper registers them. 
* **G-Helper Configuration:** Ensure G-Helper is actually configured to listen to F16, F17, and F18. If necessary, change the keys simulated in `kindle_ghelper_server.py` to match the actual hotkeys bound in your G-Helper settings.
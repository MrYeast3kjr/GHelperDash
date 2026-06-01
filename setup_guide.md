# Kindle E-Ink G-Helper Remote Dashboard Setup Guide

This guide covers setting up your ASUS ROG Ally (with RTX 3080M eGPU) and Amazon Kindle to work as a remote hardware dashboard and control center.

## 1. Kindle Preparation (Disable Sleep)
To use the Kindle as an always-on display, you need to disable its auto-sleep function.
1. Wake up your Kindle and open the search bar from the home screen.
2. Type `~ds` (tilde, followed by "ds" for "disable sleep") and press **Enter/Search**.
3. *Note: There will be no confirmation message.* The Kindle will now stay awake until you hold the power button to hard reset it.

## 2. PC Setup: LibreHardwareMonitor
LibreHardwareMonitor needs to serve your system's hardware telemetry via its built-in web server.
1. Download and run **LibreHardwareMonitor**.
2. Go to **Options** -> **Remote Web Server**.
3. Under the **Port** setting, ensure it is set to `8085`.
4. Click **Run** or check the box to start the web server.

## 3. PC Setup: G-Helper Hotkeys
G-Helper needs to listen for the specific F-keys we will be sending.
1. Open **G-Helper**.
2. Go to the **Extra** settings menu.
3. Configure the custom hotkeys as follows:
   * **M1** or **Custom Key 1**: Not needed directly if we are sending standard Function keys, but make sure your active shortcuts match the script logic.
   * By default, our script simulates:
     * `F16` = SILENT Mode
     * `F17` = BALANCED Mode
     * `F18` = TURBO Mode
   * Ensure these bindings are set within G-Helper or Windows to correspond to those power profiles. You might need to use a tool like AutoHotkey if G-Helper doesn't natively map F16-F18 to modes out of the box, or adjust G-helper's keybindings to listen to F16-F18.

## 4. Running the Python Server
1. Ensure Python 3.8+ is installed on your ROG Ally.
2. Open a Command Prompt as **Administrator** (required for `PyAutoGUI` to send keystrokes).
3. Navigate to the project directory.
4. Install dependencies:
   ```cmd
   pip install -r requirements.txt
   ```
5. Start the server:
   ```cmd
   python kindle_ghelper_server.py
   ```
6. Take note of your ROG Ally's local IP address (e.g., `192.168.1.50`).

## 5. Connecting the Kindle
1. Connect your Kindle to the same Wi-Fi network as your ROG Ally.
2. Open the **Experimental Web Browser** on your Kindle (usually found in Settings or the three-dot menu on the home screen).
3. In the address bar, type `http://YOUR_PC_IP:5000` (e.g., `http://192.168.1.50:5000`).
4. The high-contrast dashboard should load! Tap the buttons to switch modes.
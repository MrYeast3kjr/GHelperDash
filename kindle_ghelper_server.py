import requests
import pyautogui
import subprocess
from flask import Flask, jsonify, send_file

app = Flask(__name__)

# Configuration
LHM_URL = "http://192.168.1.15:8085/data.json"

@app.route('/')
def index():
    return send_file('kindle_dashboard.html')

@app.route('/data')
def get_data():
    data = {
        "cpu_temp": "N/A",
        "gpu_temp": "N/A"
    }
    try:
        response = requests.get(LHM_URL, timeout=2)
        if response.status_code == 200:
            lhm_data = response.json()
            
            # Recursive function to find sensor values in LHM's nested JSON structure, prioritizing Temperatures
            def find_temp_sensor(node, name, in_temps=False):
                is_temps = in_temps or node.get('Text') == 'Temperatures'
                if node.get('Text') == name and is_temps:
                    return node.get('Value')
                for child in node.get('Children', []):
                    res = find_temp_sensor(child, name, is_temps)
                    if res is not None:
                        return res
                return None
            
            cpu_val = find_temp_sensor(lhm_data, "Core (Tctl/Tdie)")
            if not cpu_val:
                cpu_val = find_temp_sensor(lhm_data, "CPU Package")
            if not cpu_val:
                cpu_val = find_temp_sensor(lhm_data, "Core Average") # Fallback
                
            gpu_val = find_temp_sensor(lhm_data, "GPU Core")
            
            if cpu_val:
                data["cpu_temp"] = cpu_val
            if gpu_val:
                data["gpu_temp"] = gpu_val

    except Exception as e:
        # Fails gracefully if eGPU is disconnected or LHM server is unreachable
        print(f"Error fetching hardware data: {e}")
        pass
        
    return jsonify(data)

@app.route('/mode/<mode>', methods=['POST'])
def set_mode(mode):
    try:
        if mode == 'SILENT':
            pyautogui.hotkey('ctrl', 'shift', 'alt', 'f16')
        elif mode == 'BALANCED':
            pyautogui.hotkey('ctrl', 'shift', 'alt', 'f17')
        elif mode == 'TURBO':
            pyautogui.hotkey('ctrl', 'shift', 'alt', 'f18')
        else:
            return jsonify({"status": "error", "message": "Invalid mode"}), 400
            
        return jsonify({"status": "success", "mode": mode})
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    # Start LibreHardwareMonitor in the background
    try:
        print("Starting LibreHardwareMonitor...")
        subprocess.Popen("librehardwaremonitor", shell=True)
    except Exception as e:
        print(f"Warning: Could not start LibreHardwareMonitor: {e}")

    # Run on all interfaces so the Kindle can access it over the local network
    app.run(host='0.0.0.0', port=5000)
import threading

import pyautogui

from sgs_automatic_Aux import press_keys

monitor_x,monitor_y = 600, 1000
initial_color = pyautogui.pixel(monitor_x, monitor_y)

def check_color_change():
    """检查颜色是否变化，并重新设置定时器"""
    global initial_color
    current_color = pyautogui.pixel(monitor_x, monitor_y)
    if current_color != initial_color:
        print("颜色变化从", initial_color, "变为", current_color)
        press_keys()
        initial_color = current_color  # 更新颜色以便继续监控新的变化
    # 每秒检查一次颜色
    threading.Timer(1, check_color_change).start()

check_color_change()
#!/bin/bash
# 完整测试脚本 - 端口39433

echo "=========================================="
echo "手机传感器 -> PC 3D可视化测试"
echo "端口: 39433"
echo "=========================================="
echo ""

# 检查Godot路径
GODOT_PATH=$(which godot 2>/dev/null || echo "/d/tools/Godot_v4.3-stable_win64.exe")
if [ ! -f "$GODOT_PATH" ]; then
    GODOT_PATH="godot"
fi

echo "步骤1: 构建PC端 (Windows可执行文件)"
echo "------------------------------------------"
cd /c/Users/Administrator/Desktop/godot_pingpong/godot_server
$GODOT_PATH --headless --export-release "Windows Desktop" ./sensor_server.exe 2>&1
if [ -f "./sensor_server.exe" ]; then
    echo "PC端构建成功: sensor_server.exe"
else
    echo "PC端构建失败，将从编辑器运行"
fi
echo ""

echo "步骤2: 构建手机端 (Android APK)"
echo "------------------------------------------"
cd /c/Users/Administrator/Desktop/godot_pingpong/godot_client

# 导出未签名APK
$GODOT_PATH --headless --export-release "Android" ./sensor_display_unsigned.apk 2>&1

# 签名
if [ -f "./sensor_display_unsigned.apk" ]; then
    $ANDROID_HOME/build-tools/34.0.0/apksigner.bat sign \
        --ks ./debug.keystore \
        --ks-pass pass:android \
        --key-pass pass:android \
        --out ./sensor_display.apk \
        ./sensor_display_unsigned.apk
    rm ./sensor_display_unsigned.apk
    echo "手机端构建成功: sensor_display.apk"
else
    echo "手机端构建失败"
    exit 1
fi
echo ""

echo "步骤3: 部署到手机"
echo "------------------------------------------"
adb devices
adb install -r ./sensor_display.apk
echo ""

echo "=========================================="
echo "测试步骤:"
echo "=========================================="
echo "1. 在PC上运行 godot_server/sensor_server.exe"
echo "   或从Godot编辑器运行 godot_server项目"
echo ""
echo "2. 在手机上打开传感器应用"
echo "   确认显示'状态: 正常发送数据'"
echo ""
echo "3. PC端应显示3D手机模型和轨迹"
echo ""
echo "4. 在PC端查看调试输出，确认收到数据"
echo ""
echo "网络配置:"
echo "  手机 -> PC:UDP 39433"
echo "=========================================="

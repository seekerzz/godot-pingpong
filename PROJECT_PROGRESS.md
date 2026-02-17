# Godot 传感器数据传输与 3D 可视化项目 - 进度文档

**最后更新**: 2026-02-15 18:20

---

## 项目概述

本项目实现了一套完整的手机传感器数据采集、传输、录制和 3D 可视化系统。

- **手机端**: Godot 4.3 Android 应用，采集传感器数据并通过 UDP 发送到电脑
- **电脑端**: Godot 4.3 PC 应用，接收数据并显示 3D 轨迹可视化

---

## 功能清单

### 手机端功能 (godot_client/)

#### 1. 实时数据传输
- 采集加速度计、陀螺仪、重力传感器、磁力计数据
- 通过 UDP 协议发送到电脑端 (IP: 192.168.50.64, 端口: 49555)
- 发送频率: 20Hz (每 50ms 一帧)

#### 2. 录制功能
- 点击"开始录制"按钮开始记录传感器数据
- 点击"结束录制"保存到本地文件
- 文件命名格式: `record_YYYYMMDD_HHMMSS.json`
- 文件内容包括:
  - 录制日期时间
  - 帧数统计
  - 录制时长
  - 所有传感器帧数据

#### 3. 录制回放
- 列表显示所有已保存的录制文件
- 选择录制文件后点击"开始回放"
- 数据通过 UDP 发送到电脑端重新播放
- 显示回放进度条
- 支持删除不需要的录制文件

#### 4. UI 界面
- 实时显示传感器数值
- 录制状态指示
- 录制列表管理
- 回放控制按钮

---

### 电脑端功能 (godot_server/)

#### 1. 实时接收与可视化
- UDP 服务器监听端口 49555
- 3D 手机模型实时旋转和位置更新
- 运动轨迹记录和显示
- 地面网格参考

#### 2. 录制数据接收
- 接收手机端实时录制数据
- 保存到本地文件
- 接收回放数据并缓存

#### 3. 本地回放与调试
- **L 键**: 加载最新的录制文件
- **P 键**: 开始/停止本地回放
- **S 键**: 保存接收到的回放数据
- 逐帧回放便于调试算法

#### 4. 3D 场景控制
- **R 键**: 重置视角和位置
- **C 键**: 清除轨迹
- **ESC 键**: 退出程序

---

## 文件结构

```
godot_pingpong/
├── godot_client/                    # 手机端项目
│   ├── sensor_sender.gd            # 主脚本: 传感器采集、录制、回放
│   ├── main.tscn                   # 主场景: UI 布局
│   ├── export_presets.cfg          # Android 导出配置
│   ├── debug.keystore              # Android 调试签名
│   ├── sensor_display.apk          # 编译好的 APK (24MB)
│   └── android/                     # Android 构建模板
│       └── build/
│
├── godot_server/                    # 电脑端项目
│   ├── sensor_server.gd            # 主脚本: 数据接收、3D 可视化、回放
│   ├── main.tscn                   # 主场景: 3D 场景和 UI
│   └── phone_visualizer.gd         # 手机模型可视化脚本
│
└── PROJECT_PROGRESS.md             # 本文件
```

---

## 数据格式

### 实时传感器数据
```json
{
  "accel": {"x": 0.123, "y": 0.456, "z": 9.801},
  "gyro": {"x": 0.001, "y": -0.002, "z": 0.003},
  "gravity": {"x": 0.0, "y": 0.0, "z": 9.8},
  "magneto": {"x": 25.3, "y": 12.1, "z": -40.2},
  "timestamp": 1771149060.511,
  "recorded": false
}
```

### 录制文件格式
```json
{
  "record_date": "2024-02-15 14:30:25",
  "frame_count": 200,
  "duration": 10.0,
  "frames": [
    {
      "accel": {"x": 0.123, "y": 0.456, "z": 9.801},
      "gyro": {"x": 0.001, "y": -0.002, "z": 0.003},
      "gravity": {"x": 0.0, "y": 0.0, "z": 9.8},
      "magneto": {"x": 25.3, "y": 12.1, "z": -40.2},
      "timestamp": 1771149060.511,
      "recorded": true
    },
    ...
  ]
}
```

### 标记消息类型
- `record_start`: 开始录制标记
- `record_stop`: 结束录制标记
- `playback_start`: 开始回放标记 (含文件名和帧数)
- `playback_stop`: 停止回放标记

---

## 使用方法

### 手机端

1. **实时传输**
   - 打开应用，确保手机和电脑在同一 WiFi
   - 应用会自动发送传感器数据到电脑

2. **录制动作**
   - 点击"开始录制"按钮
   - 执行动作
   - 点击"结束录制"按钮保存

3. **回放录制**
   - 从列表中选择一个录制文件
   - 点击"开始回放"发送到电脑
   - 或点击"删除"移除不需要的文件

### 电脑端

1. **启动服务器**
   - 运行 Godot 项目
   - 服务器自动启动并监听端口 49555

2. **接收数据**
   - 自动接收手机实时数据或回放数据
   - 3D 模型会实时更新

3. **回放调试**
   - 按 **L** 加载本地录制文件
   - 按 **P** 开始/停止回放
   - 按 **S** 保存接收到的回放数据
   - 按 **R** 重置视角
   - 按 **C** 清除轨迹

---

## Git 提交历史

```
godot_client:
- d20c811 Fix recording frame saving and add playback debug
- f6db5d8 Add recording playback system
- 4197649 Rollback pairing system, keep recording feature

godot_server:
- 61bce5d Add debug logging for playback
- 8ae32e2 Add recording playback and debugging system
- 37b3992 Rollback pairing system, keep recording feature

主仓库:
- 39319e6 Add project progress documentation
```

---

## 已知问题

1. **APK 导出**: 需要使用 `--export-debug` 并手动签名
2. **网络连接**: 需要手机和电脑在同一局域网
3. **轨迹漂移**: 当前算法存在积分漂移问题，需要后续优化

---

## 测试状态

### 2026-02-15 测试记录

#### 已测试通过 ✅
- [x] 实时数据传输（手机→电脑）
- [x] 3D 模型实时跟随手机旋转
- [x] 录制功能（开始/停止录制）
- [x] 录制文件保存到本地
- [x] 录制列表显示

#### 待进一步测试 ⏳
- [ ] 回放功能（数据从手机发送到电脑）
- [ ] 电脑端接收回放数据并播放
- [ ] 本地回放（按 L/P 键）

#### 发现的问题 🔧
1. **录制帧数为 0** - 已修复：send_sensor_data 中未保存帧到 recorded_frames
2. **回放无反应** - 添加调试日志，需要进一步测试验证
3. **轨迹漂移** - 算法问题，需要后续优化

### 2026-02-15 姿态估计算法修复

#### 修复内容 ✅
1. **坐标系转换** - 新增 `convert_android_to_godot()` 函数
   - Android: X右, Y上, Z朝向用户（屏幕外）
   - Godot: X右, Y上, Z朝向屏幕内
   - 修复了Z轴方向相反导致的姿态镜像问题

2. **姿态计算逻辑重写** - 使用互补滤波策略
   - 基于重力计算绝对俯仰和横滚（无累积误差）
   - 陀螺仪仅用于偏航角（yaw）积分
   - 添加 `_current_yaw` 状态变量跟踪水平旋转
   - 修复了重力旋转与陀螺仪积分的双重计算问题

3. **磁力计融合** - 添加 `compute_yaw_from_magneto()` 函数
   - 使用磁力计计算绝对航向
   - 互补滤波缓慢修正偏航角漂移（2%融合比例）

4. **代码清理** - 删除重复的 `reset_view_with_calibration()` 函数定义

#### 新增函数
- `convert_android_to_godot(v: Vector3) -> Vector3`
- `compute_rotation_from_gravity(gravity: Vector3) -> Quaternion`
- `compute_yaw_from_magneto(magneto: Vector3, pitch: float, roll: float) -> float`

#### 待测试 ⏳
- [ ] 手机姿态是否正确映射到3D模型（平放时是否水平）
- [ ] 偏航角积分是否稳定
- [ ] 磁力计校准效果

### 2026-02-15 姿态和轨迹修复 - 当前状态

#### 已修复问题 ✅
1. **姿态显示问题** - 重写 `compute_imu_orientation` 函数
   - 使用完整的基向量构建旋转矩阵（X/Y/Z三轴）
   - 正确映射坐标系：Android Z向屏幕外 -> Godot Y向上
   - 添加模型修正旋转，确保平放时模型水平

2. **位置计算Bug** - 修复 `_update_position_improved` 函数
   - 删除重复的位置更新代码（原第449行和第462行重复）
   - 实现零速更新(ZUPT)算法，静止时自动衰减速度
   - 添加运动检测和加速度滤波
   - 降低积分系数，减少漂移累积

#### 当前实现
**姿态计算 (`compute_imu_orientation`)**：
- 基于重力向量构建完整坐标系
- X轴：Y轴与世界前向的叉积
- Y轴：与重力相反方向（向上）
- Z轴：X轴与Y轴的叉积
- 模型修正：绕X轴-90度旋转

**轨迹计算 (`_update_position_improved`)**：
- 运动阈值：0.3 m/s²
- 零速更新：连续5帧静止时速度快速衰减
- 速度阻尼：运动时0.95，静止时0.8
- 最大速度限制：3 m/s
- 运动范围：±10米

#### 待测试
- [ ] 手机平放时模型是否水平
- [ ] 手机旋转时姿态是否正确跟随
- [ ] 挥动时轨迹是否正确跟随
- [ ] 静止时轨迹是否停止漂移

---

## 下一步计划

- [ ] 完成回放功能测试和调试
- [ ] 优化轨迹算法，减少漂移误差
- [ ] 添加更多滤波算法（卡尔曼滤波）
- [ ] 支持多段录制拼接
- [ ] 添加录制文件导出/分享功能
- [ ] 电脑端添加录制文件列表 UI

---

## 技术栈

- **引擎**: Godot 4.3
- **语言**: GDScript
- **网络**: UDP (PacketPeerUDP)
- **平台**: Android (手机端), Windows (电脑端)
- **数据格式**: JSON

---

## 网络配置

- **电脑 IP**: 192.168.50.64
- **端口**: 49555 (固定)
- **协议**: UDP

---

---

## 2026-02-17 协议重构与姿态校准

### 主要变更

#### 通信协议升级
- **旧协议**: JSON文本格式，包含原始传感器数据（accel, gyro, gravity, magneto）
- **新协议**: 二进制流（28字节固定包）
  - UserAccel.x/y/z (float, 12 bytes) - 剔除重力后的线性加速度
  - Quaternion.x/y/z/w (float, 16 bytes) - 融合后的姿态

#### 客户端重构 (godot_client/sensor_sender.gd)
1. **发送频率**: 从 `_process` 的20Hz移动到 `_physics_process` 的60Hz
2. **传感器融合**:
   - UserAccel = accelerometer - gravity，模长<0.2时归零防抖
   - 基于重力和陀螺仪计算姿态四元数
3. **二进制协议**: 使用 StreamPeerBuffer 打包28字节数据
4. **录制格式更新**: 保存 user_accel + quaternion 结构
5. **回放适配**: 使用与实时相同的二进制协议发送

#### 服务端重构 (godot_server/sensor_server.gd)
1. **二进制解析**: 使用 StreamPeerBuffer 解析28字节数据包
2. **抗漂移算法** (弹性回中):
   ```gdscript
   velocity += user_accel * delta
   velocity = velocity.lerp(Vector3.ZERO, friction * delta)
   position += velocity * delta
   position = position.lerp(origin_position, return_speed * delta)
   ```
3. **导出变量**: friction=5.0, return_speed=2.0（可在编辑器调整）
4. **可视化升级**: 手机模型 → 乒乓球拍模型
   - Pivot: 旋转中心（手柄底部）
   - Handle: 棕色圆柱体手柄
   - Face: 红色/黑色双面橡胶拍面
   - TrailEmitter: GPUParticles3D拖尾效果
   - Lightsaber: 光剑效果显示加速度方向和大小
5. **调试辅助**: Label3D显示UserAccel模长

#### 姿态校准系统 (新增)
1. **校准按钮**: UI中添加"校准姿态 (K)"按钮
2. **四步校准流程**:
   - 步骤1: 标准平放（屏幕向上，底部朝向玩家）
   - 步骤2: 向右旋转90度
   - 步骤3: 向左旋转90度
   - 步骤4: 竖直握持（屏幕朝向玩家）
3. **校准数据保存**: 保存到 `calibration_data.json`
4. **坐标转换**: 基于校准数据优化 `(x, y, z, w) → (x, -z, y, w)`

### 当前坐标映射 (基于校准数据)
| Android | → | Godot |
|---------|---|-------|
| X (右) | → | X (右) |
| Y (顶部) | → | -Z (朝向屏幕/远方) |
| Z (屏幕外/上) | → | Y (上/天空) |

### 待解决问题
- [ ] 姿态对齐验证：手机平放时球拍是否正确显示
- [ ] 坐标系精确调整：可能需要进一步校准

### 人工验证清单

#### 客户端验证
- [x] 手机端显示的UserAccel数值平稳，静止时接近(0,0,0)
- [x] 点击"回放"时，服务端能接收到数据并产生动作
- [x] 代码中使用 StreamPeerBuffer 进行打包

#### 服务端验证
- [ ] 手持手机静止时，球拍模型自动回到屏幕中心
- [ ] 快速挥动手机，球拍有明显挥动动作和拖尾
- [ ] 停止挥动后球拍迅速复位
- [ ] 球拍绕着手柄底部旋转（而非中心）
- [ ] 姿态对齐：手机平放时球拍水平，手柄朝向玩家

---

*文档结束*

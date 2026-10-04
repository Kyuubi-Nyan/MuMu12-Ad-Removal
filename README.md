# MuMu模拟器12去广告工具（MuTools 修改版）

> 搜索关键词：MuMu 去广告、MuMu12 去广告、MuMu 纯净版、MuMu 模拟器优化、MuMu 禁止更新、MuMu 禁用遥测、MuTools。

本项目是基于 **MuToolsProject** 整理和发布的 GPL-3.0 修改版说明仓库。MuTools 是一个面向 Windows 的 MuMu 模拟器 12 安装与优化工具，支持去除开屏广告、消息中心广告、模拟器内桌面广告，并提供禁止更新、禁用遥测、模拟器信息检测等功能。

> 本仓库不是 MuMu 官方项目，与 MuMu 官方没有任何隶属或合作关系。

## 功能特性

- **MuMu 安装**：支持在线安装和本地安装包安装。
- **去开屏广告**：修改 `startupImage` 文件夹。
- **去消息中心广告**：通过 hosts 代理、防火墙规则等方式处理广告连接。
- **去模拟器桌面广告**：使用优化数据包处理模拟器内桌面广告。
- **禁止模拟器更新**：支持 hosts 代理和修改更新程序文件。
- **禁用 MuMu 遥测**：阻断遥测相关域名。
- **仿专版 / 海外版修改**：支持 MuMu12 V4/V5/V6 的部分版本。
- **MuMu 信息检测**：显示版本、渠道、安装目录、管理器路径等信息。
- **批量优化**：可以一次勾选多个优化项目后统一执行。

## 安装和使用教程

### 方式一：直接使用便携版（推荐）

1. 打开本仓库右侧的 **Releases** 页面，下载 `MuTools.exe`。
2. 完全退出 MuMu 模拟器，并关闭正在运行的模拟器多开实例。
3. 建议右键 `MuTools.exe`，选择 **以管理员身份运行**。工具会修改 hosts、防火墙或模拟器文件，部分功能需要管理员权限。
4. 打开工具后进入 **MuMu 信息**，先确认是否能正确识别 MuMu12 的版本和安装路径。
5. 进入 **优化** 页面，根据需求勾选项目：
   - **开屏广告**：去除启动时的开屏广告。
   - **消息中心广告**：处理消息中心的广告连接。
   - **模拟器内桌面广告**：导入优化数据包，去除模拟器桌面的广告内容。
   - **禁止更新**：阻止模拟器自动更新。
   - **MuMu 遥测**：阻断遥测相关连接。
6. 点击 **开始优化**，等待工具提示完成。
7. 重新启动 MuMu 模拟器，检查广告是否已经消失。
8. 如果之后需要恢复，可以在同一页面点击 **撤销优化**，再重启 MuMu。

> 使用前建议先备份模拟器中的重要数据。不同 MuMu 版本的文件结构可能不同，V4、V5、V6 的优化效果也可能不同。

## 资源包下载

MuTools 的 7-Zip 和 aria2 资源包可以从本仓库的资源包 Release 获取：

- [MuTools 资源包 Release](https://github.com/Kyuubi-Nyan/MuMu12-Ad-Removal/releases/tag/resources-v1.0.0)
- [资源包说明和校验值](https://github.com/Kyuubi-Nyan/MuMu12-Ad-Removal/blob/main/RESOURCES.md)

视频中的 DataPart 和 RuntimeChecker 没有找到公开、可信的原始下载来源，暂时没有转载。请查看 RESOURCES.md。

### 方式二：从源码构建

构建环境：

- Windows 10/11 64 位
- Node.js 20 或更高版本
- Rust stable（MSVC 工具链）
- Visual Studio Build Tools，并安装“使用 C++ 的桌面开发”
- Microsoft Edge WebView2 Runtime

构建命令：

```powershell
cd MuToolsCode
npm install
npm run tauri build
```

构建完成后的程序位于：

```text
MuToolsCode/src-tauri/target/release/mutools.exe
```

### 方式三：使用工具安装 MuMu

工具内也提供在线安装和本地安装功能：

- **在线安装**：由工具获取安装资源并下载。
- **本地安装**：适合在线源不可用或网络不稳定的情况，需要先准备 MuMu 安装包。

## 视频参考

原视频教程和演示：

- [Bilibili：MuTools 一键管理 MuMu 模拟器](https://www.bilibili.com/video/BV1fuY46oEJE/)
- [原项目作者的演示视频](https://www.bilibili.com/video/BV1JPtA6LEaA/)

## 常见问题

### 1. 工具检测不到 MuMu

先确认 MuMu12 已正确安装，并至少启动过一次。如果仍然检测不到，尝试以管理员身份运行 MuTools，或在工具中检查版本选择和安装目录。

### 2. 为什么提示需要管理员权限？

去除广告、修改 hosts、添加防火墙规则、修改模拟器文件等操作需要系统权限，确认来源可信后再允许。

### 3. 杀毒软件报警正常吗？

这类工具会修改 hosts、模拟器更新程序和部分安装文件，因此可能被安全软件标记。请不要直接关闭安全软件；先核对文件来源和哈希，确认后再决定是否允许。

### 4. 禁止更新后会怎样？

MuMu 将无法正常使用自动更新和部分在线更新功能。需要更新时，请先撤销相关优化，或者重新安装新版本。

### 5. 去除桌面广告后，多开图标不见了？

这是部分数据包优化方案的已知副作用，多开应用可以从 MuMu 多开管理器中启动。

### 6. 可以恢复吗？

可以。大多数项目都提供对应的撤销功能。请回到 **优化** 页面选择 **撤销优化**，完成后重启 MuMu。

## 项目目录

```text
MuToolsProject/
├── MuToolsCode/                 # 主程序：前端 + Tauri + Rust 后端
│   ├── src/                     # 前端页面与逻辑
│   └── src-tauri/               # Rust 后端、下载、优化和信息检测
├── Tools_desc_generator/        # 资源包描述生成器
├── Tools_portable_builder/      # 便携版构建工具
├── LICENSE                      # GPL-3.0 许可证
├── UPSTREAM_README.md           # 原项目 README 备份
└── build.bat                    # 构建脚本
```

## 来源、修改记录和开源协议

- 原项目：[godeargit/MuToolsProject](https://github.com/godeargit/MuToolsProject)
- 本仓库是独立的 GPL-3.0 发布整理版，代码来源于原项目。
- 本次发布主要修改：补充公开仓库说明、使用教程、免责声明和发布打包说明；程序源码未做额外功能修改。
- 本仓库保留原项目的 `LICENSE`，继续使用 **GNU GPL v3.0**。
- 发布编译版时，对应源码可在本仓库获取，符合 GPL-3.0 的源码提供要求。
- 项目中涉及的 7-Zip、aria2 等第三方组件遵循其各自的许可证，详见原项目和相关组件发布页。

## 免责声明

- MuTools 是第三方非官方工具，与 MuMu 官方无关。
- 请仅将本项目用于个人学习、测试和合法的系统维护用途。
- 使用优化、禁止更新、修改 hosts 或修改模拟器文件存在风险，请先备份数据。
- 因使用本工具导致的模拟器异常、数据丢失、更新失败或其他问题，由使用者自行承担风险。
- 请遵守 MuMu 软件许可协议以及所在地适用的法律法规。
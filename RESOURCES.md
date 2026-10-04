# MuTools 资源包说明

视频中出现的资源包并不在 [MuToolsProject](https://github.com/godeargit/MuToolsProject) 的 GitHub 源码仓库里。原作者的旧仓库 `pipicat613/MuToolsProject` 已经删除，公开搜索也没有找到可信的 DataPart、RuntimeChecker 下载来源。

## 本仓库提供的资源包

以下两个资源包由官方发布的 32 位程序重新封装，可直接在 MuTools 的“资源包管理”中安装：

| 文件 | 来源 | 作用 |
| --- | --- | --- |
| `7zip_Win_x86_32bit_26.02.exe` | 7-Zip 26.02 官方 x86 版 | 解压 `.7z` 资源包 |
| `aria2_Win_x86_32bit_1.37.0_1.exe` | aria2 1.37.0 官方 win-32bit build1 | 加速资源下载 |

下载地址：

- [7zip_Win_x86_32bit_26.02.exe](https://github.com/Kyuubi-Nyan/MuMu12-Ad-Removal/releases/download/resources-v1.0.0/7zip_Win_x86_32bit_26.02.exe)
- [aria2_Win_x86_32bit_1.37.0_1.exe](https://github.com/Kyuubi-Nyan/MuMu12-Ad-Removal/releases/download/resources-v1.0.0/aria2_Win_x86_32bit_1.37.0_1.exe)
- [SHA256SUMS.txt](https://github.com/Kyuubi-Nyan/MuMu12-Ad-Removal/releases/download/resources-v1.0.0/SHA256SUMS.txt)

安装后目录应为：

```text
MuTools/resources/7zip/7z.exe
MuTools/resources/aria2/aria2c.exe
```

## DataPart 和 RuntimeChecker

- `DataPart_1.0.0_4.1.38.exe`、`DataPart_1.0.0_5.30.1.exe` 很可能是从 MuMu 模拟器导出的 `.mumudata` 优化数据，可能包含 MuMu 的非开源数据，不能确认授权前不建议转载到公开仓库。
- `RuntimeChecker_1.0.0.exe` 同样没有找到公开、可信的下载来源。
- 这两个部分建议向 B 站视频作者获取；如果拿到文件并确认可以公开分发，再上传到本仓库的 Release。

## 使用方法

1. 运行 MuTools。
2. 打开“资源包管理”。
3. 点击“安装资源包”。
4. 安装方式选择“本地”，选择下载的 `.exe`。
5. 安装完成后刷新列表，确认出现 7zip 和 aria2。
6. 7-Zip 是处理 `.7z` 资源包的前置组件，aria2 用于加速部分下载。

## 安全提醒

只从本仓库 Release、7-Zip 官网或 aria2 官方 Release 下载。安装前建议核对 `SHA256SUMS.txt`，不要运行来源不明的 DataPart 或 RuntimeChecker 文件。
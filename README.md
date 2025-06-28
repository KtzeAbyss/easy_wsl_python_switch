# easy_wsl_python_switch
本脚本是为了方便windows用户在wsl环境中使用claude code开发时，可以直接使用原有的python环境，并支持快速切换
不支持搜索Linux python且与pyenv不兼容，因为原生开发者可能并不需要使用这个工具
# switchpy.sh
以下指南由AI自动生成

在 WSL / Ubuntu（或任何 Bash Shell）中一键切换 Windows Conda / Miniforge 环境，让 `python` 命令指向你想要的解释器。  
支持多根目录扫描、持久化配置，自动写入 `PATH` 与 `switchpy` 快捷命令。

## ✨ 功能亮点

- **自动扫描**：在你指定的一个或多个根目录内（深度 ≤ 2）搜索所有 `python.exe`。
- **交互选择**：列出环境路径与对应 Python 版本，输入序号即可切换。
- **零侵入**：为所选解释器生成 `~/.local/bin/python` 包装器，不改动原 Conda 环境。
- **自动配置**：  
  - 把 `~/.local/bin` 写入 `PATH`（仅首次）。  
  - 写入 `alias switchpy='source /absolute/path/switchpy.sh'`，以后随时 `switchpy` 再次切换。
- **支持重置**：`switchpy --reset` 可重新指定扫描目录。
- **安全易卸**：删除几行 `# added by switchpy` 即可恢复原状态。

## 📦 安装

```bash
# 1. 下载脚本（或 git clone 本仓库）
wget https://raw.githubusercontent.com/<yourname>/<repo>/main/switchpy.sh -O ~/switchpy.sh

# 2. 赋可执行权（可选，source 调用其实不需要）
chmod +x ~/switchpy.sh
```

> 你可以把脚本放在任意位置，脚本会自动记录绝对路径并写入 alias。

## 🚀 快速开始

```bash
# 第一次运行（会提示输入环境根目录列表）
source ~/switchpy.sh

# 选择序号后脚本会：
# 1. 生成 ~/.local/bin/python 指向所选 python.exe
# 2. 将 ~/.local/bin 写入 PATH（若尚未存在）
# 3. 写入 alias switchpy
# 4. 提醒你执行 source ~/.bashrc
```

```bash
source ~/.bashrc   # 或重新打开终端
python --version   # 验证已切换
```

此后想切换解释器，只需：

```bash
switchpy           # alias，脚本已生成
```

若要修改扫描目录：

```bash
switchpy --reset
```

## 🔧 卸载 / 复原

1. 删除 `~/.local/bin/python`（或整个 `~/.local/bin` 中由脚本生成的包装器）。  
2. 删除 `~/.python_env_dirs` 配置文件（可选）。  
3. 编辑 `~/.bashrc`，移除带有 `# added by switchpy` 标记的行。  

完成后重新加载 Shell 即恢复原 `python` 解释器。

## ❓ FAQ

| 问题 | 解决 |
|------|------|
| 已有其他 Python 版本在 PATH | `~/.local/bin` 位于 PATH 最前，可覆盖；需要时随时 `switchpy` 切换。 |
| Zsh / fish 能用吗？ | 脚本为 Bash 语法，可在 Zsh 通过 `source` 运行；但自动写入的 alias 只写入 `~/.bashrc`，需手动复制到对应 rc 文件。 |
| 找不到我的环境 | 确保输入的根目录正确，且 `python.exe` 位于两级目录以内，例如 `D:/app_code/miniforge3/envs/your_env/python.exe`。 |
| 能否切换 Linux 原生 Conda env？ | 目前脚本仅搜索 `python.exe`（Windows 环境），如需支持 `python` 可自行修改 `find` 命令。 |

## 📝 License

MIT

Happy switching! 🎉

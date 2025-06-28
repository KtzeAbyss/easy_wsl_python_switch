#!/usr/bin/env bash
# 文件: switchpy.sh
# 用法:
#   source /path/to/switchpy.sh          # 选择并激活解释器
#   source /path/to/switchpy.sh --reset  # 重新设置扫描目录

CFG="$HOME/.python_env_dirs"   # 保存扫描根目录，一行一个
MARKER="# added by switchpy"   # 标识，用于避免重复写入

# ---------- 配置目录 ----------
if [[ "$1" == "--reset" || ! -s "$CFG" ]]; then
    echo "请输入要扫描的环境根目录(可输入多个，空格分隔)，例如:"
    echo "/mnt/d/app_code/miniforge3/envs /mnt/e/other/envs"
    read -rp "目录: " input_dirs
    : >"$CFG"                  # 清空并写入
    for p in $input_dirs; do
        [[ -d "$p" ]] && echo "$p" >>"$CFG"
    done
    echo "已保存目录到 $CFG"
fi

mapfile -t DIRS <"$CFG"
[[ ${#DIRS[@]} -eq 0 ]] && { echo "配置为空，请执行 '--reset'"; return; }

# ---------- 搜索环境 ----------
envs=()
for base in "${DIRS[@]}"; do
    while IFS= read -r -d '' exe; do envs+=("$exe"); done \
        < <(find "$base" -maxdepth 2 -type f -name "python.exe" -print0)
done
[[ ${#envs[@]} -eq 0 ]] && { echo "未找到 python.exe"; return; }

echo "可用环境:"
for i in "${!envs[@]}"; do
    ver=$("${envs[$i]}" --version 2>/dev/null | awk '{print $2}')
    printf " [%d] %s (Python %s)\n" "$i" "$(dirname "${envs[$i]}")" "$ver"
done

read -rp "选择序号: " idx
[[ "$idx" =~ ^[0-9]+$ && $idx -ge 0 && $idx -lt ${#envs[@]} ]] || { echo "序号无效"; return; }

PY_EXE="${envs[$idx]}"
echo "已选择: $PY_EXE"

# ---------- 更新 PATH ----------
BIN="$HOME/.local/bin"
mkdir -p "$BIN"
cat >"$BIN/python" <<EOF
#!/usr/bin/env bash
exec "$PY_EXE" "\$@"
EOF
chmod +x "$BIN/python"

# 把 ~/.local/bin 放到 PATH 开头（仅第一次写入）
grep -q "$MARKER PATH" "$HOME/.bashrc" 2>/dev/null || \
echo "export PATH=\"\$HOME/.local/bin:\$PATH\" $MARKER PATH" >>"$HOME/.bashrc"

# ---------- 自动写 alias ----------
SCRIPT_ABS="$(readlink -f "${BASH_SOURCE[0]}")"
ALIAS_LINE="alias switchpy='source $SCRIPT_ABS'"
grep -F "$ALIAS_LINE" "$HOME/.bashrc" 2>/dev/null || \
echo "$ALIAS_LINE $MARKER ALIAS" >>"$HOME/.bashrc"
### <<< alias block <<<

echo "完成！执行 'source ~/.bashrc' 或重新打开终端即可生效。"
#!/usr/bin/env bash
#
# auto-mount.sh —— 永久挂载硬盘的 5 步流程演示
# 源自 Week02 笔记"实践"小节（永久挂载 5 步）
#
# 用途：给面试官 / GitHub 访客演示"我能做磁盘挂载这件事"
# 默认是 dry-run（只打印命令、不实际执行），避免误改系统
# 真正执行：sudo bash auto-mount.sh --apply
#
# 5 步流程：
#   1. 创建挂载目录
#   2. 查看设备 UUID
#   3. 备份并追加到 /etc/fstab
#   4. mount -a 测试配置
#   5. 验证挂载结果

set -euo pipefail

# ---------- 参数 ----------
APPLY=false
if [[ "${1:-}" == "--apply" ]]; then
    APPLY=true
fi

DEVICE="${DEVICE:-/dev/sdb1}"
MOUNT_POINT="${MOUNT_POINT:-/newdisk}"
FSTYPE="${FSTYPE:-ext4}"

# ---------- 颜色 ----------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ---------- 辅助函数 ----------
run() {
    local desc="$1"; shift
    echo -e "${YELLOW}▶ $desc${NC}"
    echo -e "  ${GREEN}\$$*${NC}"
    if [[ "$APPLY" == true ]]; then
        "$@"
    else
        echo "  （dry-run，未执行）"
    fi
    echo
}

# ---------- 步骤 1 ----------
echo "==== 步骤 1：创建挂载目录 ===="
run "创建 $MOUNT_POINT 目录" sudo mkdir -p "$MOUNT_POINT"

# ---------- 步骤 2 ----------
echo "==== 步骤 2：查看设备 UUID ===="
run "查看 $DEVICE 的 UUID" sudo blkid "$DEVICE"
UUID=$(sudo blkid -s UUID -o value "$DEVICE" 2>/dev/null || true)
if [[ -z "$UUID" ]]; then
    if [[ "$APPLY" == true ]]; then
        echo -e "${RED}✗ 拿不到 UUID，请检查 $DEVICE 是否存在并已被格式化${NC}"
        exit 1
    else
        UUID="<dry-run-uuid>"
        echo "  ⚠ dry-run 模式拿不到真实 UUID，使用占位符演示"
    fi
fi
echo "  UUID = $UUID"
echo

# ---------- 步骤 3 ----------
echo "==== 步骤 3：备份 fstab 并追加新行 ===="
FSTAB_LINE="UUID=$UUID  $MOUNT_POINT  $FSTYPE  defaults  0  0"
run "显示将追加的 fstab 行" echo "$FSTAB_LINE"
if [[ "$APPLY" == true ]]; then
    BACKUP="/etc/fstab.bak.$(date +%Y%m%d%H%M%S)"
    run "备份原 fstab" sudo cp /etc/fstab "$BACKUP"
    echo "$FSTAB_LINE" | sudo tee -a /etc/fstab > /dev/null
    echo "  已追加新行"
fi
echo

# ---------- 步骤 4 ----------
echo "==== 步骤 4：mount -a 测试配置 ===="
run "测试 fstab 配置" sudo mount -a
echo "  ⚠ 如果 mount -a 报错，千万别重启机器！"
echo "  ⚠ 先改对文件再试，否则开机进不了系统"
echo

# ---------- 步骤 5 ----------
echo "==== 步骤 5：验证挂载 ===="
run "查看设备挂载情况" lsblk -f "$DEVICE"
run "查 df 看容量" df -h "$MOUNT_POINT"
echo

# ---------- 收尾 ----------
echo "==== 完成 ===="
if [[ "$APPLY" == false ]]; then
    echo -e "${YELLOW}当前是 dry-run 模式（只打印，未执行）。${NC}"
    echo -e "真正执行：sudo bash $0 --apply"
    echo
    echo "  示例：自定义设备和挂载点"
    echo "  DEVICE=/dev/sdc1 MOUNT_POINT=/data sudo bash $0 --apply"
fi

#!/bin/sh
# Pre-push hook — 保护本地目录不被推到远程
#
# 安装方法（在项目根目录执行）：
#   cp note-taking_copilot/scripts/pre-push-hook.sh .git/hooks/pre-push
#   chmod +x .git/hooks/pre-push
#
# .claude/ 和 note-taking_copilot/ 只在本地 git 管理，
# 不允许被推送到 GitHub 或其他 remote。
#
# 绕过方式：git push --no-verify

PROTECTED_PATHS=".claude/ note-taking_copilot/"
ZERO_OID="0000000000000000000000000000000000000000"

while read local_ref local_oid remote_ref remote_oid; do
    # 跳过删除操作（local_oid 是全零）
    if [ "$local_oid" = "$ZERO_OID" ]; then
        continue
    fi

    # 确定比较范围
    if [ "$remote_oid" = "$ZERO_OID" ]; then
        range="HEAD"
    else
        range="$remote_oid..$local_oid"
    fi

    for path in $PROTECTED_PATHS; do
        if git diff --name-only "$range" -- "$path" 2>/dev/null | grep -q .; then
            echo ""
            echo "🚫 Push rejected!"
            echo "   受保护的目录 '$path' 包含在本次 push 中。"
            echo "   该目录仅限本地 commit，不得推送到远程。"
            echo ""
            echo "   如果你确定要强制推送："
            echo "   git push --no-verify origin $local_ref"
            echo ""
            exit 1
        fi
    done
done

exit 0

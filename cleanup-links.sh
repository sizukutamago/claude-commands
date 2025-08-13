#!/bin/bash

# Claude Commands Cleanup Script
# このスクリプトは ~/.claude/commands からシンボリックリンクを削除します

set -e

# 色付きメッセージ用の関数
print_success() {
    echo -e "\033[32m✓\033[0m $1"
}

print_error() {
    echo -e "\033[31m✗\033[0m $1"
}

print_info() {
    echo -e "\033[34mℹ\033[0m $1"
}

print_warning() {
    echo -e "\033[33m⚠\033[0m $1"
}

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$SCRIPT_DIR/commands"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

print_info "Claude Commands クリーンアップを開始します..."

# ~/.claude/commands ディレクトリの存在確認
if [ ! -d "$CLAUDE_COMMANDS_DIR" ]; then
    print_info "~/.claude/commands ディレクトリが存在しません"
    exit 0
fi

# このリポジトリのコマンドへのリンクを検索
LINKS_TO_REMOVE=()
for link in "$CLAUDE_COMMANDS_DIR"/*.md; do
    if [ -L "$link" ]; then
        # リンク先を取得
        target=$(readlink "$link")
        # このリポジトリのファイルへのリンクかチェック
        if [[ "$target" == "$COMMANDS_DIR"/* ]]; then
            LINKS_TO_REMOVE+=("$link")
        fi
    fi
done

# 削除対象がない場合
if [ ${#LINKS_TO_REMOVE[@]} -eq 0 ]; then
    print_info "削除するリンクはありません"
    exit 0
fi

# 削除確認
print_warning "以下のリンクを削除します："
for link in "${LINKS_TO_REMOVE[@]}"; do
    echo "    - $(basename "$link")"
done

echo ""
read -p "続行しますか？ (y/N): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "キャンセルしました"
    exit 0
fi

# リンクの削除
REMOVED_COUNT=0
for link in "${LINKS_TO_REMOVE[@]}"; do
    rm "$link"
    print_success "削除: $(basename "$link")"
    ((REMOVED_COUNT++))
done

# 結果のサマリー
echo ""
print_success "クリーンアップが完了しました！"
print_info "$REMOVED_COUNT 個のリンクを削除しました"

# ディレクトリが空になった場合の通知
remaining_files=$(ls -A "$CLAUDE_COMMANDS_DIR" 2>/dev/null | wc -l)
if [ "$remaining_files" -eq 0 ]; then
    print_info "~/.claude/commands ディレクトリは空になりました"
    read -p "ディレクトリも削除しますか？ (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rmdir "$CLAUDE_COMMANDS_DIR"
        print_success "ディレクトリを削除しました: $CLAUDE_COMMANDS_DIR"
    fi
fi
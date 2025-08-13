#!/bin/bash

# Claude Commands Setup Script
# このスクリプトは commands/*.md ファイルを ~/.claude/commands にシンボリックリンクします

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

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_DIR="$SCRIPT_DIR/commands"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

print_info "Claude Commands セットアップを開始します..."

# commands ディレクトリの存在確認
if [ ! -d "$COMMANDS_DIR" ]; then
    print_error "commands ディレクトリが見つかりません: $COMMANDS_DIR"
    exit 1
fi

# ~/.claude/commands ディレクトリの作成
if [ ! -d "$CLAUDE_COMMANDS_DIR" ]; then
    print_info "~/.claude/commands ディレクトリを作成します..."
    mkdir -p "$CLAUDE_COMMANDS_DIR"
    print_success "ディレクトリを作成しました: $CLAUDE_COMMANDS_DIR"
else
    print_info "ディレクトリは既に存在します: $CLAUDE_COMMANDS_DIR"
fi

# 既存のシンボリックリンクをクリーンアップ（このリポジトリ由来のもののみ）
print_info "既存のリンクをチェックしています..."
for link in "$CLAUDE_COMMANDS_DIR"/*.md; do
    if [ -L "$link" ]; then
        # リンク先がこのリポジトリのファイルかチェック
        target=$(readlink "$link")
        if [[ "$target" == "$COMMANDS_DIR"/* ]]; then
            rm "$link"
            print_info "既存のリンクを削除: $(basename "$link")"
        fi
    fi
done

# commands/*.md ファイルのシンボリックリンク作成
LINKED_COUNT=0
print_info "コマンドファイルをリンクしています..."

# .md ファイルが存在するかチェック
shopt -s nullglob
MD_FILES=("$COMMANDS_DIR"/*.md)
shopt -u nullglob

if [ ${#MD_FILES[@]} -eq 0 ]; then
    print_info "commands ディレクトリに .md ファイルがありません"
    print_info "新しいコマンドを commands/ ディレクトリに追加後、再度このスクリプトを実行してください"
else
    for command_file in "${MD_FILES[@]}"; do
        filename=$(basename "$command_file")
        link_path="$CLAUDE_COMMANDS_DIR/$filename"
        
        # シンボリックリンク作成
        ln -sf "$command_file" "$link_path"
        print_success "リンクを作成: $filename"
        ((LINKED_COUNT++))
    done
fi

# 結果のサマリー
echo ""
print_success "セットアップが完了しました！"
if [ $LINKED_COUNT -gt 0 ]; then
    print_info "$LINKED_COUNT 個のコマンドがリンクされました"
    print_info "Claude Code で以下のコマンドが使用可能です："
    for command_file in "${MD_FILES[@]}"; do
        filename=$(basename "$command_file" .md)
        echo "    > /$filename"
    done
else
    print_info "コマンドファイルを commands/ ディレクトリに追加して、再度セットアップを実行してください"
fi

echo ""
print_info "新しいコマンドを追加したら、このスクリプトを再実行してください"
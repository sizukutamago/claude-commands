#!/bin/bash

# Claude Commands Update Script
# このスクリプトはリポジトリを最新版に更新し、リンクを再設定します

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
REPO_DIR="$(dirname "$SCRIPT_DIR")"

print_info "Claude Commands の更新をチェックしています..."

# リポジトリディレクトリに移動
cd "$REPO_DIR"

# Git リポジトリかチェック
if [ ! -d ".git" ]; then
    print_error "このディレクトリは Git リポジトリではありません"
    exit 1
fi

# 現在のブランチを取得
CURRENT_BRANCH=$(git branch --show-current)
print_info "現在のブランチ: $CURRENT_BRANCH"

# リモートの更新を取得
print_info "リモートの変更を確認しています..."
git fetch origin

# ローカルの変更をチェック
if ! git diff-index --quiet HEAD --; then
    print_warning "ローカルに未コミットの変更があります"
    print_warning "変更をコミットまたはスタッシュしてから再実行してください"
    exit 1
fi

# リモートとの差分をチェック
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/"$CURRENT_BRANCH")

if [ "$LOCAL" = "$REMOTE" ]; then
    print_success "既に最新版です"
else
    print_info "更新が利用可能です"
    
    # 更新前の確認
    echo ""
    print_info "以下の変更が適用されます："
    git log --oneline HEAD..origin/"$CURRENT_BRANCH"
    echo ""
    
    read -p "更新を適用しますか？ (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 更新を適用
        print_info "更新を適用しています..."
        git pull origin "$CURRENT_BRANCH"
        print_success "更新が完了しました"
        
        # setup-links.sh を実行
        print_info "リンクを再設定しています..."
        "$REPO_DIR/setup-links.sh"
    else
        print_info "更新をキャンセルしました"
        exit 0
    fi
fi

# 新しいコマンドの確認
print_info "コマンドの状態を確認しています..."
COMMAND_COUNT=$(find "$REPO_DIR/commands" -name "*.md" 2>/dev/null | wc -l)
if [ "$COMMAND_COUNT" -gt 0 ]; then
    print_success "$COMMAND_COUNT 個のコマンドが利用可能です"
else
    print_info "commands ディレクトリにコマンドファイルがありません"
fi

print_success "更新チェックが完了しました！"
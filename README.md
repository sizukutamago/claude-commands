# Claude Commands

Claude Code 用のコマンド集を管理・共有するためのリポジトリです。

## 概要

このリポジトリは、Claude Code のスラッシュコマンドとして使用できるカスタムコマンドを集約し、チーム間で共有するための仕組みを提供します。

## インストール

### 1. リポジトリのクローン

```bash
git clone https://github.com/yourusername/claude-commands.git
cd claude-commands
```

### 2. セットアップスクリプトの実行

```bash
./setup-links.sh
```

このスクリプトは以下を実行します：
- `~/.claude/commands` ディレクトリの作成
- `commands/*.md` ファイルへのシンボリックリンク作成
- 実行権限の設定

## 使い方

セットアップ完了後、Claude Code で以下のようにコマンドを使用できます：

```
> /コマンド名
```

## コマンドの追加

### 1. 新しいコマンドファイルの作成

`commands/` ディレクトリに新しい `.md` ファイルを作成します：

```bash
touch commands/my-command.md
```

### 2. コマンド内容の記述

マークダウン形式でステップバイステップの指示を記述します：

```markdown
# My Command

## ステップ 1: 初期化
- プロジェクトディレクトリを確認
- 必要な依存関係をチェック

## ステップ 2: 実行
- メインタスクを実行
- 結果を確認

## ステップ 3: 完了
- ログを出力
- クリーンアップ
```

### 3. リンクの更新

```bash
./setup-links.sh
```

## アップデート

最新のコマンドを取得するには：

```bash
./utils/update-check.sh
```

## アンインストール

シンボリックリンクを削除するには：

```bash
./cleanup-links.sh
```

## ディレクトリ構成

```
claude-commands/
├── README.md           # このファイル
├── CLAUDE.md          # Claude用メモリファイル
├── setup-links.sh     # セットアップスクリプト
├── cleanup-links.sh   # クリーンアップスクリプト
├── commands/          # コマンドファイル格納ディレクトリ
└── utils/             # ユーティリティスクリプト
    └── update-check.sh
```

## 貢献

新しいコマンドの追加や既存コマンドの改善のPRを歓迎します！

## ライセンス

MIT

## 参考

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Zenn Article - Claude Commands Share](https://zenn.dev/sdb_blog/articles/008-claude-commands-share)
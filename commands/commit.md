# Commit - 自動コミットメッセージ生成コマンド

このコマンドは、変更内容を分析して適切なコミットメッセージを自動生成し、Git コミットを実行します。

## ステップ 1: 変更内容の確認

まず、現在の Git の状態を確認します：
1. `git status` を実行して変更されたファイルを確認
2. ステージングされていない変更がある場合は表示
3. 新規ファイルがある場合は表示

変更がない場合は「コミットする変更がありません」と表示して終了します。

## ステップ 2: 変更内容の詳細分析

変更内容を詳しく分析します：
1. `git diff` を実行してステージングされていない変更を確認
2. `git diff --cached` を実行してステージング済みの変更を確認
3. 新規ファイルの内容を確認

## ステップ 3: 変更タイプの判定

変更内容から以下のタイプを判定します：

### Conventional Commits タイプ
- **feat**: 新機能の追加
- **fix**: バグ修正
- **docs**: ドキュメントのみの変更
- **style**: コードの意味に影響を与えない変更（空白、フォーマット、セミコロンなど）
- **refactor**: バグ修正や機能追加ではないコードの変更
- **perf**: パフォーマンス改善
- **test**: テストの追加や修正
- **build**: ビルドシステムや外部依存関係の変更
- **ci**: CI設定ファイルやスクリプトの変更
- **chore**: その他の変更（ビルドプロセスやツールの変更など）

### 判定基準
1. README.md, CONTRIBUTING.md, LICENSE などの変更 → **docs**
2. test/, spec/, __tests__/ ディレクトリの変更 → **test**
3. .github/, .gitlab-ci.yml, .travis.yml などの変更 → **ci**
4. package.json, Cargo.toml, go.mod などの依存関係の変更 → **build**
5. 新しいファイルや機能の追加 → **feat**
6. エラー修正や不具合の解消 → **fix**
7. コードの整理や改善 → **refactor**

## ステップ 4: ファイルのステージング

1. 変更されたファイルのリストを表示
2. すべての変更をステージングするか確認：
   - 「すべての変更をステージングしますか？」
   - はい: `git add -A` を実行
   - いいえ: 個別にファイルを選択してステージング

## ステップ 5: コミットメッセージの生成

以下の形式でコミットメッセージを生成します：

### 基本形式
```
<type>(<scope>): <subject>

<body>

<footer>
```

### 例
```
feat(commands): add commit command for automated git commits

- Analyze file changes to determine commit type
- Generate conventional commit messages
- Interactive staging and confirmation
- Support for multiple file changes

This command simplifies the commit process by automating message generation
based on actual code changes.
```

### メッセージ生成ルール
1. **type**: 上記で判定したタイプを使用
2. **scope**: 変更の影響範囲（オプション）
   - ディレクトリ名やモジュール名を使用
   - 複数の場合は最も重要なものを選択
3. **subject**: 50文字以内の要約
   - 現在形を使用（"add" not "added"）
   - 最初の文字は小文字
   - 末尾にピリオドを付けない
4. **body**: 詳細な説明（オプション）
   - 何を変更したか、なぜ変更したかを説明
   - 箇条書きで複数の変更点を記載
5. **footer**: 関連するIssue番号など（オプション）

## ステップ 6: コミットメッセージの確認と編集

1. 生成されたコミットメッセージを表示
2. ユーザーに確認を求める：
   - 「このメッセージでコミットしますか？」
   - はい: そのまま次のステップへ
   - 編集: メッセージを編集可能にする
   - キャンセル: 処理を中止

## ステップ 7: コミットの実行

1. 最終確認：
   - ステージングされたファイルのリストを表示
   - コミットメッセージを表示
2. `git commit -m "<message>"` を実行
3. 複数行のメッセージの場合は適切にフォーマット

## ステップ 8: 完了確認

1. コミットが成功したことを確認
2. `git log --oneline -1` で最新のコミットを表示
3. 「コミットが完了しました」と表示

## エラーハンドリング

### よくあるエラーと対処法

1. **Git リポジトリではない場合**
   - エラー: "fatal: not a git repository"
   - 対処: 「Git リポジトリではありません。git init を実行してください」

2. **変更がない場合**
   - 「コミットする変更がありません」と表示

3. **コンフリクトがある場合**
   - コンフリクトの解決を促すメッセージを表示

4. **ユーザー情報が設定されていない場合**
   - git config の設定を促す

## 高度な機能

### 複数のコミットタイプが混在する場合

1. 主要な変更タイプを判定
2. または、変更を分割してコミットすることを提案

### Co-authored-by の追加

ペアプログラミングや共同作業の場合：
```
Co-authored-by: Name <email@example.com>
```

### Breaking Changes の検出

後方互換性のない変更を検出した場合：
- コミットメッセージに `BREAKING CHANGE:` を追加
- type に `!` を付ける（例: `feat!:`)

## 使用例

### 新機能追加の場合
```
変更検出: commands/new-feature.md が追加されました
コミットタイプ: feat
生成メッセージ: feat(commands): add new-feature command for enhanced functionality
```

### バグ修正の場合
```
変更検出: src/utils.js のエラー処理を修正
コミットタイプ: fix
生成メッセージ: fix(utils): correct error handling in utility functions
```

### ドキュメント更新の場合
```
変更検出: README.md を更新
コミットタイプ: docs
生成メッセージ: docs: update README with new installation instructions
```

## 注意事項

1. コミットメッセージは英語で生成されます
2. Conventional Commits 規約に準拠します
3. 重要な変更は body に詳細を記載します
4. 自動生成されたメッセージは必ず確認してください

---

このコマンドにより、一貫性のある質の高いコミットメッセージを簡単に作成できます。
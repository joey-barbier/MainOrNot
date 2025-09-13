# Swift Concurrency Demo - iOS

🌐 **[English](README.md)** | **[Français](README_fr.md)** | **[Deutsch](README_de.md)** | **[Español](README_es.md)** | **[Português BR](README_pt-BR.md)**

Swift 6.2を使用したiOSでのSwift並行処理概念のインタラクティブデモンストレーションアプリ。

## 🎯 プロジェクト構成

プロジェクトはセクション別に整理されており、各例には以下を含む専用ビューがあります：
- ソースコード表示
- リアルタイム実行ログ
- 検証ポイント
- スレッドインジケーター（🟢 Main / 🔴 Background）

```
Concurrency/
├── ConcurrencyApp.swift           # エントリーポイント
├── MainMenuView.swift             # メインナビゲーションメニュー
├── Common/                        # 共有コンポーネント
│   ├── Models/
│   │   └── LogEntry.swift        # ログモデル
│   └── Views/
│       ├── CodeView.swift        # コード表示
│       └── LogsView.swift        # ログ表示
└── Examples/                      # セクション別に整理された例
    ├── Basics/
    ├── Tasks/
    └── Actors/
```

## 📱 利用可能なセクション

### 1. 基本
- **async let Parallel** : 並行構造化操作を表示
- **MainActor Isolation** : MainActorの継承を理解

### 2. タスク
- **Task Lifecycle** : タスクの作成、実行、完了
- **Task vs Detached** : 分離継承を理解
- **Cooperative Cancellation** : タスクキャンセレーションの管理
- **TaskGroup Parallel** : 複数タスクの並列実行

### 3. アクター
- **Actor Data Race** : データ競合からの保護
- **Concurrent MainActor** : MainActor分離での作業
- **Nonisolated Property** : アクター内での同期アクセス
- **Isolated Deinit** : 安全なクリーンアップ

## 🚀 必要条件

- Xcode 15.0+
- iOS 17.0+
- Swift 6.2

## 💡 使用方法

1. XcodeでプロジェクトをオープンF
2. シミュレーターまたはデバイスでアプリを実行
3. メインメニューから様々な例を探索
4. 「実行」をタップしてコードの動作を確認
5. スレッドインジケーター付きリアルタイムログを観察

## 🎓 主な学習ポイント

- **async/await** : 非同期プログラミングのモダン構文
- **Actors** : データ競合からの自動保護
- **nonisolated** : 同期アクセスのための分離からの脱出
- **構造化並行処理** : 子タスクの安全な管理
- **診断** : 問題の検出と解決のツール

## 🌐 サポート言語

このアプリは100%ローカライゼーションで6言語をサポート：
- 🇬🇧 英語
- 🇫🇷 フランス語
- 🇩🇪 ドイツ語
- 🇪🇸 スペイン語
- 🇯🇵 日本語
- 🇧🇷 ポルトガル語（ブラジル）
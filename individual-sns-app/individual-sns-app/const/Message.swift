//
//  Message.swift
//  individual-sns-app
//
import Foundation

/// 画面に表示する文言の定数
enum Message {

    // MARK: - ページタイトル
    enum Title {
        static let home       = "ホーム"
        static let favorite   = "お気に入り"
        static let post       = "投稿"
        static let profile    = "プロフィール"
        static let setting    = "設定"
        static let createPost = "投稿作成"
        static let editPost   = "投稿を編集"
    }

    // MARK: - ボタン
    enum Button {
        static let submit   = "投稿する"
        static let save     = "保存する"
        static let delete   = "削除する"
        static let cancel   = "キャンセル"
    }

    // MARK: - 空状態
    enum Empty {
        static let noPosts     = "投稿がありません"
        static let noFavorites = "お気に入りの投稿がありません"
    }

    // MARK: - 投稿
    enum Post {
        static let captionLabel    = "キャプション"
        static let noImage         = "No Image"
        static let userName        = "My Diary"
        static let deleteConfirm   = "この投稿を削除しますか？"
    }

    // MARK: - スプラッシュ
    enum Splash {
        static let appName = "Posly"
    }

    // MARK: - プロフィール
    enum Profile {
        static let editTitle       = "プロフィール編集"
        static let namePlaceholder = "名前を入力"
        static let nameLabel       = "名前"
        static let changePhoto     = "写真を変更"
        static let defaultName     = "My Diary"
    }

    // MARK: - 設定
    enum Setting {
        static let about           = "アプリについて"
        static let privacyPolicy   = "プライバシーポリシー"
        static let terms = "利用規約"
    }
}

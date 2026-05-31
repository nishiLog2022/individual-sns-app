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
        static let saved      = "保存済み"
        static let profile    = "プロフィール"
        static let other      = "その他"
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

    // MARK: - フォルダ
    enum Folder {
        static let defaultFolderName     = "すべての保存済み"
        static let newFolder             = "新しいフォルダ"
        static let addFolder             = "フォルダを作成"
        static let folderNamePlaceholder = "フォルダ名"
        static let saveToFolder          = "フォルダに保存"
        static let deleteFolderConfirm   = "このフォルダを削除しますか？\nフォルダ内の投稿は保存済みから外れます。"
        static let renameFolder          = "名前を変更"
        static let renameFolderTitle     = "フォルダ名を変更"
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
        static let changePhoto        = "写真を変更"
        static let removePhoto        = "写真を削除"
        static let removePhotoConfirm = "プロフィール写真を削除しますか？"
        static let defaultName        = "My Diary"
    }

    // MARK: - 設定
    enum Setting {
        static let about           = "アプリについて"
        static let privacyPolicy   = "プライバシーポリシー"
        static let terms = "利用規約"
    }

    // MARK: - 課金
    enum Billing {
        static let navigationTitle    = "プレミアムプラン"
        static let title              = "プレミアムにアップグレード"
        static let subtitle           = "制限を解除してアプリをもっと活用しよう"
        static let oneTimePurchase    = "買い切り（一度の購入で永久利用）"
        static let purchaseButton     = "プレミアムを購入する"
        static let restorePurchase    = "購入を復元する"
        static let alreadyPremium     = "購入済み"
        static let loadingProduct     = "商品情報を読み込み中..."
        // 機能比較
        static let featureFolder      = "フォルダ数"
        static let featureFolderFree  = "1個まで"
        static let featureFolderPremium = "無制限"
        static let featurePhoto       = "写真枚数"
        static let featurePhotoFree   = "\(Const.freeMaxPhotoCount)枚まで"
        static let featurePhotoPremium = "\(Const.premiumMaxPhotoCount)枚まで"
        // アラート
        static let purchaseSuccess    = "購入が完了しました！プレミアム機能をお楽しみください。"
        static let purchasePending    = "購入の承認を待っています。承認後に機能が解除されます。"
        static let purchaseFailed     = "購入に失敗しました。しばらく経ってからお試しください。"
        static let restoreSuccess     = "購入の復元が完了しました。"
        static let restoreNotFound    = "復元できる購入が見つかりませんでした。"
        // 制限エラー
        static let folderLimitReached = "フォルダは\(Const.freeFolderLimit - 1)個まで作成できます。\nプレミアムにアップグレードすると無制限に作成できます。"
        static let upgradeButton      = "プレミアムを見る"
    }
}

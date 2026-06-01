//
//  Const.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//
import Foundation

class Const {
    // ホーム画面で取得するデータ数
    static let getDataLimitForList: Int = 10
    // プロフィール画面で取得するデータ数
    static let getDataLimitForProfile: Int = 10
    // 投稿キャプションの最大文字数
    static let maxCaptionLength: Int = 1500
    // 利用規約のURL
    static let termsUrl: String = "https://toridoriblog.com/running-support-app-terms-of-service/"
    // プライバシーポリシーのURL
    static let privacyPolicyUrl: String = "https://toridoriblog.com/running-support-app-privacy-policy/"
    // 課金: プレミアムプランの商品ID（App Store Connectで設定するProduct ID）
    static let premiumProductId: String = "individual_sns_app_premium"
    // 課金: 無料プランのフォルダ数上限（デフォルトコレクションフォルダ + 1つまで追加可能）
    static let freeFolderLimit: Int = 2
    // 課金: 無料プランの写真枚数上限
    static let freeMaxPhotoCount: Int = 3
    // 課金: プレミアムプランの写真枚数上限
    static let premiumMaxPhotoCount: Int = 10
    // 課金: UserDefaultsのキー
    static let isPremiumKey: String = "isPremium"
}
extension DateFormatter {
    /// yyyy/MM/dd 形式のフォーマッター
    static let postDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter
    }()
}


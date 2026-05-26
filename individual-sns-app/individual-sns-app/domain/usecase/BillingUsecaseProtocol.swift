//
//  BillingUsecaseProtocol.swift
//  individual-sns-app
//
import StoreKit

/// 課金ユースケースのプロトコル
protocol BillingUsecaseProtocol {
    /// 現在の購入状態（UserDefaultsキャッシュから同期的に参照）
    var isPremium: Bool { get }
    /// 商品情報を取得する
    func fetchProduct() async -> Product?
    /// 購入を実行し、成功時にUserDefaultsを更新する
    func purchase(product: Product) async -> BillingResult
    /// StoreKitトランザクションで検証してUserDefaultsを同期する
    func syncPremiumStatus() async
    /// 購入を復元する
    func restorePurchases() async -> Bool
    /// フォルダを追加可能かチェックする
    func canCreateFolder(currentCount: Int) -> Bool
    /// 選択可能な写真の最大枚数
    var maxPhotoCount: Int { get }
}

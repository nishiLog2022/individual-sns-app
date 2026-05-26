//
//  BillingServiceProtocol.swift
//  individual-sns-app
//
import StoreKit

/// StoreKitを使った課金処理のプロトコル
protocol BillingServiceProtocol {
    /// 商品情報を取得する
    func fetchProduct(productId: String) async -> Product?
    /// 購入を実行する
    func purchase(product: Product) async -> BillingResult
    /// StoreKitのトランザクションから購入済みかどうかを検証する
    func verifyPurchase(productId: String) async -> Bool
    /// 購入を復元する
    func restorePurchases() async -> Bool
}

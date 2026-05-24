//
//  BillingService.swift
//  individual-sns-app
//
import StoreKit

/// StoreKit2を使った課金サービスの実装
class BillingService: BillingServiceProtocol {
    static let shared = BillingService()
    private init() {}

    func fetchProduct(productId: String) async -> Product? {
        do {
            let products = try await Product.products(for: [productId])
            return products.first
        } catch {
            print("⚠️ 商品情報の取得に失敗しました: \(error)")
            return nil
        }
    }

    func purchase(product: Product) async -> BillingResult {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    return .success
                case .unverified:
                    return .failed(BillingServiceError.verificationFailed)
                }
            case .userCancelled:
                return .userCancelled
            case .pending:
                return .pending
            @unknown default:
                return .failed(BillingServiceError.unknown)
            }
        } catch {
            print("⚠️ 購入処理に失敗しました: \(error)")
            return .failed(error)
        }
    }

    func verifyPurchase(productId: String) async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == productId,
               transaction.revocationDate == nil {
                return true
            }
        }
        return false
    }

    func restorePurchases() async -> Bool {
        do {
            try await AppStore.sync()
            return await verifyPurchase(productId: Const.premiumProductId)
        } catch {
            print("⚠️ 購入の復元に失敗しました: \(error)")
            return false
        }
    }
}


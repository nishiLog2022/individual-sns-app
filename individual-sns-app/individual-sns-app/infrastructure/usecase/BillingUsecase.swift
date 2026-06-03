//
//  BillingUsecase.swift
//  individual-sns-app
//
import StoreKit

/// 課金ユースケースの実装
class BillingUsecase: BillingUsecaseProtocol {
    private let billingService: BillingServiceProtocol

    init(billingService: BillingServiceProtocol) {
        self.billingService = billingService
    }

    var isPremium: Bool {
        return UserDefaults.standard.bool(forKey: Const.isPremiumKey)
    }

    func fetchProduct() async -> Product? {
        return await billingService.fetchProduct(productId: Const.premiumProductId)
    }

    func purchase(product: Product) async -> BillingResult {
        let result = await billingService.purchase(product: product)
        if case .success = result {
            UserDefaults.standard.set(true, forKey: Const.isPremiumKey)
        }
        return result
    }

    func syncPremiumStatus() async {
        let verified = await billingService.verifyPurchase(productId: Const.premiumProductId)
        // StoreKitが購入を確認できた場合のみ true に更新する。
        // 未確認（ネットワーク不可・テスト環境リセット等）の場合は既存値を保持し、
        // 誤って premium 状態が解除されるのを防ぐ。
        if verified {
            UserDefaults.standard.set(true, forKey: Const.isPremiumKey)
        }
    }

    func restorePurchases() async -> Bool {
        let restored = await billingService.restorePurchases()
        UserDefaults.standard.set(restored, forKey: Const.isPremiumKey)
        return restored
    }

    // MARK: - 機能制限ロジック

    func canCreateFolder(currentCount: Int) -> Bool {
        if isPremium { return true }
        return currentCount < Const.freeFolderLimit
    }

    var maxPhotoCount: Int {
        return isPremium ? Const.premiumMaxPhotoCount : Const.freeMaxPhotoCount
    }
}

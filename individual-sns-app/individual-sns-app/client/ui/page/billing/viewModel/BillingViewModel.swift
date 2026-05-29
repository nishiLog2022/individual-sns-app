//
//  BillingViewModel.swift
//  individual-sns-app
//
import Foundation
import StoreKit

@MainActor
class BillingViewModel: ObservableObject {
    private let billingUsecase: BillingUsecaseProtocol =
        DiContainer.shared.container.resolve(BillingUsecaseProtocol.self)!

    @Published var product: Product? = nil
    @Published var isPremium: Bool = false
    @Published var isLoading: Bool = false
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var didPurchaseSucceed: Bool = false

    init() {
        isPremium = billingUsecase.isPremium
    }

    func onAppear() {
        Task {
            isLoading = true
            // StoreKitから最新の購入状態を同期
            await billingUsecase.syncPremiumStatus()
            isPremium = billingUsecase.isPremium
            // 商品情報を取得
            product = await billingUsecase.fetchProduct()
            isLoading = false
        }
    }

    func purchase() {
        guard let product = product else { return }
        Task {
            isLoading = true
            let result = await billingUsecase.purchase(product: product)
            isLoading = false
            switch result {
            case .success:
                isPremium = true
                didPurchaseSucceed = true
                alertMessage = Message.Billing.purchaseSuccess
                showAlert = true
            case .userCancelled:
                break
            case .pending:
                alertMessage = Message.Billing.purchasePending
                showAlert = true
            case .failed:
                alertMessage = Message.Billing.purchaseFailed
                showAlert = true
            }
        }
    }

    func restorePurchases() {
        Task {
            isLoading = true
            let restored = await billingUsecase.restorePurchases()
            isLoading = false
            isPremium = restored
            alertMessage = restored ? Message.Billing.restoreSuccess : Message.Billing.restoreNotFound
            showAlert = true
        }
    }
}

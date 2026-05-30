//
//  SavedViewModel.swift
//  individual-sns-app
//
import SwiftUI

class SavedViewModel: ObservableObject {
    private let billingUsecase: BillingUsecaseProtocol =
        DiContainer.shared.container.resolve(BillingUsecaseProtocol.self)!

    @Published var state = SavedState()

    /// フォルダを追加可能かチェックする
    func canAddFolder(currentFolderCount: Int) -> Bool {
        return billingUsecase.canCreateFolder(currentCount: currentFolderCount)
    }
}

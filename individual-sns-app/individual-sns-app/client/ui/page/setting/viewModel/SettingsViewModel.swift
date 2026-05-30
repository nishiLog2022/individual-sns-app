//
//  SettingsViewModel.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/04/01.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    private let billingUsecase: BillingUsecaseProtocol =
        DiContainer.shared.container.resolve(BillingUsecaseProtocol.self)!

    @Published var state = SettingsState()

    var isPremium: Bool {
        billingUsecase.isPremium
    }

    var dispCurrentVersion: String {
        return "Version: \(getCurrentVersion())"
    }
    
    func getCurrentVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0"
    }

    /// BillingViewを閉じた後にisPremiumの変更をUIに反映する
    func refreshPremiumStatus() {
        objectWillChange.send()
    }
}

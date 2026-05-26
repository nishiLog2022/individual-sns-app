//
//  individual_sns_appApp.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//

import SwiftUI
import SwiftData

@main
struct individual_sns_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    // ModelContainer は DiContainer で一元管理する
    private let modelContainer: ModelContainer = DiContainer.shared.container.resolve(ModelContainer.self)!

    var body: some Scene {
        WindowGroup {
            AppBaseView()
                .task {
                    // アプリ起動時にStoreKitのトランザクションを検証してUserDefaultsと同期する
                    await DiContainer.shared.container
                        .resolve(BillingUsecaseProtocol.self)!
                        .syncPremiumStatus()
                }
        }
        .modelContainer(modelContainer)
    }
}

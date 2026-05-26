//
//  DiContainer.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//
import Swinject
import SwiftData
import Foundation
@MainActor
class DiContainer {
    static let shared = DiContainer()
    let container: Container

    private init () {
        container = Container()
        registerModel()
        registerRepository()
        registerUsecase()
        registerService()
    }
    
    // Modelの登録
    func registerModel() {
        container.register(DatabaseServiceProtocol.self) { _ in
            DatabaseService()
        }
        
        container.register(ModelContainer.self){ _ in
            let schema = Schema([
                TrnPost.self,
                MstSaveFolder.self,
            ])
            
            let modelConfiguration = ModelConfiguration(
                "individual-sns-app",
                schema: schema,
                isStoredInMemoryOnly: false
            )
            
            let url = URL.documentsDirectory.appending(path: "individualSnsApp.store")

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                print("⚠️ DBマイグレーションに失敗しました: \(error)")

                // ① 古いDBをバックアップ
                let backupURL = url.deletingLastPathComponent().appending(path: "individualSnsApp_backup_\(Date.now.timeIntervalSince1970).store")
                try? FileManager.default.moveItem(at: url, to: backupURL)
                print("📦 バックアップを作成: \(backupURL.path)")

                // ② 新しい空DBを再作成（永続的に保持）
                let freshConfig = ModelConfiguration(schema: schema, url: url)
                let newContainer = try! ModelContainer(for: schema, configurations: [freshConfig])

                // ③ 必要に応じてバックアップから再構築（CSV/JSON復元など）
                return newContainer
            }
        }
        .inObjectScope(.container)

        // 2. ModelContextの登録
        container.register(ModelContext.self) { r in
            let modelContainer = r.resolve(ModelContainer.self)!
            return modelContainer.mainContext
        }
        .inObjectScope(.container)
        
    }
    
    // Repositoryの登録
    func registerRepository() {
        container.register(TrnPostRepository.self) { r in
            let context = r.resolve(ModelContext.self)!
            return TrnPostRepository(context: context)
        }
        container.register(MstSaveFolderRepositoryProtocol.self) { r in
            let context = r.resolve(ModelContext.self)!
            return MstSaveFolderRepository(context: context)
        }
    }

    // Usecaseの登録
    func registerUsecase() {
        let trnPostRepository = container.resolve(TrnPostRepository.self)!
        container.register(PostUsecaseProtocol.self) { _ in
            PostUsecase(trnPostRepository: trnPostRepository)
        }
        let mstSaveFolderRepository = container.resolve(MstSaveFolderRepositoryProtocol.self)!
        container.register(SaveFolderUsecaseProtocol.self) { _ in
            SaveFolderUsecase(
                mstSaveFolderRepository: mstSaveFolderRepository,
                trnPostRepository: trnPostRepository
            )
        }
        // 課金Usecaseの登録（全ViewModel間でisPremium状態を共有するためシングルトンスコープ）
        container.register(BillingUsecaseProtocol.self) { r in
            let billingService = r.resolve(BillingServiceProtocol.self)!
            return BillingUsecase(billingService: billingService)
        }
        .inObjectScope(.container)
    }
    
    // Serviceの登録
    func registerService() {
        container.register(ImageStorageProtocol.self) { _ in
            ImageStorage.shared
        }
        .inObjectScope(.container)
        // 課金Serviceの登録
        container.register(BillingServiceProtocol.self) { _ in
            BillingService.shared
        }
        .inObjectScope(.container)
    }
}

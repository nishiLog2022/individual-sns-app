//
//  DatabaseService.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//
import Foundation

class DatabaseService: DatabaseServiceProtocol {
    let databaseURL: URL

    init() {
        // SwiftDataやCoreDataの場合の例
        let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.databaseURL = containerURL.appendingPathComponent("individual-sns-app")
    }
    
    func copyUrl() {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        guard let url = urls.first else {
            return
        }
        let sqliteURL = url.appendingPathComponent("individual-sns-app.store")
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("individual-sns-app.sqlite")
        
        do {
            // 既に同名ファイルがあれば削除
            if FileManager.default.fileExists(atPath: documentsURL.path) {
                try FileManager.default.removeItem(at: documentsURL)
            }

            // コピーして拡張子を .sqlite に変更
            try FileManager.default.copyItem(at: url, to: documentsURL)
            print("SQLiteファイルパス: \(documentsURL.path)")
        } catch let error {
            print("コピー失敗: \(error)")
        }
    }
}


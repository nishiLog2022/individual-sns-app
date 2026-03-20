//
//  ImageStorage.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/20.
//

import UIKit

class ImageStorage {
    
    static let shared = ImageStorage()
    
    private init() {}
    
    // ディレクトリURL
    private func getDirectory() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = url.appendingPathComponent("images")
        
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        
        return folder
    }
    
    // 保存
    func saveImage(_ image: UIImage) -> String? {
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = getDirectory().appendingPathComponent(fileName)
        
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        
        do {
            try data.write(to: fileURL)
            return fileName // ← 相対パス
        } catch {
            print("保存エラー:", error)
            return nil
        }
    }
    
    // 読み込み
    func loadImage(fileName: String) -> UIImage? {
        let fileURL = getDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    // 削除
    func deleteImage(fileName: String) {
        let fileURL = getDirectory().appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }
}

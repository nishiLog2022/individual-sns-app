//
//  MstSaveFolderRepositoryProtocol.swift
//  individual-sns-app
//
import Foundation

protocol MstSaveFolderRepositoryProtocol {
    func getFolders() -> [MstSaveFolder]
    func addFolder(_ folder: MstSaveFolder)
    func updateFolder(_ folder: MstSaveFolder)
    func deleteFolder(_ folder: MstSaveFolder)
    func ensureDefaultFolderExists() -> MstSaveFolder
}

//
//  MstSaveFolderRepository.swift
//  individual-sns-app
//
import SwiftData
import Foundation

class MstSaveFolderRepository: MstSaveFolderRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getFolders() -> [MstSaveFolder] {
        let descriptor = FetchDescriptor<MstSaveFolder>(
            sortBy: [SortDescriptor(\.sortOrder), SortDescriptor(\.createdAt)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func addFolder(_ folder: MstSaveFolder) {
        context.insert(folder)
        try? context.save()
    }

    func deleteFolder(_ folder: MstSaveFolder) {
        context.delete(folder)
        try? context.save()
    }

    func ensureDefaultFolderExists() -> MstSaveFolder {
        let folders = getFolders()
        if let existing = folders.first(where: { $0.isDefault }) {
            return existing
        }
        let defaultFolder = MstSaveFolder(
            name: Message.Folder.defaultFolderName,
            isDefault: true,
            sortOrder: 0
        )
        addFolder(defaultFolder)
        return defaultFolder
    }
}

//
//  SaveFolderDto.swift
//  individual-sns-app
//
import Foundation

struct SaveFolderDto: Identifiable, Hashable {
    var id: UUID
    var mstSaveFolderId: UUID
    var name: String
    var isDefault: Bool
    var createdAt: Date
    var sortOrder: Int

    init(
        mstSaveFolderId: UUID = UUID(),
        name: String,
        isDefault: Bool = false,
        createdAt: Date = Date(),
        sortOrder: Int = 999
    ) {
        self.id = UUID()
        self.mstSaveFolderId = mstSaveFolderId
        self.name = name
        self.isDefault = isDefault
        self.createdAt = createdAt
        self.sortOrder = sortOrder
    }

    func createMstSaveFolder() -> MstSaveFolder {
        MstSaveFolder(
            mstSaveFolderId: mstSaveFolderId,
            name: name,
            isDefault: isDefault,
            createdAt: createdAt,
            sortOrder: sortOrder
        )
    }
}

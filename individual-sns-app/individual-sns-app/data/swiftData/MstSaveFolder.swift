//
//  MstSaveFolder.swift
//  individual-sns-app
//
import SwiftData
import Foundation

@Model
class MstSaveFolder {
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
        self.mstSaveFolderId = mstSaveFolderId
        self.name = name
        self.isDefault = isDefault
        self.createdAt = createdAt
        self.sortOrder = sortOrder
    }

    func createDto() -> SaveFolderDto {
        SaveFolderDto(
            mstSaveFolderId: mstSaveFolderId,
            name: name,
            isDefault: isDefault,
            createdAt: createdAt,
            sortOrder: sortOrder
        )
    }
}

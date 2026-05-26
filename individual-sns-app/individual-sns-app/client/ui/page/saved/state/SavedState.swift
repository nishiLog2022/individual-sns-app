//
//  SavedState.swift
//  individual-sns-app
//
import Foundation

struct SavedState {
    var showAddFolder: Bool = false
    var newFolderName: String = ""
    var isEditMode: Bool = false
    var showBilling: Bool = false
    var folderToDelete: SaveFolderDto? = nil
}

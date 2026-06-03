//
//  EditProfileState.swift
//  individual-sns-app
//
import Foundation
import SwiftUI
import PhotosUI

struct EditProfileState {
    var name: String
    var selectedItem: PhotosPickerItem? = nil
    var previewImage: UIImage?
    var shouldRemoveImage: Bool = false
    var showRemoveConfirm: Bool = false
    var showDiscardConfirm: Bool = false

    init(baseViewModel: AppBaseViewModel) {
        self.name = baseViewModel.profileName
        self.previewImage = baseViewModel.profileImage
    }
}

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
    /// 画像を未設定に戻すかどうか
    var shouldRemoveImage: Bool = false

    init(baseViewModel: AppBaseViewModel) {
        self.name = baseViewModel.profileName
        self.previewImage = baseViewModel.profileImage
    }
}

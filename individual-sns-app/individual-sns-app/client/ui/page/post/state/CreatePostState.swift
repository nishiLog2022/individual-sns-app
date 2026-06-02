//
//  CreatePostState.swift
//  individual-sns-app
//
import Foundation
import SwiftUI
import PhotosUI

struct SelectedImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

struct CreatePostState {
    var caption: String = ""
    var selectedItems: [PhotosPickerItem] = []
    var selectedImages: [SelectedImage] = []
    var showPhotoPicker: Bool = false
    var isLoadingImages: Bool = false
}

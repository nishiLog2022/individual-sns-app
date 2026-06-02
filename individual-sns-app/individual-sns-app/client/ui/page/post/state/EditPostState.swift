//
//  EditPostState.swift
//  individual-sns-app
//
import Foundation
import SwiftUI
import PhotosUI

struct EditPostState {
    var caption: String
    var selectedItems: [PhotosPickerItem] = []
    var selectedImages: [UIImage] = []
    var existingImagePaths: [String]
    var showDeleteConfirm: Bool = false
    var showPhotoPicker: Bool = false
    var isLoadingImages: Bool = false

    init(post: PostDto) {
        self.caption = post.caption
        self.existingImagePaths = post.imagePaths
    }
}

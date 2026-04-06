//
//  CreatePostState.swift
//  individual-sns-app
//
import Foundation
import SwiftUI
import PhotosUI

struct CreatePostState {
    var caption: String = ""
    var selectedItems: [PhotosPickerItem] = []
    var selectedImages: [UIImage] = []
    var showPhotoPicker: Bool = false
}

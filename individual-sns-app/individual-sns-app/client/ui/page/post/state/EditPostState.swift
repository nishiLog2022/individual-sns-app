//
//  EditPostState.swift
//  individual-sns-app
//
import Foundation
import SwiftUI

struct EditPostState {
    var caption: String
    var existingImagePaths: [String]
    var imagesToDelete: [String] = []
    var showDeleteConfirm: Bool = false
    var showImageDeleteConfirm: Bool = false
    var imagePathToDelete: String? = nil
    var showDiscardConfirm: Bool = false

    init(post: PostDto) {
        self.caption = post.caption
        self.existingImagePaths = post.imagePaths
    }
}

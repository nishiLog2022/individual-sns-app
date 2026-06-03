//
//  EditPostViewModel.swift
//  individual-sns-app
//
import Foundation
import SwiftUI

class EditPostViewModel: ObservableObject {
    @Published var state: EditPostState
    private let originalPost: PostDto

    init(post: PostDto) {
        self.originalPost = post
        self.state = EditPostState(post: post)
    }

    var visibleImagePaths: [String] {
        state.existingImagePaths.filter { !state.imagesToDelete.contains($0) }
    }

    var canSave: Bool {
        !state.caption.isEmpty || !visibleImagePaths.isEmpty
    }

    var hasUnsavedChanges: Bool {
        state.caption != originalPost.caption || !state.imagesToDelete.isEmpty
    }

    func markImageForDeletion(path: String) {
        state.imagePathToDelete = path
        state.showImageDeleteConfirm = true
    }

    func confirmDeleteImage() {
        guard let path = state.imagePathToDelete else { return }
        state.imagesToDelete.append(path)
        state.imagePathToDelete = nil
        state.showImageDeleteConfirm = false
    }

    func saveEdit(post: PostDto, baseViewModel: AppBaseViewModel, onComplete: () -> Void) {
        for path in state.imagesToDelete {
            ImageStorage.shared.deleteImage(fileName: path)
        }
        var updated = post
        updated.caption = state.caption
        updated.imagePaths = state.existingImagePaths.filter { !state.imagesToDelete.contains($0) }
        baseViewModel.updatePost(dto: updated)
        onComplete()
    }
}

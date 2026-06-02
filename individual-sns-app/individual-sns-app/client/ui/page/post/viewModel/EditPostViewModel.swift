//
//  EditPostViewModel.swift
//  individual-sns-app
//
import Foundation
import SwiftUI
import PhotosUI

class EditPostViewModel: ObservableObject {
    private let billingUsecase: BillingUsecaseProtocol =
        DiContainer.shared.container.resolve(BillingUsecaseProtocol.self)!

    @Published var state: EditPostState
    var loadTask: Task<Void, Never>? = nil

    var maxPhotoCount: Int {
        billingUsecase.maxPhotoCount
    }

    init(post: PostDto) {
        self.state = EditPostState(post: post)
    }

    func openPickerIfAllowed() {
        let remaining = maxPhotoCount - state.existingImagePaths.count
        guard remaining > 0 || !state.selectedImages.isEmpty else { return }
        state.showPhotoPicker = true
    }

    func loadNewImages(from items: [PhotosPickerItem]) {
        loadTask?.cancel()
        state.isLoadingImages = true
        loadTask = Task {
            var loaded: [UIImage?] = Array(repeating: nil, count: items.count)
            await withTaskGroup(of: (Int, UIImage?).self) { group in
                for (index, item) in items.enumerated() {
                    group.addTask {
                        guard let data = try? await item.loadTransferable(type: Data.self),
                              let uiImage = UIImage(data: data) else { return (index, nil) }
                        return (index, uiImage)
                    }
                }
                for await (index, image) in group {
                    loaded[index] = image
                }
            }
            guard !Task.isCancelled else { return }
            let result = loaded.compactMap { $0 }
            await MainActor.run { [weak self] in
                self?.state.selectedImages = result
                self?.state.isLoadingImages = false
            }
        }
    }

    func saveEdit(post: PostDto, baseViewModel: AppBaseViewModel, onComplete: () -> Void) {
        let newPaths = state.selectedImages.compactMap {
            ImageStorage.shared.saveImage($0)
        }
        var updated = post
        updated.caption = state.caption
        updated.imagePaths = state.existingImagePaths + newPaths
        baseViewModel.updatePost(dto: updated)
        onComplete()
    }
}

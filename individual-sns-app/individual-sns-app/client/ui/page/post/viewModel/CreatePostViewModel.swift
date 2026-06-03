//
//  CreatePostViewModel.swift
//  individual-sns-app
//
import Foundation
import SwiftUI
import Photos
import PhotosUI
import SwiftData

class CreatePostViewModel: ObservableObject {
    private let billingUsecase: BillingUsecaseProtocol =
        DiContainer.shared.container.resolve(BillingUsecaseProtocol.self)!

    @Published var state = CreatePostState()
    var loadTask: Task<Void, Never>? = nil

    var maxPhotoCount: Int {
        billingUsecase.maxPhotoCount
    }

    func checkPossiblePost() -> Bool {
        !state.caption.isEmpty || !state.selectedImages.isEmpty
    }

    func requestPhotoLibraryPermissionAndShowPicker() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    DispatchQueue.main.async {
                        self?.state.showPhotoPicker = true
                    }
                }
            }
        case .authorized, .limited:
            state.showPhotoPicker = true
        default:
            break
        }
    }

    func loadImages(from items: [PhotosPickerItem]) {
        loadTask?.cancel()
        state.isLoadingImages = true
        loadTask = Task {
            var loaded: [SelectedImage?] = Array(repeating: nil, count: items.count)
            await withTaskGroup(of: (Int, SelectedImage?).self) { group in
                for (index, item) in items.enumerated() {
                    group.addTask {
                        guard let data = try? await item.loadTransferable(type: Data.self),
                              let uiImage = UIImage(data: data) else { return (index, nil) }
                        return (index, SelectedImage(image: uiImage))
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

    func createPost(baseViewModel: AppBaseViewModel, context: ModelContext, onComplete: () -> Void) {
        let images = state.selectedImages.map { $0.image }
        baseViewModel.addPost(caption: state.caption, images: images, context: context)
        onComplete()
    }
}

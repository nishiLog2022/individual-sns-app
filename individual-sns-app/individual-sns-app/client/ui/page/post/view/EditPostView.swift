//
//  EditPostView.swift
//  individual-sns-app
//
import SwiftUI
import PhotosUI

struct EditPostView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    let post: PostDto

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditPostViewModel
    @FocusState private var isCaptionFocused: Bool

    init(baseViewModel: AppBaseViewModel, post: PostDto) {
        self.baseViewModel = baseViewModel
        self.post = post
        _viewModel = StateObject(wrappedValue: EditPostViewModel(post: post))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        // 画像エリア
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                // 既存の画像
                                ForEach(viewModel.state.existingImagePaths, id: \.self) { path in
                                    if let uiImage = ImageStorage.shared.loadImage(fileName: path) {
                                        ZStack(alignment: .topTrailing) {
                                            Button {
                                                openPickerIfAllowed()
                                            } label: {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 100)
                                                    .clipped()
                                                    .cornerRadius(8)
                                            }
                                            .buttonStyle(.plain)

                                            // 削除ボタン
                                            Button {
                                                viewModel.state.existingImagePaths.removeAll { $0 == path }
                                            } label: {
                                                Image(systemName: SystemImage.Post.close)
                                                    .foregroundColor(.white)
                                                    .background(Color.black.opacity(0.5))
                                                    .clipShape(Circle())
                                            }
                                            .padding(4)
                                        }
                                    }
                                }
                                // 新たに選んだ画像
                                ForEach(viewModel.state.selectedImages, id: \.self) { image in
                                    Button {
                                        openPickerIfAllowed()
                                    } label: {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .cornerRadius(8)
                                    }
                                    .buttonStyle(.plain)
                                }
                                // 既存＋新規の合計が上限未満のときのみ追加ボタンを表示
                                let totalImageCount = viewModel.state.existingImagePaths.count + viewModel.state.selectedImages.count
                                if totalImageCount < viewModel.maxPhotoCount {
                                    Button {
                                        openPickerIfAllowed()
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.2))
                                                .frame(width: 100, height: 100)
                                            Image(systemName: SystemImage.Post.addImage)
                                                .font(.title)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // キャプション
                        VStack(alignment: .leading, spacing: 6) {
                            Text(Message.Post.captionLabel)
                                .font(.headline)
                                .padding(.horizontal)
                            TextEditor(text: $viewModel.state.caption)
                                .frame(height: 150)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .focused($isCaptionFocused)
                                .onChange(of: viewModel.state.caption) { newValue in
                                    if newValue.count > Const.maxCaptionLength {
                                        viewModel.state.caption = String(newValue.prefix(Const.maxCaptionLength))
                                    }
                                }

                            // 文字数カウンター
                            HStack {
                                Spacer()
                                Text("\(viewModel.state.caption.count) / \(Const.maxCaptionLength)")
                                    .font(.caption)
                                    .foregroundColor(viewModel.state.caption.count >= Const.maxCaptionLength ? .red : .secondary)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }

                // 保存ボタン
                Button(action: saveEdit) {
                    Text(Message.Button.save)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.state.caption.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(viewModel.state.caption.isEmpty)
                .padding()
            }
            .navigationTitle(Message.Title.editPost)
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                isCaptionFocused = false
            }
            .toolbar {
                // ゴミ箱アイコンで投稿削除
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.state.showDeleteConfirm = true
                    } label: {
                        Image(systemName: SystemImage.Post.delete)
                            .foregroundColor(.red)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Message.Button.cancel) {
                        dismiss()
                    }
                }
            }
            .confirmationDialog(Message.Post.deleteConfirm, isPresented: $viewModel.state.showDeleteConfirm, titleVisibility: .visible) {
                Button(Message.Button.delete, role: .destructive) {
                    baseViewModel.deletePost(dto: post)
                    dismiss()
                }
                Button(Message.Button.cancel, role: .cancel) {}
            }
            .onChange(of: viewModel.state.selectedItems) { newItems in
                loadNewImages(from: newItems)
            }
            .photosPicker(
                isPresented: $viewModel.state.showPhotoPicker,
                selection: $viewModel.state.selectedItems,
                maxSelectionCount: max(1, viewModel.maxPhotoCount - viewModel.state.existingImagePaths.count),
                matching: .images
            )
        }
    }

    private func openPickerIfAllowed() {
        let remaining = viewModel.maxPhotoCount - viewModel.state.existingImagePaths.count
        guard remaining > 0 || !viewModel.state.selectedImages.isEmpty else { return }
        viewModel.state.showPhotoPicker = true
    }

    private func saveEdit() {
        let newPaths = viewModel.state.selectedImages.compactMap {
            ImageStorage.shared.saveImage($0)
        }
        var updated = post
        updated.caption = viewModel.state.caption
        updated.imagePaths = viewModel.state.existingImagePaths + newPaths
        baseViewModel.updatePost(dto: updated)
        dismiss()
    }

    private func loadNewImages(from items: [PhotosPickerItem]) {
        viewModel.state.selectedImages = []
        for item in items {
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        viewModel.state.selectedImages.append(uiImage)
                    }
                }
            }
        }
    }
}

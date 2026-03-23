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
    @State private var caption: String
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var existingImagePaths: [String]
    @State private var showDeleteConfirm = false

    init(baseViewModel: AppBaseViewModel, post: PostDto) {
        self.baseViewModel = baseViewModel
        self.post = post
        _caption = State(initialValue: post.caption)
        _existingImagePaths = State(initialValue: post.imagePaths)
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
                                ForEach(existingImagePaths, id: \.self) { path in
                                    if let uiImage = ImageStorage.shared.loadImage(fileName: path) {
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipped()
                                                .cornerRadius(8)

                                            // 削除ボタン
                                            Button {
                                                existingImagePaths.removeAll { $0 == path }
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
                                ForEach(selectedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                                // 追加ボタン
                                PhotosPicker(
                                    selection: $selectedItems,
                                    maxSelectionCount: 5,
                                    matching: .images
                                ) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 100, height: 100)
                                        Image(systemName: SystemImage.Post.addImage)
                                            .font(.title)
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
                            TextEditor(text: $caption)
                                .frame(height: 150)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
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
                        .background(caption.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(caption.isEmpty)
                .padding()
            }
            .navigationTitle(Message.Title.editPost)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ゴミ箱アイコンで投稿削除
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showDeleteConfirm = true
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
            .confirmationDialog(Message.Post.deleteConfirm, isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                Button(Message.Button.delete, role: .destructive) {
                    baseViewModel.deletePost(dto: post)
                    dismiss()
                }
                Button(Message.Button.cancel, role: .cancel) {}
            }
            .onChange(of: selectedItems) { newItems in
                loadNewImages(from: newItems)
            }
        }
    }

    private func saveEdit() {
        // 新しく追加された画像を保存
        let newPaths = selectedImages.compactMap {
            ImageStorage.shared.saveImage($0)
        }
        var updated = post
        updated.caption = caption
        updated.imagePaths = existingImagePaths + newPaths
        baseViewModel.updatePost(dto: updated)
        dismiss()
    }

    private func loadNewImages(from items: [PhotosPickerItem]) {
        selectedImages = []
        for item in items {
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        selectedImages.append(uiImage)
                    }
                }
            }
        }
    }
}

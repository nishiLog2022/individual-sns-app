//
//  CreatePostView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import SwiftUI
import PhotosUI
import Photos

struct CreatePostView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @StateObject private var viewModel = CreatePostViewModel()
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isCaptionFocused: Bool

    var body: some View {
        NavigationView {
            VStack {
                
                // ① 画像選択エリア
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.state.selectedImages) { selected in
                            Button {
                                requestPhotoLibraryPermissionAndShowPicker()
                            } label: {
                                Image(uiImage: selected.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }

                        // 上限枚数未満のときのみ追加ボタンを表示
                        if viewModel.state.selectedImages.count < viewModel.maxPhotoCount {
                            Button {
                                requestPhotoLibraryPermissionAndShowPicker()
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 100, height: 100)

                                    Image(systemName: SystemImage.Post.addImage)
                                        .font(.title)
                                }
                            }
                        }
                    }
                    .photosPicker(
                        isPresented: $viewModel.state.showPhotoPicker,
                        selection: $viewModel.state.selectedItems,
                        maxSelectionCount: viewModel.maxPhotoCount,
                        matching: .images
                    )
                    .padding()
                }
                
                // ② キャプション入力
                VStack(alignment: .leading) {
                    Text(Message.Post.captionLabel)
                        .font(.headline)
                    
                    TextEditor(text: $viewModel.state.caption)
                        .frame(height: 150)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .focused($isCaptionFocused)
                        .onChange(of: viewModel.state.caption) { newValue in
                            guard newValue.count > Const.maxCaptionLength else { return }
                            viewModel.state.caption = String(newValue.prefix(Const.maxCaptionLength))
                        }

                    // 文字数カウンター
                    HStack {
                        Spacer()
                        Text("\(viewModel.state.caption.count) / \(Const.maxCaptionLength)")
                            .font(.caption)
                            .foregroundColor(viewModel.state.caption.count >= Const.maxCaptionLength ? .red : .secondary)
                    }
                }
                .padding()
                
                Spacer()
                
                // ③ 投稿ボタン
                Button(action: createPost) {
                    Text(Message.Button.submit)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.checkPossiblePost() ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!viewModel.checkPossiblePost())
                .padding()
            }
            .navigationTitle(Message.Title.createPost)
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                isCaptionFocused = false
            }
            .onChange(of: viewModel.state.selectedItems) { newItems in
                loadImages()
            }
        }
    }
}

extension CreatePostView {
    func requestPhotoLibraryPermissionAndShowPicker() {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .notDetermined:
            // 未確認：許可ダイアログを表示し、許可されたらピッカーを開く
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    DispatchQueue.main.async {
                        viewModel.state.showPhotoPicker = true
                    }
                }
            }
        case .authorized, .limited:
            // 許可済み：そのままピッカーを開く
            viewModel.state.showPhotoPicker = true
        default:
            // 拒否済み：何もしない（必要に応じて設定アプリへ誘導することも可能）
            break
        }
    }
}

extension CreatePostView {
    func loadImages() {
        let items = viewModel.state.selectedItems
        Task {
            // バックグラウンドで全画像をデコードしてから一括反映
            var loaded: [SelectedImage] = []
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    loaded.append(SelectedImage(image: uiImage))
                }
            }
            await MainActor.run {
                viewModel.state.selectedImages = loaded
            }
        }
    }
}

extension CreatePostView {
    func createPost() {
        let images = viewModel.state.selectedImages.map { $0.image }
        baseViewModel.addPost(caption: viewModel.state.caption, images: images, context: context)
        dismiss()
    }
}

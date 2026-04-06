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
                        ForEach(viewModel.state.selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(8)
                        }

                        // 5枚未満のときのみ追加ボタンを表示
                        if viewModel.state.selectedImages.count < 5 {
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
                            .photosPicker(
                                isPresented: $viewModel.state.showPhotoPicker,
                                selection: $viewModel.state.selectedItems,
                                maxSelectionCount: 5,
                                matching: .images
                            )
                        }
                    }
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
                }
                .padding()
                
                Spacer()
                
                // ③ 投稿ボタン
                Button(action: createPost) {
                    Text(Message.Button.submit)
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
        viewModel.state.selectedImages = []
        for item in viewModel.state.selectedItems {
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

extension CreatePostView {
    func createPost() {
        baseViewModel.addPost(caption: viewModel.state.caption, images: viewModel.state.selectedImages, context: context)
        dismiss()
    }
}

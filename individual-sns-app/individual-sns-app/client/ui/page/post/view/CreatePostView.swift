//
//  CreatePostView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import SwiftUI
import PhotosUI

struct CreatePostView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @StateObject private var viewModel = CreatePostViewModel()
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
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
                        
                        PhotosPicker(
                            selection: $viewModel.state.selectedItems,
                            maxSelectionCount: 5,
                            matching: .images
                        ) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: SystemImage.Post.addImage)
                                    .font(.title)
                            }
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
//            .onChange(of: selectedItems) { _ in
//                loadImages()
//            }
            .onChange(of: viewModel.state.selectedItems) { newItems in
                loadImages()
            }
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

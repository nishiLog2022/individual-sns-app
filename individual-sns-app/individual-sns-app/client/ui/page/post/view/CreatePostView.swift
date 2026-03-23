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
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @State private var caption: String = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        NavigationView {
            VStack {
                
                // ① 画像選択エリア
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(8)
                        }
                        
                        PhotosPicker(
                            selection: $selectedItems,
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
                    
                    TextEditor(text: $caption)
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
                        .background(caption.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(caption.isEmpty)
                .padding()
            }
            .navigationTitle(Message.Title.createPost)
            .navigationBarTitleDisplayMode(.inline)
//            .onChange(of: selectedItems) { _ in
//                loadImages()
//            }
            .onChange(of: selectedItems) { newItems in
                print("選択された数selectedItems:", selectedItems.count)
                print("選択された数:", newItems.count)
                dump(newItems)
//                print("選択された数value:", newItems.value.count)
                loadImages()
            }
        }
    }
}

extension CreatePostView {
    func loadImages() {
        selectedImages = []
        print("画像選択された")

        for item in selectedItems {
            print("item:", item)
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    print("data:", data)

                    await MainActor.run {
                        selectedImages.append(uiImage)
                    }
                }
                print("画像数:", selectedImages.count)
                dump(selectedItems)
            }
        }
    }
}

extension CreatePostView {
    func createPost() {
        baseViewModel.addPost(caption: caption, images: selectedImages, context: context)
        dismiss()
    }
}

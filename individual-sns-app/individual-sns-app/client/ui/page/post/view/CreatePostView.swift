//
//  CreatePostView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import SwiftUI
import PhotosUI
import SwiftData

struct CreatePostView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @StateObject private var viewModel = CreatePostViewModel()
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isCaptionFocused: Bool

    var body: some View {
        NavigationView {
            ZStack {
                VStack {

                    // ① 画像選択エリア
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.state.selectedImages) { selected in
                                Button {
                                    viewModel.requestPhotoLibraryPermissionAndShowPicker()
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
                                    viewModel.requestPhotoLibraryPermissionAndShowPicker()
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
                        HStack {
                            Text(Message.Post.captionLabel)
                                .font(.headline)
                            Spacer()
                            Text("\(viewModel.state.caption.count) / \(Const.maxCaptionLength)")
                                .font(.caption)
                                .foregroundColor(viewModel.state.caption.count >= Const.maxCaptionLength ? .red : .secondary)
                        }

                        TextEditor(text: $viewModel.state.caption)
                            .frame(height: 150)
                            .padding(8)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .focused($isCaptionFocused)
                            .onChange(of: viewModel.state.caption) { _, newValue in
                                guard newValue.count > Const.maxCaptionLength else { return }
                                viewModel.state.caption = String(newValue.prefix(Const.maxCaptionLength))
                            }
                    }
                    .padding()

                    Spacer()

                    // ③ 投稿ボタン
                    Button {
                        viewModel.createPost(baseViewModel: baseViewModel, context: context) {
                            dismiss()
                        }
                    } label: {
                        Text(Message.Button.submit)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.checkPossiblePost() ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(!viewModel.checkPossiblePost() || viewModel.state.isLoadingImages)
                    .padding()
                }
                .navigationTitle(Message.Title.createPost)
                .navigationBarTitleDisplayMode(.inline)
                .onTapGesture {
                    isCaptionFocused = false
                }
                .onChange(of: viewModel.state.selectedItems) { _, newItems in
                    viewModel.loadImages(from: newItems)
                }
                .disabled(viewModel.state.isLoadingImages)

                if viewModel.state.isLoadingImages {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .allowsHitTesting(true)
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(1.5)
                }
            }
        }
    }
}

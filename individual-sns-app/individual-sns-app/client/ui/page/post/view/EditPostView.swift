//
//  EditPostView.swift
//  individual-sns-app
//
import SwiftUI

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
                        if !viewModel.visibleImagePaths.isEmpty {
                            GeometryReader { geo in
                                let width = geo.size.width
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 0) {
                                        ForEach(viewModel.visibleImagePaths, id: \.self) { path in
                                            if let uiImage = ImageStorage.shared.loadImage(fileName: path) {
                                                ZStack(alignment: .topTrailing) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: width, height: 260)
                                                        .background(Color(.systemGray6))
                                                    Button {
                                                        viewModel.markImageForDeletion(path: path)
                                                    } label: {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .font(.title2)
                                                            .foregroundColor(.white)
                                                            .shadow(color: .black.opacity(0.5), radius: 2)
                                                    }
                                                    .padding(8)
                                                }
                                            }
                                        }
                                    }
                                }
                                .scrollTargetLayout()
                                .scrollTargetBehavior(.paging)
                            }
                            .frame(height: 260)
                        }

                        // キャプション
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(Message.Post.captionLabel)
                                    .font(.headline)
                                Spacer()
                                Text("\(viewModel.state.caption.count) / \(Const.maxCaptionLength)")
                                    .font(.caption)
                                    .foregroundColor(viewModel.state.caption.count >= Const.maxCaptionLength ? .red : .secondary)
                            }
                            .padding(.horizontal)
                            TextEditor(text: $viewModel.state.caption)
                                .frame(height: 150)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .focused($isCaptionFocused)
                                .onChange(of: viewModel.state.caption) { _, newValue in
                                    if newValue.count > Const.maxCaptionLength {
                                        viewModel.state.caption = String(newValue.prefix(Const.maxCaptionLength))
                                    }
                                }
                        }
                    }
                    .padding(.top)
                }

                // 保存ボタン
                Button {
                    viewModel.saveEdit(post: post, baseViewModel: baseViewModel) {
                        dismiss()
                    }
                } label: {
                    Text(Message.Button.save)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.canSave ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!viewModel.canSave)
                .padding()
            }
            .navigationTitle(Message.Title.editPost)
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                isCaptionFocused = false
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.state.showDeleteConfirm = true
                    } label: {
                        Image(systemName: SystemImage.Post.delete)
                            .foregroundColor(.red)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if viewModel.hasUnsavedChanges {
                            viewModel.state.showDiscardConfirm = true
                        } else {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .appPopup(
            isPresented: $viewModel.state.showDeleteConfirm,
            title: Message.Post.deleteConfirm,
            destructiveLabel: Message.Button.delete,
            onDestructive: {
                baseViewModel.deletePost(dto: post)
                dismiss()
            }
        )
        .appPopup(
            isPresented: $viewModel.state.showImageDeleteConfirm,
            title: Message.Post.imageDeleteTitle,
            message: Message.Post.imageDeleteMessage,
            destructiveLabel: Message.Post.imageDelete,
            onDestructive: {
                viewModel.confirmDeleteImage()
            },
            onClose: {
                viewModel.state.imagePathToDelete = nil
            }
        )
        .appPopup(
            isPresented: $viewModel.state.showDiscardConfirm,
            title: Message.Common.discardTitle,
            message: Message.Common.discardMessage,
            destructiveLabel: Message.Common.discardButton,
            onDestructive: {
                dismiss()
            }
        )
    }
}

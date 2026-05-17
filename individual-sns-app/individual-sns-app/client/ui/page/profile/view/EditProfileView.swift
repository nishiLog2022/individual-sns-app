//
//  EditProfileView.swift
//  individual-sns-app
//
import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @StateObject private var viewModel: EditProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showRemoveConfirm = false

    init(baseViewModel: AppBaseViewModel) {
        self.baseViewModel = baseViewModel
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(baseViewModel: baseViewModel))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {

                // プロフィール写真
                VStack(spacing: 16) {
                    profileImageView
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())

                    // 写真操作ボタン
                    HStack(spacing: 12) {
                        // 写真を変更ボタン
                        PhotosPicker(selection: $viewModel.state.selectedItem, matching: .images) {
                            Label(Message.Profile.changePhoto, systemImage: SystemImage.Profile.camera)
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color(.systemGray6))
                                .foregroundColor(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .onChange(of: viewModel.state.selectedItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    await MainActor.run {
                                        viewModel.state.previewImage = uiImage
                                        viewModel.state.shouldRemoveImage = false
                                    }
                                }
                            }
                        }

                        // 画像が設定されている場合のみ削除ボタンを表示
                        if viewModel.state.previewImage != nil {
                            Button {
                                showRemoveConfirm = true
                            } label: {
                                Label(Message.Profile.removePhoto, systemImage: "trash")
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color(.systemGray6))
                                    .foregroundColor(.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // 名前入力
                VStack(alignment: .leading, spacing: 6) {
                    Text(Message.Profile.nameLabel)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField(Message.Profile.namePlaceholder, text: $viewModel.state.name)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 32)
            .confirmationDialog(
                Message.Profile.removePhotoConfirm,
                isPresented: $showRemoveConfirm,
                titleVisibility: .visible
            ) {
                Button(Message.Profile.removePhoto, role: .destructive) {
                    viewModel.state.previewImage = nil
                    viewModel.state.selectedItem = nil
                    viewModel.state.shouldRemoveImage = true
                }
                Button(Message.Button.cancel, role: .cancel) {}
            }
            .navigationTitle(Message.Profile.editTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Message.Button.cancel) { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Message.Button.save) {
                        baseViewModel.updateProfile(
                            name: viewModel.state.name,
                            image: viewModel.state.previewImage !== baseViewModel.profileImage ? viewModel.state.previewImage : nil,
                            shouldRemoveImage: viewModel.state.shouldRemoveImage
                        )
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(viewModel.state.name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    @ViewBuilder
    private var profileImageView: some View {
        if let image = viewModel.state.previewImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Image(systemName: SystemImage.Profile.defaultPhoto)
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray.opacity(0.5))
        }
    }
}

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

    init(baseViewModel: AppBaseViewModel) {
        self.baseViewModel = baseViewModel
        _viewModel = StateObject(wrappedValue: EditProfileViewModel(baseViewModel: baseViewModel))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                ScrollView {
                    VStack(spacing: 32) {

                        // プロフィール写真
                        VStack(spacing: 16) {
                            profileImageView
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())

                            HStack(spacing: 12) {
                                PhotosPicker(selection: $viewModel.state.selectedItem, matching: .images) {
                                    Label(Message.Profile.changePhoto, systemImage: SystemImage.Profile.camera)
                                        .font(.subheadline)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(Color(.systemGray6))
                                        .foregroundColor(.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .onChange(of: viewModel.state.selectedItem) { _, newItem in
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

                                if viewModel.state.previewImage != nil {
                                    Button {
                                        viewModel.state.showRemoveConfirm = true
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
                            HStack {
                                Text(Message.Profile.nameLabel)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\(viewModel.state.name.count) / \(Const.maxProfileNameLength)")
                                    .font(.caption)
                                    .foregroundColor(viewModel.state.name.count >= Const.maxProfileNameLength ? .red : .secondary)
                            }
                            TextField(Message.Profile.namePlaceholder, text: $viewModel.state.name)
                                .textFieldStyle(.roundedBorder)
                                .font(.body)
                                .onChange(of: viewModel.state.name) { _, newValue in
                                    if newValue.count > Const.maxProfileNameLength {
                                        viewModel.state.name = String(newValue.prefix(Const.maxProfileNameLength))
                                    }
                                }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 32)
                }

                // 保存ボタン
                Button {
                    baseViewModel.updateProfile(
                        name: viewModel.state.name,
                        image: viewModel.state.previewImage !== baseViewModel.profileImage ? viewModel.state.previewImage : nil,
                        shouldRemoveImage: viewModel.state.shouldRemoveImage
                    )
                    dismiss()
                } label: {
                    Text(Message.Button.save)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.state.name.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(viewModel.state.name.trimmingCharacters(in: .whitespaces).isEmpty)
                .padding()
            }
            .navigationTitle(Message.Profile.editTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
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
            isPresented: $viewModel.state.showRemoveConfirm,
            title: Message.Profile.removePhotoConfirm,
            destructiveLabel: Message.Profile.removePhoto,
            onDestructive: {
                viewModel.state.previewImage = nil
                viewModel.state.selectedItem = nil
                viewModel.state.shouldRemoveImage = true
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

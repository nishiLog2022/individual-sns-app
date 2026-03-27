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
            VStack(spacing: 32) {

                // プロフィール写真
                VStack(spacing: 12) {
                    PhotosPicker(selection: $viewModel.state.selectedItem, matching: .images) {
                        ZStack(alignment: .bottomTrailing) {
                            profileImageView
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())

                            // カメラアイコン
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 28, height: 28)
                                .overlay(
                                    Image(systemName: SystemImage.Profile.camera)
                                        .font(.system(size: 14))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 4, y: 4)
                        }
                    }
                    .onChange(of: viewModel.state.selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                await MainActor.run {
                                    viewModel.state.previewImage = uiImage
                                }
                            }
                        }
                    }

                    Text(Message.Profile.changePhoto)
                        .font(.caption)
                        .foregroundColor(.blue)
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
            .navigationTitle(Message.Profile.editTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Message.Button.cancel) { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Message.Button.save) {
                        baseViewModel.updateProfile(name: viewModel.state.name, image: viewModel.state.previewImage !== baseViewModel.profileImage ? viewModel.state.previewImage : nil)
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

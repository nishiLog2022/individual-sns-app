//
//  EditProfileView.swift
//  individual-sns-app
//
import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var previewImage: UIImage? = nil

    init(baseViewModel: AppBaseViewModel) {
        self.baseViewModel = baseViewModel
        _name = State(initialValue: baseViewModel.profileName)
        _previewImage = State(initialValue: baseViewModel.profileImage)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {

                // プロフィール写真
                VStack(spacing: 12) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
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
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                await MainActor.run {
                                    previewImage = uiImage
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
                    TextField(Message.Profile.namePlaceholder, text: $name)
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
                        baseViewModel.updateProfile(name: name, image: previewImage !== baseViewModel.profileImage ? previewImage : nil)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    @ViewBuilder
    private var profileImageView: some View {
        if let image = previewImage {
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

//
//  SavedView.swift
//  individual-sns-app
//
import SwiftUI

struct SavedView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @StateObject private var viewModel = SavedViewModel()

    var body: some View {
        List {
            ForEach(baseViewModel.folders) { folder in
                NavigationLink {
                    SavedPostListView(folder: folder, baseViewModel: baseViewModel)
                } label: {
                    FolderRowView(folder: folder, baseViewModel: baseViewModel)
                }
            }
            .onDelete { indexSet in
                indexSet.forEach { i in
                    let folder = baseViewModel.folders[i]
                    if !folder.isDefault {
                        baseViewModel.deleteFolder(folder)
                    }
                }
            }
        }
        .navigationTitle(Page.saved.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.state.showAddFolder = true
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.state.showAddFolder) {
            AddFolderSheet(baseViewModel: baseViewModel)
        }
    }
}

// MARK: - フォルダ行

private struct FolderRowView: View {
    let folder: SaveFolderDto
    @ObservedObject var baseViewModel: AppBaseViewModel
    var imageStorage: ImageStorageProtocol = ImageStorage.shared

    var posts: [PostDto] {
        baseViewModel.getPostsInFolder(folder)
    }

    var thumbnail: UIImage? {
        guard let firstPath = posts.first?.imagePaths.first else { return nil }
        return imageStorage.loadImage(fileName: firstPath)
    }

    var body: some View {
        HStack(spacing: 12) {
            // サムネイル
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray5))
                    .frame(width: 52, height: 52)
                if let image = thumbnail {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 52, height: 52)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else {
                    Image(systemName: "folder")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(folder.name)
                    .font(.body)
                Text("\(posts.count)件")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

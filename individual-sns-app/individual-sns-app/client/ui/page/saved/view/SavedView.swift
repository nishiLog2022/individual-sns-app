//
//  SavedView.swift
//  individual-sns-app
//
import SwiftUI

struct SavedView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @StateObject private var viewModel = SavedViewModel()

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(baseViewModel.folders) { folder in
                        NavigationLink {
                            SavedPostListView(folder: folder, baseViewModel: baseViewModel)
                        } label: {
                            FolderGridCell(folder: folder, baseViewModel: baseViewModel)
                        }
                        .foregroundColor(.primary)
                        .contextMenu {
                            if !folder.isDefault {
                                Button {
                                    viewModel.state.renameFolderName = folder.name
                                    viewModel.state.folderToRename = folder
                                    viewModel.state.showRenameFolder = true
                                } label: {
                                    Label(Message.Folder.renameFolder, systemImage: "pencil")
                                }
                                Button(role: .destructive) {
                                    viewModel.state.folderToDelete = folder
                                    viewModel.state.showDeleteFolderConfirm = true
                                } label: {
                                    Label(Message.Button.delete, systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(Page.saved.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if viewModel.canAddFolder(currentFolderCount: baseViewModel.folders.count) {
                            viewModel.state.showAddFolder = true
                        } else {
                            viewModel.state.showBilling = true
                        }
                    } label: {
                        Image(systemName: "folder.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.state.showAddFolder, onDismiss: {
                viewModel.state.newFolderName = ""
            }) {
                AddFolderSheet(
                    title: Message.Folder.addFolder,
                    actionLabel: Message.Folder.addFolder,
                    folderName: $viewModel.state.newFolderName
                ) { trimmed in
                    baseViewModel.createFolder(name: trimmed)
                }
            }
            .sheet(isPresented: $viewModel.state.showRenameFolder, onDismiss: {
                viewModel.state.renameFolderName = ""
                viewModel.state.folderToRename = nil
            }) {
                AddFolderSheet(
                    title: Message.Folder.renameFolderTitle,
                    actionLabel: Message.Folder.renameFolder,
                    folderName: $viewModel.state.renameFolderName
                ) { trimmed in
                    if let folder = viewModel.state.folderToRename {
                        baseViewModel.renameFolder(folder, newName: trimmed)
                    }
                }
            }
            .sheet(isPresented: $viewModel.state.showBilling) {
                BillingView()
            }

            if viewModel.state.showDeleteFolderConfirm {
                AppPopup(
                    title: Message.Folder.deleteFolderTitle,
                    message: Message.Folder.deleteFolderMessage,
                    destructiveLabel: Message.Button.delete,
                    onDestructive: {
                        if let folder = viewModel.state.folderToDelete {
                            baseViewModel.deleteFolder(folder)
                        }
                        viewModel.state.folderToDelete = nil
                        viewModel.state.showDeleteFolderConfirm = false
                    },
                    closeLabel: Message.Common.closeButton,
                    onClose: {
                        viewModel.state.folderToDelete = nil
                        viewModel.state.showDeleteFolderConfirm = false
                    }
                )
            }
        }
    }
}

// MARK: - フォルダグリッドセル

private struct FolderGridCell: View {
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
        VStack(alignment: .leading, spacing: 6) {
            Rectangle()
                .fill(Color(.systemGray5))
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let image = thumbnail {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "folder.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(folder.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)

            Text("\(posts.count)件")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

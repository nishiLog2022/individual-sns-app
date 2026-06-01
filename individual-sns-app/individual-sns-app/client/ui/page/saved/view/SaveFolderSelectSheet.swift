//
//  SaveFolderSelectSheet.swift
//  individual-sns-app
//
import SwiftUI

struct SaveFolderSelectSheet: View {
    let post: PostDto
    @ObservedObject var baseViewModel: AppBaseViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var savedViewModel = SavedViewModel()
    @State private var showAddFolder = false
    @State private var showBilling = false

    var customFolders: [SaveFolderDto] {
        baseViewModel.folders.filter { !$0.isDefault }
    }

    // baseViewModelのpostsから最新の投稿状態を取得
    var livePost: PostDto {
        baseViewModel.posts.first(where: { $0.trnPostId == post.trnPostId }) ?? post
    }

    var body: some View {
        VStack(spacing: 0) {
            // ドラッグインジケーター + 右上にフォルダ追加ボタン
            ZStack {
                HStack {
                    Spacer()
                    Button {
                        if savedViewModel.canAddFolder(currentFolderCount: baseViewModel.folders.count) {
                            showAddFolder = true
                        } else {
                            showBilling = true
                        }
                    } label: {
                        Image(systemName: "folder.badge.plus")
                            .font(.title3)
                            .foregroundColor(.accentColor)
                            .padding(10)
                            .background(Color.accentColor.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 16)
                }
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color(.systemGray4))
                    .frame(width: 36, height: 5)
            }
            .padding(.top, 14)
            .padding(.bottom, 20)

            // スクロール可能なコンテンツ
            ScrollView {
                VStack(spacing: 0) {
                    // 追加完了ヘッダー
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color.accentColor.opacity(0.1))
                                .frame(width: 48, height: 48)
                            Image(systemName: "bookmark.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.accentColor)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("フォルダに追加しました")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("コレクションに追加されました")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)

                    // フォルダ選択エリア
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("フォルダに追加する")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal, 20)

                        if customFolders.isEmpty {
                            Text("カスタムフォルダがありません")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        } else {
                            VStack(spacing: 0) {
                                ForEach(customFolders) { folder in
                                    FolderSelectCell(
                                        folder: folder,
                                        postId: post.trnPostId,
                                        baseViewModel: baseViewModel
                                    )
                                    if folder.mstSaveFolderId != customFolders.last?.mstSaveFolderId {
                                        Divider()
                                            .padding(.leading, 90)
                                    }
                                }
                            }
                        }
                    }

                    Spacer(minLength: 20)
                }
                .padding(.bottom, 8)
            }

            // 閉じるボタン
            Button {
                dismiss()
            } label: {
                Text("閉じる")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
        .sheet(isPresented: $showAddFolder) {
            AddFolderSheet(baseViewModel: baseViewModel)
        }
        .sheet(isPresented: $showBilling) {
            BillingView()
        }
    }
}

// MARK: - フォルダ選択セル

private struct FolderSelectCell: View {
    let folder: SaveFolderDto
    let postId: UUID
    @ObservedObject var baseViewModel: AppBaseViewModel
    var imageStorage: ImageStorageProtocol = ImageStorage.shared
    @State private var cachedThumbnail: UIImage? = nil

    var currentPost: PostDto? {
        baseViewModel.posts.first(where: { $0.trnPostId == postId })
    }

    var isSelected: Bool {
        currentPost?.savedFolderIds.contains(folder.mstSaveFolderId) ?? false
    }

    var body: some View {
        Button {
            guard let post = currentPost else { return }
            if isSelected {
                baseViewModel.unsavePost(post, from: folder)
            } else {
                baseViewModel.savePost(post, to: folder)
            }
        } label: {
            HStack(spacing: 14) {
                // サムネイル
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 56, height: 56)
                    .overlay {
                        if let image = cachedThumbnail {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(systemName: "folder.fill")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                // フォルダ名
                Text(folder.name)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)

                // チェックマーク
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isSelected ? .accentColor : Color(.systemGray3))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
        .onAppear {
            let posts = baseViewModel.getPostsInFolder(folder)
            if let firstPath = posts.first?.imagePaths.first {
                cachedThumbnail = imageStorage.loadImage(fileName: firstPath)
            }
        }
    }
}

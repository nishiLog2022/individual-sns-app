//
//  SavedPostListView.swift
//  individual-sns-app
//
import SwiftUI

struct SavedPostListView: View {
    let folder: SaveFolderDto
    @ObservedObject var baseViewModel: AppBaseViewModel

    var posts: [PostDto] {
        baseViewModel.getPostsInFolder(folder)
    }

    var body: some View {
        Group {
            if posts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bookmark.slash")
                        .font(.system(size: 52))
                        .foregroundColor(.secondary.opacity(0.4))
                    Text("保存された投稿がありません")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(posts) { post in
                            PostView(
                                post: post,
                                baseViewModel: baseViewModel,
                                onLike: { baseViewModel.toggleFavorite(post: post) }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 14)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle(folder.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

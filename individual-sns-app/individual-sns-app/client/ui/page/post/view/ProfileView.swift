//
//  ProfileView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import SwiftUI

struct ProfileView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @StateObject private var viewModel = ProfileViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // ─── プロフィールヘッダー（画面高さの約22%）───
                ProfileHeaderView(
                    baseViewModel: baseViewModel,
                    onEditTap: { viewModel.state.showEditProfile = true }
                )
                .frame(height: geometry.size.height * 0.22)

                Divider()

                ScrollView {
                    // ─── 投稿グリッド ───
                    if baseViewModel.posts.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: SystemImage.Empty.noProfile)
                                .font(.system(size: 48))
                                .foregroundColor(.gray.opacity(0.5))
                            Text(Message.Empty.noPosts)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                    } else {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(baseViewModel.posts) { post in
                                PostThumbnailView(post: post)
                                    .onTapGesture {
                                        viewModel.state.selectedPost = post
                                    }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(Page.profile.title)
        .navigationBarTitleDisplayMode(.inline)
        // プロフィール編集シート
        .sheet(isPresented: $viewModel.state.showEditProfile) {
            EditProfileView(baseViewModel: baseViewModel)
        }
        // タップした投稿を起点にしたタイムラインシート
        .sheet(item: $viewModel.state.selectedPost) { tappedPost in
            PostTimelineView(
                baseViewModel: baseViewModel,
                startPost: tappedPost
            )
        }
    }
}

// MARK: - プロフィールヘッダー

private struct ProfileHeaderView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    let onEditTap: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            // プロフィール写真
            ZStack(alignment: .bottomTrailing) {
                if let image = baseViewModel.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipShape(Circle())
                } else {
                    Image(systemName: SystemImage.Profile.defaultPhoto)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                        .foregroundColor(.gray.opacity(0.4))
                }

                // 編集ボタン（小さいペンアイコン）
                Button(action: onEditTap) {
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: SystemImage.Profile.editButton)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.primary)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
                }
                .offset(x: 2, y: 2)
            }

            // 名前
            Text(baseViewModel.profileName)
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
    }
}

// MARK: - タップ投稿起点のタイムラインシート

private struct PostTimelineView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    let startPost: PostDto
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(baseViewModel.posts) { post in
                            PostView(post: post, baseViewModel: baseViewModel) {
                                baseViewModel.toggleFavorite(post: post)
                            }
                            .id(post.id)
                        }
                    }
                    .padding(.top)
                }
                .onAppear {
                    // タップした投稿まで即スクロール
                    proxy.scrollTo(startPost.id, anchor: .top)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Message.Button.cancel) { dismiss() }
                }
            }
        }
    }
}

// MARK: - サムネイルセル

private struct PostThumbnailView: View {
    let post: PostDto

    private var cellSize: CGFloat {
        (UIScreen.main.bounds.width - 4) / 3
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let firstPath = post.imagePaths.first,
               let uiImage = ImageStorage.shared.loadImage(fileName: firstPath) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cellSize, height: cellSize)
                    .clipped()
            } else {
                ZStack {
                    Color.gray.opacity(0.15)
                    VStack(spacing: 4) {
                        Image(systemName: SystemImage.Post.noImage)
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text(Message.Post.noImage)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: cellSize, height: cellSize)
            }

            if post.imagePaths.count > 1 {
                Image(systemName: SystemImage.Post.multiImage)
                    .font(.caption)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .padding(6)
            }
        }
    }
}

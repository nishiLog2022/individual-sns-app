//
//  PostView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/18.
//
import SwiftUI

struct PostView: View {
    let post: PostDto
    var baseViewModel: AppBaseViewModel
    var onLike: () -> Void
    var imageStorage: ImageStorageProtocol = ImageStorage.shared
    @StateObject private var viewModel = PostViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ─── 日付バナー ───
            HStack(spacing: 8) {
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: 4, height: 18)
                    .cornerRadius(2)

                Text(DateFormatter.postDate.string(from: post.date))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)

                Spacer()

                // 編集ボタン
                Button {
                    viewModel.state.showEdit = true
                } label: {
                    Image(systemName: SystemImage.Post.edit)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // ─── コンテンツエリア（タップで全画面） ───
            Group {
                if post.imagePaths.isEmpty {
                    // テキストのみ
                    HStack(alignment: .top, spacing: 0) {
                        Rectangle()
                            .fill(Color.accentColor.opacity(0.25))
                            .frame(width: 3)

                        Text(post.caption)
                            .font(.body)
                            .lineSpacing(5)
                            .lineLimit(2)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 16)

                } else {
                    // 画像あり
                    GeometryReader { geo in
                        let width = geo.size.width
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                ForEach(Array(post.imagePaths.enumerated()), id: \.offset) { _, path in
                                    if let image = imageStorage.loadImage(fileName: path) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: width, height: 260)
                                            .background(Color(.systemGray6))
                                    }
                                }
                            }
                        }
                        .scrollTargetLayout()
                        .scrollTargetBehavior(.paging)
                        .scrollPosition(id: $viewModel.state.currentIndex)
                        // スクロール中はカードタップを無効にするためジェスチャー競合を避ける
                        .allowsHitTesting(true)
                    }
                    .frame(height: 260)

                    // ページインジケーター
                    if post.imagePaths.count > 1 {
                        HStack(spacing: 5) {
                            ForEach(0..<post.imagePaths.count, id: \.self) { index in
                                Capsule()
                                    .fill(index == (viewModel.state.currentIndex ?? 0)
                                          ? Color.accentColor
                                          : Color.secondary.opacity(0.3))
                                    .frame(
                                        width: index == (viewModel.state.currentIndex ?? 0) ? 16 : 6,
                                        height: 6
                                    )
                                    .animation(.easeInOut(duration: 0.2), value: viewModel.state.currentIndex)
                            }
                        }
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity)
                    }

                    // キャプション（省略表示）
                    Text(post.caption)
                        .font(.body)
                        .lineSpacing(5)
                        .lineLimit(2)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.state.showDetail = true
            }

            // ─── フッター ───
            HStack {
                Spacer()

                // お気に入りボタン
                Button(action: onLike) {
                    HStack(spacing: 4) {
                        Image(systemName: post.isFavorite ? SystemImage.Post.liked : SystemImage.Post.like)
                            .foregroundColor(post.isFavorite ? .red : .secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 14)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
        // 編集シート
        .sheet(isPresented: $viewModel.state.showEdit) {
            EditPostView(baseViewModel: baseViewModel, post: post)
        }
        // 全画面詳細
        .fullScreenCover(isPresented: $viewModel.state.showDetail) {
            PostDetailView(
                post: post,
                baseViewModel: baseViewModel,
                onLike: onLike,
                imageStorage: imageStorage
            )
        }
    }
}

// MARK: - 全画面詳細View

struct PostDetailView: View {
    let post: PostDto
    var baseViewModel: AppBaseViewModel
    var onLike: () -> Void
    var imageStorage: ImageStorageProtocol = ImageStorage.shared
    @StateObject private var viewModel = PostViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // 日付
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: 4, height: 20)
                            .cornerRadius(2)
                        Text(DateFormatter.postDate.string(from: post.date))
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 16)

                    // 画像
                    if !post.imagePaths.isEmpty {
                        GeometryReader { geo in
                            let width = geo.size.width
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    ForEach(Array(post.imagePaths.enumerated()), id: \.offset) { _, path in
                                        if let image = imageStorage.loadImage(fileName: path) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: width)
                                                .background(Color(.systemGray6))
                                        }
                                    }
                                }
                            }
                            .scrollTargetLayout()
                            .scrollTargetBehavior(.paging)
                            .scrollPosition(id: $viewModel.state.currentIndex)
                        }
                        .frame(height: UIScreen.main.bounds.width)

                        // ページインジケーター
                        if post.imagePaths.count > 1 {
                            HStack(spacing: 5) {
                                ForEach(0..<post.imagePaths.count, id: \.self) { index in
                                    Capsule()
                                        .fill(index == (viewModel.state.currentIndex ?? 0)
                                              ? Color.accentColor
                                              : Color.secondary.opacity(0.3))
                                        .frame(
                                            width: index == (viewModel.state.currentIndex ?? 0) ? 16 : 6,
                                            height: 6
                                        )
                                        .animation(.easeInOut(duration: 0.2), value: viewModel.state.currentIndex)
                                }
                            }
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity)
                        }
                    }

                    // キャプション（全文表示）
                    Text(post.caption)
                        .font(.body)
                        .lineSpacing(6)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer(minLength: 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        // お気に入り
                        Button(action: onLike) {
                            Image(systemName: post.isFavorite ? SystemImage.Post.liked : SystemImage.Post.like)
                                .foregroundColor(post.isFavorite ? .red : .primary)
                        }
                        // 編集
                        Button {
                            viewModel.state.showEdit = true
                        } label: {
                            Image(systemName: SystemImage.Post.edit)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.state.showEdit) {
                EditPostView(baseViewModel: baseViewModel, post: post)
            }
        }
    }
}


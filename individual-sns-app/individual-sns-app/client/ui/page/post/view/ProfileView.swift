//
//  ProfileView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import SwiftUI

struct ProfileView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(baseViewModel.posts) { post in
                    PostThumbnailView(post: post)
                }
            }
        }
        .navigationTitle(Page.profile.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 投稿1件分のサムネイルセル
private struct PostThumbnailView: View {
    let post: PostDto
    // 正方形のサイズを画面幅÷3で計算
    private var cellSize: CGFloat {
        (UIScreen.main.bounds.width - 4) / 3
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let firstPath = post.imagePaths.first,
               let uiImage = ImageStorage.shared.loadImage(fileName: firstPath) {
                // 実写真を表示
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: cellSize, height: cellSize)
                    .clipped()
            } else {
                // 写真なし（テキストのみ投稿）
                ZStack {
                    Color.gray.opacity(0.15)
                    VStack(spacing: 4) {
                        Image(systemName: "text.alignleft")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text(post.caption.prefix(12))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 4)
                    }
                }
                .frame(width: cellSize, height: cellSize)
            }

            // 複数枚アイコン
            if post.imagePaths.count > 1 {
                Image(systemName: "square.on.square")
                    .font(.caption)
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .padding(6)
            }
        }
    }
}

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
    @State private var currentIndex: Int? = 0
    @State private var showEdit = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // ヘッダー
            HStack {
                if let image = baseViewModel.profileImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } else {
                    Image(systemName: SystemImage.Profile.defaultPhoto)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.gray.opacity(0.4))
                }

                Text(baseViewModel.profileName)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()
            }
            .padding(.horizontal)

            if post.imagePaths.isEmpty {
                // No Image
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 300)
                    VStack(spacing: 8) {
                        Image(systemName: SystemImage.Post.noImage)
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.6))
                        Text(Message.Post.noImage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                GeometryReader { geo in
                    let width = geo.size.width
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(Array(post.imagePaths.enumerated()), id: \.offset) { index, path in
                                if let image = imageStorage.loadImage(fileName: path) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: width, height: 300)
                                        .background(Color.black)
                                }
                            }
                        }
                    }
                    .scrollTargetLayout()
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $currentIndex)
                }
                .frame(height: 300)

                // ページインジケーター（丸ドット）
                HStack(spacing: 6) {
                    ForEach(0..<post.imagePaths.count, id: \.self) { index in
                        Circle()
                            .fill(index == (currentIndex ?? 0)
                                  ? Color.primary
                                  : Color.primary.opacity(0.3))
                            .frame(width: 7, height: 7)
                    }
                }
                .padding(.top, 6)
                .frame(maxWidth: .infinity)
            }

            // アクション
            HStack(spacing: 16) {
                // お気に入りボタン
                Button(action: onLike) {
                    Image(systemName: post.isFavorite ? SystemImage.Post.liked : SystemImage.Post.like)
                        .font(.title2)
                        .foregroundColor(post.isFavorite ? .red : .primary)
                }

                Spacer()

                // 編集ボタン
                Button {
                    showEdit = true
                } label: {
                    Image(systemName: SystemImage.Post.edit)
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)

            // キャプション
            VStack(alignment: .leading, spacing: 4) {
                Text(post.caption)
                    .font(.body)

                Text(DateFormatter.postDate.string(from: post.date))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showEdit) {
            EditPostView(baseViewModel: baseViewModel, post: post)
        }
    }
}

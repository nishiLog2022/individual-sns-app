//
//  HomeView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel

    var body: some View {
        Group {
            if baseViewModel.posts.isEmpty {
                // 空状態
                VStack(spacing: 16) {
                    Image(systemName: SystemImage.Empty.noPosts)
                        .font(.system(size: 52))
                        .foregroundColor(.secondary.opacity(0.4))
                    Text(Message.Empty.noPosts)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("右上の＋ボタンから\n最初の記録をつけよう")
                        .font(.caption)
                        .foregroundColor(.secondary.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(baseViewModel.posts) { post in
                            PostView(post: post, baseViewModel: baseViewModel) {
                                baseViewModel.toggleFavorite(post: post)
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 14)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle(Page.home.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreatePostView(baseViewModel: baseViewModel)
                } label: {
                    Image(systemName: SystemImage.Toolbar.addPost)
                        .font(.title3)
                }
            }
        }
    }
}

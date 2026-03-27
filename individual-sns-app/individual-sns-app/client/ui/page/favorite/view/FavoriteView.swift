//
//  FavoriteView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import SwiftUI

struct FavoriteView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel

    var body: some View {
        Group {
            if baseViewModel.favoritePosts.isEmpty {
                // 空状態
                VStack(spacing: 12) {
                    Image(systemName: SystemImage.Empty.noFavorites)
                        .font(.system(size: 48))
                        .foregroundColor(.gray.opacity(0.5))
                    Text(Message.Empty.noFavorites)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(baseViewModel.favoritePosts) { post in
                            PostView(post: post, baseViewModel: baseViewModel) {
                                baseViewModel.toggleFavorite(post: post)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .navigationTitle(Page.favorite.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

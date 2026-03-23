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
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(baseViewModel.favoritePosts) { post in
                        PostView(post: post) {
                            baseViewModel.toggleFavorite(post: post)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle(Page.favorite.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

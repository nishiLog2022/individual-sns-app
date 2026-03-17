//
//  FavoriteView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import SwiftUI
struct FavoriteView: View {
    @ObservedObject var vm: PostViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.favoritePosts) { post in
                    PostCardView(post: post) {
                        vm.toggleFavorite(post: post)
                    }
                }
            }
            .navigationTitle("お気に入り")
        }
    }
}

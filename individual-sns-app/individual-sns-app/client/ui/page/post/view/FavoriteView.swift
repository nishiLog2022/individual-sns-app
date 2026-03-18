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
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(vm.posts) { post in
                        PostView(post: post) {
                            vm.toggleFavorite(post: post)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("お気に入り")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

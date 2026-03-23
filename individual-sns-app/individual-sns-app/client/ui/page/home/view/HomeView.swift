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
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(baseViewModel.posts) { post in
                    PostView(post: post) {
                        baseViewModel.toggleFavorite(post: post)
                    }
                }
            }
            .padding(.top)
        }
        .navigationTitle(Page.home.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    CreatePostView(baseViewModel: baseViewModel)
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                }
            }
        }
    }
}

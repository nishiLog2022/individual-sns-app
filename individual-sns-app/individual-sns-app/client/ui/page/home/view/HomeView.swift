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
                VStack(spacing: 12) {
                    Image(systemName: SystemImage.Empty.noPosts)
                        .font(.system(size: 48))
                        .foregroundColor(.gray.opacity(0.5))
                    Text(Message.Empty.noPosts)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(baseViewModel.posts) { post in
                            PostView(post: post, baseViewModel: baseViewModel) {
                                baseViewModel.toggleFavorite(post: post)
                            }
                        }
                    }
                    .padding(.top)
                }
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

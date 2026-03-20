//
//  HomeView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @State private var showCreate = false
    
    var body: some View {
        NavigationView {
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
            .navigationTitle("ホーム")
            .navigationBarTitleDisplayMode(.inline)
            
            // 👇 画面遷移
            .sheet(isPresented: $showCreate) {
                CreatePostView(baseViewModel: baseViewModel)
            }
        }
    }
}

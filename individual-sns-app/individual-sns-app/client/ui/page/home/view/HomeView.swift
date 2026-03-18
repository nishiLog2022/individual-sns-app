//
//  HomeView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: PostViewModel
    @State private var showCreate = false
    
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
            .navigationTitle("ホーム")
            .navigationBarTitleDisplayMode(.inline)
            
//            // 👇 追加
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        showCreate = true
//                    } label: {
//                        Image(systemName: "plus")
//                            .font(.title3)
//                    }
//                }
//            }
            
            // 👇 画面遷移
            .sheet(isPresented: $showCreate) {
                CreatePostView(vm: vm)
            }
        }
    }
}

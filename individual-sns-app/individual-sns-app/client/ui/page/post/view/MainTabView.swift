//
//  MainTabView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var vm = PostViewModel()
    
    var body: some View {
        TabView {
            HomeView(vm: vm)
                .tabItem {
                    Label("ホーム", systemImage: "house")
                }
            
            CreatePostView(vm: vm)
                .tabItem {
                    Label("作成", systemImage: "plus.app")
                }
            
            FavoriteView(vm: vm)
                .tabItem {
                    Label("お気に入り", systemImage: "heart")
                }
            
            ProfileView(vm: vm)
                .tabItem {
                    Label("プロフィール", systemImage: "person")
                }
        }
    }
}

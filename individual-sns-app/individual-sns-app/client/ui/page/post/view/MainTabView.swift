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
            
            // ホーム
            NavigationView {
                HomeView(vm: vm)
            }
            .tabItem {
                Image(systemName: "house")
                Text("ホーム")
            }
            
            // お気に入り
            NavigationView {
                FavoriteView(vm: vm)
            }
            .tabItem {
                Image(systemName: "heart")
                Text("お気に入り")
            }
            
            // 投稿（モーダル）
            CreatePostWrapperView(vm: vm)
                .tabItem {
                    Image(systemName: "plus.app.fill")
                    Text("投稿")
                }
            
            // プロフィール
            NavigationView {
                ProfileView(vm: vm)
            }
            .tabItem {
                Image(systemName: "square.grid.3x3")
                Text("投稿一覧")
            }
            
            // 設定
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: "gearshape")
                Text("設定")
            }
        }
    }
}

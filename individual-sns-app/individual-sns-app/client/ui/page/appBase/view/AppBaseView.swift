//
//  AppBaseView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/20.
//
import SwiftUI

struct AppBaseView: View {
    @StateObject var baseViewModel: AppBaseViewModel = AppBaseViewModel()
    
    var body: some View {
        TabView {
            
            // ホーム
            NavigationView {
                HomeView(baseViewModel: baseViewModel)
            }
            .tabItem {
                Image(systemName: "house")
                Text("ホーム")
            }
            
            // お気に入り
            NavigationView {
                FavoriteView(baseViewModel: baseViewModel)
            }
            .tabItem {
                Image(systemName: "heart")
                Text("お気に入り")
            }
            
            // 投稿（モーダル）
            CreatePostWrapperView(baseViewModel: baseViewModel)
                .tabItem {
                    Image(systemName: "plus.app.fill")
                    Text("投稿")
                }
            
            // プロフィール
            NavigationView {
                ProfileView(baseViewModel: baseViewModel)
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

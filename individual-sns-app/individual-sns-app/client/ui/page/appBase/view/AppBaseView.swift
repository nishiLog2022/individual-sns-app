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
                    .border(.red, width: 2)
            }
            .tabItem {
                Image(systemName: Pages.home.image)
                Text(Pages.home.title)
            }
            
            // お気に入り
            NavigationView {
                FavoriteView(baseViewModel: baseViewModel)
                    .border(.red, width: 2)
            }
            .tabItem {
                Image(systemName: Pages.favorite.image)
                Text(Pages.favorite.title)
            }
            
//            // 投稿（モーダル）
//            CreatePostView(baseViewModel: baseViewModel)
//                .tabItem {
//                    Image(systemName: Pages.post.image)
//                    Text(Pages.post.title)
//                }
            
            // プロフィール
            NavigationView {
                ProfileView(baseViewModel: baseViewModel)
                    .border(.red, width: 2)
            }
            .tabItem {
                Image(systemName: Pages.profile.image)
                Text(Pages.profile.title)
            }
            // 👇 右上ボタン（遷移）
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
            
            // 設定
            NavigationView {
                SettingsView()
                    .border(.red, width: 2)
            }
            .tabItem {
                Image(systemName: Pages.setting.image)
                Text(Pages.setting.title)
            }
        }
    }
}

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
        TabView(selection: $baseViewModel.selectedTab) {
            
            // ホーム
            NavigationView {
                HomeView(baseViewModel: baseViewModel)
            }
            .tabItem {
                Image(systemName: Page.home.image)
                Text(Page.home.title)
            }
            .tag(0)
            
            // お気に入り
            NavigationView {
                FavoriteView(baseViewModel: baseViewModel)
            }
            .tabItem {
                Image(systemName: Page.favorite.image)
                Text(Page.favorite.title)
            }
            .tag(1)
            
            // 保存済み
            NavigationView {
                SavedView(baseViewModel: baseViewModel)
            }
            .tabItem {
                Image(systemName: Page.saved.image)
                Text(Page.saved.title)
            }
            .tag(2)
            
            // プロフィール
            NavigationView {
                ProfileView(baseViewModel: baseViewModel)
            }
            .tabItem {
                Image(systemName: Page.profile.image)
                Text(Page.profile.title)
            }
            .tag(3)
            
            // 設定
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: Page.setting.image)
                Text(Page.setting.title)
            }
            .tag(4)
        }
    }
}

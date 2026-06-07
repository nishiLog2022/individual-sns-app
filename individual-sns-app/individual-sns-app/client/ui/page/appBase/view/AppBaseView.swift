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
        ZStack(alignment: .bottom) {
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
            
            // コレクション
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

        if let message = baseViewModel.toastMessage {
            Text(message)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(.label).opacity(0.85))
                .clipShape(Capsule())
                .padding(.bottom, 90)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .allowsHitTesting(false)
        }

        // アップデート案内（トースト等より上に表示）
        if case .none = baseViewModel.appUpdateType {} else {
            AppUpdatePrompt(
                updateType: baseViewModel.appUpdateType,
                onUpdate: { baseViewModel.openAppStore() },
                onDismiss: { baseViewModel.dismissUpdate() }
            )
        }
        }
        .animation(.easeInOut(duration: 0.3), value: baseViewModel.toastMessage)
    }
}

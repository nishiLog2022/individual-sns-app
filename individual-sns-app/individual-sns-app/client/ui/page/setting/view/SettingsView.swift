//
//  SettingsView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/18.
//
import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Text("アプリについて")
                Text("プライバシーポリシー")
            }
            .navigationTitle(Page.setting.title)
        }
    }
}

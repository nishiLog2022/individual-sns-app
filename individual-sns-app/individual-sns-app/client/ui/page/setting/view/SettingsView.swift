//
//  SettingsView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/18.
//
import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel = SettingsViewModel()


    var body: some View {
        List {
//            Text(Message.Setting.about)
            Text(Message.Setting.privacyPolicy)
        }
        .navigationTitle(Page.setting.title)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Text(viewModel.dispCurrentVersion)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
        }
    }
}

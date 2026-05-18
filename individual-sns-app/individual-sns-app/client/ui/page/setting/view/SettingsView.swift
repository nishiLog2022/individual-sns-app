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
            Link(destination: URL(string: Const.privacyPolicyUrl)!, label: { Text(Message.Setting.privacyPolicy) })
            Link(destination: URL(string: Const.termsUrl)!, label: { Text(Message.Setting.terms) })
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

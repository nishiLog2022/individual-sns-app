//
//  SettingsView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/18.
//
import SwiftUI

struct SettingsView: View {
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
        let build   = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        return "Version \(version) (\(build))"
    }

    var body: some View {
        List {
//            Text(Message.Setting.about)
            Text(Message.Setting.privacyPolicy)
        }
        .navigationTitle(Page.setting.title)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            Text(appVersion)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
        }
    }
}

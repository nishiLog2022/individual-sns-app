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
            // 課金セクション
            Section {
                Button {
                    viewModel.state.showBilling = true
                } label: {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                        if viewModel.isPremium {
                            Text(Message.Billing.alreadyPremium)
                                .foregroundColor(.primary)
                        } else {
                            Text(Message.Billing.navigationTitle)
                                .foregroundColor(.primary)
                        }
                        Spacer()
                        if !viewModel.isPremium {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
                .disabled(viewModel.isPremium)
            }

            // その他のリンク
            Section {
                Link(destination: URL(string: Const.privacyPolicyUrl)!, label: { Text(Message.Setting.privacyPolicy) })
                Link(destination: URL(string: Const.termsUrl)!, label: { Text(Message.Setting.terms) })
            }
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
        .sheet(isPresented: $viewModel.state.showBilling, onDismiss: {
            viewModel.refreshPremiumStatus()
        }) {
            BillingView()
        }
    }
}

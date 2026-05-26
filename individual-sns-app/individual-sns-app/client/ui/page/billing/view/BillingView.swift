//
//  BillingView.swift
//  individual-sns-app
//
import SwiftUI
import StoreKit

struct BillingView: View {
    @StateObject private var viewModel = BillingViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // ヘッダー
                    VStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        Text(Message.Billing.title)
                            .font(.title.bold())
                        Text(Message.Billing.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 32)

                    // 機能比較カード
                    BillingFeatureComparisonCard()

                    // 購入済みバナー or 購入セクション
                    if viewModel.isPremium {
                        BillingPremiumBadgeView()
                    } else {
                        BillingPurchaseSection(viewModel: viewModel)
                    }

                    // 購入復元ボタン
                    if !viewModel.isPremium {
                        Button(Message.Billing.restorePurchase) {
                            viewModel.restorePurchases()
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle(Message.Billing.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Message.Button.cancel) { dismiss() }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                    ProgressView()
                }
            }
            .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
                Button("OK") {}
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}

// MARK: - 機能比較カード

private struct BillingFeatureComparisonCard: View {
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー行
            HStack {
                Text("")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("無料")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
                    .frame(width: 80, alignment: .center)
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
                    .frame(width: 20)
                Text("プレミアム")
                    .font(.caption.bold())
                    .foregroundColor(.yellow)
                    .frame(width: 80, alignment: .center)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(.systemGray5))

            Divider()

            BillingFeatureRow(
                feature: Message.Billing.featureFolder,
                free: Message.Billing.featureFolderFree,
                premium: Message.Billing.featureFolderPremium
            )

            Divider()

            BillingFeatureRow(
                feature: Message.Billing.featurePhoto,
                free: Message.Billing.featurePhotoFree,
                premium: Message.Billing.featurePhotoPremium
            )
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

private struct BillingFeatureRow: View {
    let feature: String
    let free: String
    let premium: String

    var body: some View {
        HStack {
            Text(feature)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(free)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .center)
            Image(systemName: "checkmark")
                .foregroundColor(.yellow)
                .frame(width: 20)
            Text(premium)
                .font(.subheadline.bold())
                .frame(width: 80, alignment: .center)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - 購入セクション

private struct BillingPurchaseSection: View {
    @ObservedObject var viewModel: BillingViewModel

    var body: some View {
        VStack(spacing: 12) {
            if let product = viewModel.product {
                Text(product.displayPrice)
                    .font(.title2.bold())
                Text(Message.Billing.oneTimePurchase)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Button(action: { viewModel.purchase() }) {
                Text(Message.Billing.purchaseButton)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.product != nil ? Color.yellow : Color(.systemGray4))
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }
            .disabled(viewModel.product == nil)
        }
    }
}

// MARK: - 購入済みバナー

private struct BillingPremiumBadgeView: View {
    var body: some View {
        HStack {
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.green)
            Text(Message.Billing.alreadyPremium)
                .font(.headline)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
}

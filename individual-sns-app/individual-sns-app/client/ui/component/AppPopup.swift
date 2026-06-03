//
//  AppPopup.swift
//  individual-sns-app
//
import SwiftUI

struct AppPopup: View {
    let title: String
    let message: String?
    let destructiveLabel: String
    let onDestructive: () -> Void
    let closeLabel: String
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text(title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    if let message {
                        Text(message)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)

                Divider()

                Button(action: onDestructive) {
                    Text(destructiveLabel)
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }

                Divider()

                Button(action: onClose) {
                    Text(closeLabel)
                        .font(.body)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.18), radius: 24, x: 0, y: 6)
            .padding(.horizontal, 44)
        }
    }
}

extension View {
    func appPopup(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        destructiveLabel: String,
        closeLabel: String = Message.Common.closeButton,
        onDestructive: @escaping () -> Void,
        onClose: @escaping () -> Void = {}
    ) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                AppPopup(
                    title: title,
                    message: message,
                    destructiveLabel: destructiveLabel,
                    onDestructive: {
                        isPresented.wrappedValue = false
                        onDestructive()
                    },
                    closeLabel: closeLabel,
                    onClose: {
                        isPresented.wrappedValue = false
                        onClose()
                    }
                )
            }
        }
    }
}

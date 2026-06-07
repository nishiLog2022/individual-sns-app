//
//  AppUpdatePrompt.swift
//  individual-sns-app
//
import SwiftUI

struct AppUpdatePrompt: View {
    let updateType: AppUpdateType
    let onUpdate: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.blue)
                        .padding(.bottom, 4)

                    switch updateType {
                    case .forced:
                        Text(Message.Update.forcedTitle)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        Text(Message.Update.forcedMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    default:
                        Text(Message.Update.optionalTitle)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        Text(Message.Update.optionalMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)

                Divider()

                Button(action: onUpdate) {
                    Text(Message.Update.updateButton)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }

                if case .optional = updateType {
                    Divider()
                    Button(action: onDismiss) {
                        Text(Message.Update.laterButton)
                            .font(.body)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                    }
                }
            }
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.18), radius: 24, x: 0, y: 6)
            .padding(.horizontal, 44)
        }
    }
}

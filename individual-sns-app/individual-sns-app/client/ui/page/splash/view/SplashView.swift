//
//  SplashView.swift
//  individual-sns-app
//
import SwiftUI

struct SplashView: View {
    @State private var isVisible = true
    @State private var opacity = 0.0
    @State private var scale = 0.8

    var body: some View {
        ZStack {
            // AppBaseView を常時レンダリング（NavigationView が最初から存在する）
            // スプラッシュ表示中は不透明度を 0 にして画面をチラつかせない
            AppBaseView()
                .opacity(isVisible ? 0 : 1)

            // スプラッシュをオーバーレイ
            if isVisible {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()

                    VStack(spacing: 20) {
                        // アイコン（仮置き）
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue, Color.purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)

                            Image(systemName: SystemImage.Splash.appIcon)
                                .font(.system(size: 44))
                                .foregroundColor(.white)
                        }

                        Text(Message.Splash.appName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.5)) {
                        opacity = 1.0
                        scale = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                        withAnimation(.easeIn(duration: 0.3)) {
                            opacity = 0.0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isVisible = false
                        }
                    }
                }
            }
        }
    }
}

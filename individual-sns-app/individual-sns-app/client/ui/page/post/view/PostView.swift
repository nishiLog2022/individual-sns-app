//
//  PostView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/18.
//
import SwiftUI
struct PostView: View {
    let post: PostModel
    var onLike: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // ヘッダー
            HStack {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 32, height: 32)
                
                Text("My Diary")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(.horizontal)
            
            // 画像
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 300)
                .overlay(
                    Text("Image")
                        .foregroundColor(.gray)
                )
            
            // アクション
            HStack(spacing: 16) {
                Button(action: onLike) {
                    Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(post.isFavorite ? .red : .primary)
                }
                
                Image(systemName: "bubble.right")
                    .font(.title2)
                
                Spacer()
            }
            .padding(.horizontal)
            
            // キャプション
            VStack(alignment: .leading, spacing: 4) {
                Text(post.caption)
                    .font(.body)
                
                Text(post.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
        }
    }
}

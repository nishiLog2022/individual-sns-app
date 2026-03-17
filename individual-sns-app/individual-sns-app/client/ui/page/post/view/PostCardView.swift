//
//  PostCardView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import SwiftUI
struct PostCardView: View {
    let post: PostModel
    var onLike: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            if let image = post.image {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            }
            
            Text(post.caption)
                .font(.body)
            
            HStack {
                Button(action: onLike) {
                    Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Text(post.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
    }
}

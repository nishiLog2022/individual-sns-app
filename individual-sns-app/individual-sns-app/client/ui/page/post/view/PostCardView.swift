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
            
            if let firstPath = post.imagePaths.first,
               let image = ImageStorage.shared.loadImage(fileName: firstPath) {
                
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
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

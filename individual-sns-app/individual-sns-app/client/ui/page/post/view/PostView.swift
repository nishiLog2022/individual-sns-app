//
//  PostView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/18.
//
import SwiftUI
struct PostView: View {
    let post: PostDto
    var onLike: () -> Void
    var imageStorage: ImageStorageProtocol = ImageStorage.shared
    @State private var currentIndex: Int? = 0
    var body: some View {
//        GeometryReader { geometry in
//            let imageWidth = geometry.size.width * 0.95
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
                
                if post.imagePaths.isEmpty {
                    
                    // 画像なし
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)
                        
                        Text("画像なし")
                            .foregroundColor(.gray)
                    }
                    
                } else {
                    GeometryReader { geo in
                                    
                        let width = geo.size.width
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                
                                ForEach(Array(post.imagePaths.enumerated()), id: \.offset) { index, path in

                                    if let image = imageStorage.loadImage(fileName: path) {
                                        
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: width, height: 300)
                                            .background(Color.black)
//                                            .id(index) // 👈 これ重要
                                            
//                                            // 👇 ここが重要
//                                            .background(
//                                                GeometryReader { itemGeo in
//                                                    Color.clear
//                                                        .onChange(of: itemGeo.frame(in: .global).minX) { x in
//                                                            let screenWidth = UIScreen.main.bounds.width
//                                                            
//                                                            let newIndex = Int(round(-x / screenWidth))
//                                                            
//                                                            if newIndex != currentIndex &&
//                                                                newIndex >= 0 &&
//                                                                newIndex < post.imagePaths.count {
//                                                                currentIndex = newIndex
//                                                            }
//                                                        }
//                                                }
//                                            )
                                    }
                                }
                            }
                        }
                        .scrollTargetLayout() // 👈 必須
                        .scrollTargetBehavior(.paging) // 👈 ページング
                        .scrollPosition(id: $currentIndex) // 👈 これが核心
//                        .scrollTargetBehavior(.paging) // 👈 ページ単位で止まる
//                        .scrollPosition(id: Binding(
//                            get: { currentIndex },
//                            set: { currentIndex = $0 ?? 0 }
//                        ))
                    }
                    .frame(height: 300)
//                    
                    // ページインジケーター（丸ドット）
                    HStack(spacing: 6) {
                        ForEach(0..<post.imagePaths.count, id: \.self) { index in
                            Circle()
                                .fill(index == (currentIndex ?? 0)
                                      ? Color.primary
                                      : Color.primary.opacity(0.3))
                                .frame(width: 7, height: 7)
                        }
                    }
                    .padding(.top, 6)
                    .frame(maxWidth: .infinity)
                }
                
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
//        }
    }
}

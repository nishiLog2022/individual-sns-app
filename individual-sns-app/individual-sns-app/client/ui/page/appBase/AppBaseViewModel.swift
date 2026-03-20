//
//  AppBaseViewModel.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/20.
//
import Foundation
import SwiftUI

class AppBaseViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    
    init() {
        loadMock()
    }
    
    func loadMock() {
        posts = [
            PostModel(id: UUID(), caption: "今日はいい日だった", imagePaths: [], date: Date(), isFavorite: false),
            PostModel(id: UUID(), caption: "カフェで作業☕️", imagePaths: [], date: Date(), isFavorite: true)
        ]
    }
    
    func addPost(caption: String, images: [UIImage]) {
        
        let paths = images.compactMap {
            ImageStorage.shared.saveImage($0)
        }
        
        let newPost = PostModel(
            id: UUID(),
            caption: caption,
            imagePaths: paths,
            date: Date(),
            isFavorite: false
        )
        
        posts.insert(newPost, at: 0)
    }
    
    func toggleFavorite(post: PostModel) {
        if let index = posts.firstIndex(of: post) {
            posts[index].isFavorite.toggle()
        }
    }
    
    var favoritePosts: [PostModel] {
        posts.filter { $0.isFavorite }
    }
}

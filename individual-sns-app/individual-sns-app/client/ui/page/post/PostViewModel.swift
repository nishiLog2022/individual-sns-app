//
//  PostViewModel.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//

import Foundation
import SwiftUI

class PostViewModel: ObservableObject {
    @Published var posts: [PostModel] = []
    
    init() {
        loadMock()
    }
    
    func loadMock() {
        posts = [
            PostModel(id: UUID(), caption: "今日はいい日だった", image: nil, date: Date(), isFavorite: false),
            PostModel(id: UUID(), caption: "カフェで作業☕️", image: nil, date: Date(), isFavorite: true)
        ]
    }
    
    func addPost(caption: String) {
        let newPost = PostModel(
            id: UUID(),
            caption: caption,
            image: nil,
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

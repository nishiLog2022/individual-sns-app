//
//  AppBaseViewModel.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/20.
//
import Foundation
import SwiftUI
import SwiftData

class AppBaseViewModel: ObservableObject {
    private let databaseService: DatabaseServiceProtocol = DiContainer.shared.container.resolve(DatabaseServiceProtocol.self)!
    private let postUsecase: PostUsecaseProtocol = DiContainer.shared.container.resolve(PostUsecaseProtocol.self)!
    private let imageStorage: ImageStorageProtocol = DiContainer.shared.container.resolve(ImageStorageProtocol.self)!
    @Published var posts: [PostDto] = []
    @Published var selectedTab: Int = 0
    
    init() {
        getDbURL()
        loadPost()
    }
    
    func loadPost() {
        posts = postUsecase.getPostsForList()
    }
    
    // DBのURLの取得
    func getDbURL() {
        databaseService.copyUrl()
    }
    
    func addPost(caption: String, images: [UIImage], context: ModelContext) {
        let paths = images.compactMap {
            imageStorage.saveImage($0)
        }
        
        let post = PostDto(
            caption: caption,
            imagePaths: paths
        )
        
        postUsecase.savePostData(dto: post)
        posts = postUsecase.getPostsForList()
        selectedTab = 0
    }
    
    func toggleFavorite(post: PostDto) {
        if let index = posts.firstIndex(of: post) {
            posts[index].isFavorite.toggle()
        }
    }
    
    var favoritePosts: [PostDto] {
        posts.filter { $0.isFavorite }
    }
}

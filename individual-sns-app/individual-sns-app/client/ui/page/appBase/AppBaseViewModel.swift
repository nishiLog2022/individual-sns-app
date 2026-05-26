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
    private let saveFolderUsecase: SaveFolderUsecaseProtocol = DiContainer.shared.container.resolve(SaveFolderUsecaseProtocol.self)!

    @Published var posts: [PostDto] = []
    @Published var folders: [SaveFolderDto] = []
    @Published var selectedTab: Int = 0

    // MARK: - プロフィール
    @Published var profileName: String {
        didSet { UserDefaults.standard.set(profileName, forKey: "profileName") }
    }
    /// Documents/profile.jpg のファイル名。nil の場合はデフォルトアイコンを表示
    @Published var profileImageFileName: String? {
        didSet { UserDefaults.standard.set(profileImageFileName, forKey: "profileImageFileName") }
    }

    var profileImage: UIImage? {
        guard let fileName = profileImageFileName else { return nil }
        return imageStorage.loadImage(fileName: fileName)
    }

    init() {
        profileName = UserDefaults.standard.string(forKey: "profileName") ?? Message.Profile.defaultName
        profileImageFileName = UserDefaults.standard.string(forKey: "profileImageFileName")
        getDbURL()
        loadPost()
        _ = saveFolderUsecase.ensureDefaultFolder()
        loadFolders()
    }

    func updateProfile(name: String, image: UIImage?, shouldRemoveImage: Bool = false) {
        profileName = name
        if shouldRemoveImage {
            // 画像を未設定状態に戻す
            if let old = profileImageFileName {
                imageStorage.deleteImage(fileName: old)
            }
            profileImageFileName = nil
        } else if let image = image {
            // 既存のプロフィール画像を削除してから保存
            if let old = profileImageFileName {
                imageStorage.deleteImage(fileName: old)
            }
            profileImageFileName = imageStorage.saveImage(image)
        }
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
    
    func updatePost(dto: PostDto) {
        postUsecase.updatePostData(dto: dto)
        posts = postUsecase.getPostsForList()
    }

    func deletePost(dto: PostDto) {
        postUsecase.deletePostData(dto: dto)
        posts = postUsecase.getPostsForList()
    }

    func toggleFavorite(post: PostDto) {
        if let index = posts.firstIndex(of: post) {
            posts[index].isFavorite.toggle()
        }
    }
    
    var favoritePosts: [PostDto] {
        posts.filter { $0.isFavorite }
    }

    // MARK: - フォルダ管理

    func loadFolders() {
        folders = saveFolderUsecase.getFolders()
    }

    func savePost(_ post: PostDto, to folder: SaveFolderDto) {
        let updated = saveFolderUsecase.savePost(post, to: folder)
        if let index = posts.firstIndex(where: { $0.trnPostId == post.trnPostId }) {
            posts[index] = updated
        }
    }

    func unsavePost(_ post: PostDto, from folder: SaveFolderDto) {
        let updated = saveFolderUsecase.unsavePost(post, from: folder)
        if let index = posts.firstIndex(where: { $0.trnPostId == post.trnPostId }) {
            posts[index] = updated
        }
    }

    func getPostsInFolder(_ folder: SaveFolderDto) -> [PostDto] {
        saveFolderUsecase.getPostsInFolder(folder, allPosts: posts)
    }

    func createFolder(name: String) {
        _ = saveFolderUsecase.createFolder(name: name)
        loadFolders()
    }

    func deleteFolder(_ folder: SaveFolderDto) {
        saveFolderUsecase.deleteFolder(folder)
        loadFolders()
        loadPost()
    }
}

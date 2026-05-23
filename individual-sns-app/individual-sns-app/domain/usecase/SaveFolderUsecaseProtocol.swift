//
//  SaveFolderUsecaseProtocol.swift
//  individual-sns-app
//
import Foundation

protocol SaveFolderUsecaseProtocol {
    func getFolders() -> [SaveFolderDto]
    func createFolder(name: String) -> SaveFolderDto
    func deleteFolder(_ folder: SaveFolderDto)
    func savePost(_ post: PostDto, to folder: SaveFolderDto) -> PostDto
    func unsavePost(_ post: PostDto, from folder: SaveFolderDto) -> PostDto
    func getPostsInFolder(_ folder: SaveFolderDto, allPosts: [PostDto]) -> [PostDto]
    func ensureDefaultFolder() -> SaveFolderDto
}

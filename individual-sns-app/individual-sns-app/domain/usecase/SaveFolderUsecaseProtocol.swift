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
    func unsaveFromAllFolders(_ post: PostDto) -> PostDto
    func getPostsInFolder(_ folder: SaveFolderDto, allPosts: [PostDto]) -> [PostDto]
    func renameFolder(_ folder: SaveFolderDto, newName: String)
    func ensureDefaultFolder() -> SaveFolderDto
}

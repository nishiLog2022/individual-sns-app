//
//  PostUsecaseProtocol.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//
import Foundation

protocol PostUsecaseProtocol {
    func savePostData(dto: PostDto)
    func updatePostData(dto: PostDto)
    func deletePostData(dto: PostDto)
    func getPostsForList() -> [PostDto]
    func getPostsForProfile() -> [PostDto]
}


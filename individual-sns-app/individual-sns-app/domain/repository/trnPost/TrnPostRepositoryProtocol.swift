//
//  TrnPostRepositoryProtocol.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//
import Foundation

protocol TrnPostRepositoryProtocol {
    func create(_ dto: PostDto)
    func update(_ dto: PostDto)
    func delete(_ dto: PostDto)
    func getAllPosts() -> [TrnPost]
    func getPosts(conditions: DbConditionsDto<TrnPost>) -> [TrnPost]
}

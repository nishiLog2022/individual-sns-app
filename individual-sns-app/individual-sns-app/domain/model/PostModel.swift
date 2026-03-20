//
//  PostModel.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import Foundation

struct PostModel: Identifiable, Hashable {
    let id: UUID
    var caption: String
    var imagePaths: [String] // ← ここ重要
    var date: Date
    var isFavorite: Bool
}

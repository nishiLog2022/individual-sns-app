//
//  TrnPost.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/20.
//
import SwiftData
import Foundation

@Model
class TrnPost {
    var trnPostId: UUID
    var caption: String
    var imagePaths: [String]
    var date: Date
    var isFavorite: Bool
    
    init(
        trnPostId: UUID = UUID(),
        caption: String,
        imagePaths: [String] = [],
        date: Date = Date(),
        isFavorite: Bool = false
    ) {
        self.trnPostId = trnPostId
        self.caption = caption
        self.imagePaths = imagePaths
        self.date = date
        self.isFavorite = isFavorite
    }
    
    
    func update(dto: PostDto) {
        self.trnPostId = dto.trnPostId
        self.caption = dto.caption
        self.imagePaths = dto.imagePaths
        self.date = dto.date
        self.isFavorite = dto.isFavorite
    }
    
    func createDto() -> PostDto {
        return PostDto(
            trnPostId: self.trnPostId
            , caption: self.caption
            , imagePaths: self.imagePaths
            , date: self.date
            , isFavorite: self.isFavorite
        )
    }
}

//
//  PostDto.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//

import SwiftUI
struct PostDto: Codable, Identifiable, Hashable {
    var id: UUID
    var trnPostId: UUID
    var caption: String
    var imagePaths: [String]
    var date: Date
    var isFavorite: Bool
    var savedFolderIds: [UUID]

    var isSaved: Bool { !savedFolderIds.isEmpty }

    init(
        trnPostId: UUID = UUID(),
        caption: String,
        imagePaths: [String] = [],
        date: Date = Date(),
        isFavorite: Bool = false,
        savedFolderIds: [UUID] = []
    ) {
        self.id = UUID()
        self.trnPostId = trnPostId
        self.caption = caption
        self.imagePaths = imagePaths
        self.date = date
        self.isFavorite = isFavorite
        self.savedFolderIds = savedFolderIds
    }
    
    init(post: TrnPost) {
        self.id = UUID()
        self.trnPostId = post.trnPostId
        self.caption = post.caption
        self.imagePaths = post.imagePaths
        self.date = post.date
        self.isFavorite = post.isFavorite
        self.savedFolderIds = post.savedFolderIds
    }
    
    func createTrnPost() -> TrnPost {
        return TrnPost(
            trnPostId: self.trnPostId,
            caption: self.caption,
            imagePaths: self.imagePaths,
            date: self.date,
            isFavorite: self.isFavorite,
            savedFolderIds: self.savedFolderIds
        )
    }
}

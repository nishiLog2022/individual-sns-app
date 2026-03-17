//
//  Post.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import Foundation
import CoreData
class Post: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var caption: String
    @NSManaged var createdAt: Date
    @NSManaged var isFavorite: Bool
    @NSManaged var medias: Set<Media>
}

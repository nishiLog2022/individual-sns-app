//
//  Media.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import Foundation
import CoreData

class Media: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var localPath: String
    @NSManaged var type: String
    @NSManaged var orderIndex: Int16
    @NSManaged var post: Post
}

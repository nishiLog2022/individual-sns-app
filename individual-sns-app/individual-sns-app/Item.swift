//
//  Item.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

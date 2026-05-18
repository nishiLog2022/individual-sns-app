//
//  DbConditionsDto.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//
import SwiftUI
import SwiftData
class DbConditionsDto<T>: Codable {
    let predicate: Predicate<T>?
    let sort: [SortDescriptor<T>]
    let limit: Int?

    init(
        predicate: Predicate<T>? = nil
        , sort: [SortDescriptor<T>] = []
        , limit: Int? = nil
    ){
        self.predicate = predicate
        self.sort = sort
        self.limit = limit
    }

}

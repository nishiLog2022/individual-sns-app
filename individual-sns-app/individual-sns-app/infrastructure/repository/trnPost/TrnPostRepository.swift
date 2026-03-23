//
//  TrnPostRepository.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//
import SwiftUI
import SwiftData
final class TrnPostRepository: TrnPostRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func create(_ dto: PostDto) {
        context.insert(dto.createTrnPost())
        do {
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func update(_ dto: PostDto) {
        guard let record = getTargetData(dto: dto) else {
            return
        }
        do {
            record.update(dto: dto)
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func delete(_ dto: PostDto) {
        guard let record = getTargetData(dto: dto) else {
            return
        }
        do {
            context.delete(record)
            try context.save()
        } catch let error {
            print(error)
        }
    }
    
    func getAllPosts() -> [TrnPost] {
        let descriptor = FetchDescriptor<TrnPost>()
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    func getPosts(conditions: DbConditionsDto<TrnPost>) -> [TrnPost] {
        var descriptor = FetchDescriptor<TrnPost>(
            predicate: conditions.predicate
            , sortBy: conditions.sort
        )
        
        if let limit = conditions.limit {
            descriptor.fetchLimit = limit
        }
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
    }
    
    private func getTargetData(dto: PostDto) -> TrnPost? {
        let condition = #Predicate<TrnPost> { record in
            record.trnPostId == dto.trnPostId
        }
        let conditions = DbConditionsDto<TrnPost>(
            predicate: condition
        )
        let records = getPosts(conditions: conditions)
        // 更新対象のレコードがない場合はreturn
        if records.count <= 0 {
            return nil
        }
        return records.first
    }
}

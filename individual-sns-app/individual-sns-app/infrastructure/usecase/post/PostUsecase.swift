//
//  PostUsecase.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/21.
//
import Foundation

class PostUsecase: PostUsecaseProtocol {
    private let trnPostRepository: TrnPostRepositoryProtocol
    
    init(trnPostRepository: TrnPostRepositoryProtocol) {
        self.trnPostRepository = trnPostRepository
    }
    
    // 投稿の保存
    func savePostData(dto: PostDto) {
        trnPostRepository.create(dto)
    }
    
    // ポストの取得（ホーム用）
    func getPostsForList() -> [PostDto] {
        let sortBy: [SortDescriptor<TrnPost>] = [
            SortDescriptor(\.date, order: .reverse)
        ]
        
        let conditions = DbConditionsDto<TrnPost>(
            sort: sortBy
            , limit: Const.getDataLimitForList
        )
        let dto = trnPostRepository.getPosts(conditions: conditions).map{ $0.createDto() }
        return dto
    }
    
    // ポストの取得（プロフィール用）
    func getPostsForProfile() -> [PostDto] {
        let sortBy: [SortDescriptor<TrnPost>] = [
            SortDescriptor(\.date, order: .reverse)
        ]
        
        let conditions = DbConditionsDto<TrnPost>(
            sort: sortBy
            , limit: Const.getDataLimitForProfile
        )
        let dto = trnPostRepository.getPosts(conditions: conditions).map{ $0.createDto() }
        if dto.count < 0 {
            return []
        }
        return dto
    }
    
    
}

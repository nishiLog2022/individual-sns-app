//
//  EditPostViewModel.swift
//  individual-sns-app
//
import Foundation

class EditPostViewModel: ObservableObject {
    private let billingUsecase: BillingUsecaseProtocol =
        DiContainer.shared.container.resolve(BillingUsecaseProtocol.self)!

    @Published var state: EditPostState

    var maxPhotoCount: Int {
        billingUsecase.maxPhotoCount
    }

    init(post: PostDto) {
        self.state = EditPostState(post: post)
    }
}

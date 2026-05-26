//
//  CreatePostViewModel.swift
//  individual-sns-app
//
import Foundation

class CreatePostViewModel: ObservableObject {
    private let billingUsecase: BillingUsecaseProtocol =
        DiContainer.shared.container.resolve(BillingUsecaseProtocol.self)!

    @Published var state = CreatePostState()

    /// 選択可能な写真の最大枚数
    var maxPhotoCount: Int {
        billingUsecase.maxPhotoCount
    }

    // 投稿可能チェック（写真またはキャプションが入力されていればtrue）
    func checkPossiblePost() -> Bool {
        if state.caption.isEmpty == true && state.selectedImages.isEmpty == true {
            return false
        }
        return true
    }
}

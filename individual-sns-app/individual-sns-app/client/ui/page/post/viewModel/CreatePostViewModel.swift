//
//  CreatePostViewModel.swift
//  individual-sns-app
//
import Foundation

class CreatePostViewModel: ObservableObject {
    @Published var state = CreatePostState()
    
    // 投稿可能チェック（写真またはキャプションが入力されていればtrue）
    func checkPossiblePost() -> Bool {
        if state.caption.isEmpty == true && state.selectedImages.isEmpty == true {
            return false
        }
        return true
    }
}

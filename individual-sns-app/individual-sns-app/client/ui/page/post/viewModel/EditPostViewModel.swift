//
//  EditPostViewModel.swift
//  individual-sns-app
//
import Foundation

class EditPostViewModel: ObservableObject {
    @Published var state: EditPostState

    init(post: PostDto) {
        self.state = EditPostState(post: post)
    }
}

//
//  PostViewModel.swift
//  individual-sns-app
//
import Foundation

class PostViewModel: ObservableObject {
    @Published var state = PostState()
}

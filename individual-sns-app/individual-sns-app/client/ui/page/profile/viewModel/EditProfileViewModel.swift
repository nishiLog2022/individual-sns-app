//
//  EditProfileViewModel.swift
//  individual-sns-app
//
import Foundation

class EditProfileViewModel: ObservableObject {
    @Published var state: EditProfileState

    init(baseViewModel: AppBaseViewModel) {
        self.state = EditProfileState(baseViewModel: baseViewModel)
    }
}

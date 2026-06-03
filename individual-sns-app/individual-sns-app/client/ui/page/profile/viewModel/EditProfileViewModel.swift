//
//  EditProfileViewModel.swift
//  individual-sns-app
//
import Foundation
import SwiftUI

class EditProfileViewModel: ObservableObject {
    @Published var state: EditProfileState
    private let originalName: String
    private let originalImage: UIImage?

    init(baseViewModel: AppBaseViewModel) {
        self.originalName = baseViewModel.profileName
        self.originalImage = baseViewModel.profileImage
        self.state = EditProfileState(baseViewModel: baseViewModel)
    }

    var hasUnsavedChanges: Bool {
        state.name != originalName
            || state.selectedItem != nil
            || state.shouldRemoveImage
    }
}

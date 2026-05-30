//
//  AddFolderSheet.swift
//  individual-sns-app
//
import SwiftUI

struct AddFolderSheet: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var folderName = ""

    var body: some View {
        NavigationView {
            Form {
                TextField(Message.Folder.folderNamePlaceholder, text: $folderName)
            }
            .navigationTitle(Message.Folder.addFolder)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Message.Button.cancel) { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Message.Folder.addFolder) {
                        let trimmed = folderName.trimmingCharacters(in: .whitespaces)
                        if !trimmed.isEmpty {
                            baseViewModel.createFolder(name: trimmed)
                            dismiss()
                        }
                    }
                    .disabled(folderName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

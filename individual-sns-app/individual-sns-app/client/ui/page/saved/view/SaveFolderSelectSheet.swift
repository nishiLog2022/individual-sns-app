//
//  SaveFolderSelectSheet.swift
//  individual-sns-app
//
import SwiftUI

struct SaveFolderSelectSheet: View {
    let post: PostDto
    @ObservedObject var baseViewModel: AppBaseViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showAddFolder = false

    var body: some View {
        NavigationView {
            List {
                ForEach(baseViewModel.folders) { folder in
                    Button {
                        if post.savedFolderIds.contains(folder.mstSaveFolderId) {
                            baseViewModel.unsavePost(post, from: folder)
                        } else {
                            baseViewModel.savePost(post, to: folder)
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "folder")
                                .foregroundColor(.accentColor)
                            Text(folder.name)
                            Spacer()
                            if post.savedFolderIds.contains(folder.mstSaveFolderId) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }

                Button {
                    showAddFolder = true
                } label: {
                    HStack {
                        Image(systemName: "folder.badge.plus")
                            .foregroundColor(.accentColor)
                        Text(Message.Folder.newFolder)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle(Message.Folder.saveToFolder)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Message.Button.cancel) { dismiss() }
                }
            }
            .sheet(isPresented: $showAddFolder) {
                AddFolderSheet(baseViewModel: baseViewModel)
            }
        }
    }
}

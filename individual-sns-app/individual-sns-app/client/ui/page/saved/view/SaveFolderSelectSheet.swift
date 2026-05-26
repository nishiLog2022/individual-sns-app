//
//  SaveFolderSelectSheet.swift
//  individual-sns-app
//
import SwiftUI

struct SaveFolderSelectSheet: View {
    let post: PostDto
    @ObservedObject var baseViewModel: AppBaseViewModel
    @Environment(\.dismiss) private var dismiss
    @StateObject private var savedViewModel = SavedViewModel()
    @State private var showAddFolder = false
    @State private var showBilling = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
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
                }

                Divider()

                Button {
                    if savedViewModel.canAddFolder(currentFolderCount: baseViewModel.folders.count) {
                        showAddFolder = true
                    } else {
                        showBilling = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "folder.badge.plus")
                        Text(Message.Folder.newFolder)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.vertical, 12)
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
            .sheet(isPresented: $showBilling) {
                BillingView()
            }
        }
    }
}

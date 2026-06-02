//
//  AddFolderSheet.swift
//  individual-sns-app
//
import SwiftUI

struct AddFolderSheet: View {
    let title: String
    let actionLabel: String
    @Binding var folderName: String
    let onSave: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    TextField(Message.Folder.folderNamePlaceholder, text: $folderName)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: folderName) { _, newValue in
                            if newValue.count > Const.maxFolderNameLength {
                                folderName = String(newValue.prefix(Const.maxFolderNameLength))
                            }
                        }
                    Text("\(folderName.count) / \(Const.maxFolderNameLength)")
                        .font(.caption)
                        .foregroundColor(folderName.count >= Const.maxFolderNameLength ? .red : .secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Button {
                    let trimmed = folderName.trimmingCharacters(in: .whitespaces)
                    if !trimmed.isEmpty {
                        onSave(trimmed)
                        dismiss()
                    }
                } label: {
                    Text(actionLabel)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(folderName.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(folderName.trimmingCharacters(in: .whitespaces).isEmpty)

                Spacer()
            }
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Message.Button.cancel) { dismiss() }
                }
            }
        }
    }
}

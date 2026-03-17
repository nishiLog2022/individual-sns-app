//
//  CreatePostView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import SwiftUI
struct CreatePostView: View {
    @ObservedObject var vm: PostViewModel
    @State private var caption = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $caption)
                    .frame(height: 200)
                    .border(Color.gray)
                    .padding()
                
                Button("投稿する") {
                    vm.addPost(caption: caption)
                    caption = ""
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("作成")
        }
    }
}

//
//  ProfileView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/17.
//
import SwiftUI
struct ProfileView: View {
    @ObservedObject var vm: PostViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(vm.posts) { post in
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 120)
                            .overlay(
                                Text(post.caption.prefix(10))
                                    .font(.caption)
                            )
                    }
                }
            }
            .navigationTitle("プロフィール")
        }
    }
}

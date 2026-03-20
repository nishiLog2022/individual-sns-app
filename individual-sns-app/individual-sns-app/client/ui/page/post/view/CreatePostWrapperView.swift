//
//  CreatePostWrapperView.swift
//  individual-sns-app
//
//  Created by taichi nishimura on R 8/03/18.
//
import SwiftUI

struct CreatePostWrapperView: View {
    @ObservedObject var baseViewModel: AppBaseViewModel
    @State private var showCreate = false
    
    var body: some View {
        Color.clear
            .onAppear {
                showCreate = true
            }
            .sheet(isPresented: $showCreate) {
                CreatePostView(baseViewModel: baseViewModel)
            }
    }
}


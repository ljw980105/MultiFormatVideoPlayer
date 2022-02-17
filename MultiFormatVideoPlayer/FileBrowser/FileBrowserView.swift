//
//  FileBrowserView.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/9/22.
//

import SwiftUI

struct FileBrowserView: View {
    @ObservedObject var viewModel = FileBrowserViewModel()
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.files, id: \.fileName) { file in
                    Button(file.fileName) {
                        isPresented.toggle()
                    }
                    .fullScreenCover(isPresented: $isPresented) {
                        VideoPlayerView(file: file)
                    }
                }
                .onDelete { indexSet in
                    viewModel.deleteVideo(at: indexSet)
                }
            }
            .navigationTitle("Videos")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

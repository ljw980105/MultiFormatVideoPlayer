//
//  VideoPlayerView.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

struct VideoPlayerView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isUnSupported = false
    @State var isPlaying = false
    let file: VideoFile
    
    init(file: VideoFile) {
        self.file = file
    }
    
    var body: some View {
        ZStack {
            VideoPlayerContainer(videoFile: file)
            VStack {
                HStack {
                    Button("Dismiss") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    HStack {
                        FixedWidthSpacer(length: 20)
                        ForwardButton()
                        FixedWidthSpacer(length: 40)
                        ZStack {
                            PlayButton()
                                .opacity(isPlaying ? 0 : 1)
                            PauseButton()
                                .opacity(isPlaying ? 1 : 0)
                            TappableArea(width: 70, height: 70)
                                .onTapGesture {
                                    isPlaying.toggle()
                                }
                        }
                        FixedWidthSpacer(length: 40)
                        BackwardButton()
                        FixedWidthSpacer(length: 20)
                    }
                        .padding(5)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                    Spacer()
                }
            }
        }
        .onAppear {
            isUnSupported = file.ext == .unknown
        }
        .padding(20)
        .alert("This video format is not supported", isPresented: $isUnSupported) {
            Button("OK", role: .cancel) { }
        }
    }
}

//
//  VideoPlayerView.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

struct VideoPlayerView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isUnsupported = false
    @StateObject var state: VideoPlayerState = .init()
    let file: VideoFile
    let callbacks: VideoPlayerCallbacks
    
    init(file: VideoFile) {
        self.file = file
        self.callbacks = .init()
    }
    
    var body: some View {
        ZStack {
            VideoPlayerContainer(
                videoFile: file,
                callbacks: callbacks,
                isPlaying: $state.isPlaying,
                playHeadPosition: $state.playHeadPosition,
                totalDuration: $state.totalDuration,
                progress: $state.progress
            )
            VStack {
                HStack {
                    Button("Dismiss") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    FixedWidthSpacer(length: 20)
                    Slider(value: $state.progress, onEditingChanged: { isEditing in
                        isEditing ? callbacks.startedDraggingSlider?() : callbacks.endedDraggingSlider?()
                    })
                }
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Text(file.fileName)
                            .font(.headline)
                        HStack {
                            FixedWidthSpacer(length: 20)
                            BackwardButton()
                                .onTapGesture {
                                    callbacks.seekBackward?()
                                }
                            FixedWidthSpacer(length: 40)
                            ZStack {
                                PlayButton()
                                    .opacity(state.isPlaying ? 0 : 1)
                                PauseButton()
                                    .opacity(state.isPlaying ? 1 : 0)
                                TappableArea(width: 40, height: 40)
                                    .onTapGesture {
                                        state.isPlaying.toggle()
                                    }
                            }
                            FixedWidthSpacer(length: 40)
                            ForwardButton()
                                .onTapGesture {
                                    callbacks.seekForward?()
                                }
                            FixedWidthSpacer(length: 20)
                        }
                    }
                        .padding(.init(top: 5, leading: 5, bottom: 10, trailing: 5))
                        .background(.thinMaterial)
                        .cornerRadius(20)
                    Spacer()
                }
            }
        }
        .onAppear {
            isUnsupported = file.ext == .unknown
        }
        .padding(20)
        .alert("This video format is not supported", isPresented: $isUnsupported) {
            Button("OK", role: .cancel) { }
        }
    }
}

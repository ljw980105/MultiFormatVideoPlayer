//
//  VideoPlayerContainer.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import Foundation
import SwiftUI

final class VideoPlayerContainer: UIViewControllerRepresentable {
    @Binding var isPlaying: Bool
    @Binding var playHeadPosition: Double
    @Binding var totalDuration: Double
    @Binding var progress: Double
    
    typealias UIViewControllerType = VideoPlayerContainerViewController
    
    let videoFile: VideoFile
    var vc: VideoPlayerContainerViewController?
    let callbacks: VideoPlayerCallbacks
    
    init(
        videoFile: VideoFile,
        callbacks: VideoPlayerCallbacks,
        isPlaying: Binding<Bool>,
        playHeadPosition: Binding<Double>,
        totalDuration: Binding<Double>,
        progress: Binding<Double>
    ) {
        self.videoFile = videoFile
        self._isPlaying = isPlaying
        self.callbacks = callbacks
        self._playHeadPosition = playHeadPosition
        self._totalDuration = totalDuration
        self._progress = progress
        self.callbacks.seekForward = { [weak self] in
            self?.vc?.seekForward()
        }
        self.callbacks.seekBackward = { [weak self] in
            self?.vc?.seekBackward()
        }
    }
    
    func makeUIViewController(context: Context) -> VideoPlayerContainerViewController {
        .init(videoFile: videoFile, delegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: VideoPlayerContainerViewController, context: Context) {
        vc = uiViewController
        uiViewController.update(isPlaying: isPlaying)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

extension VideoPlayerContainer {
    class Coordinator: VideoPlayerDelegate {
        let parent: VideoPlayerContainer
        
        init(parent: VideoPlayerContainer) {
            self.parent = parent
        }
        
        func videoPlayer(
            _ videoPlayer: VideoPlayable,
            didChangeTime time: Double,
            totalDuration: Double,
            progress: Double
        ) {
            parent.playHeadPosition = time
            parent.totalDuration = totalDuration
            parent.progress = progress
        }
    }
}

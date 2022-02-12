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
    
    typealias UIViewControllerType = VideoPlayerContainerViewController
    
    let videoFile: VideoFile
    var vc: VideoPlayerContainerViewController?
    let callbacks: VideoPlayerCallbacks
    
    init(
        videoFile: VideoFile,
        callbacks: VideoPlayerCallbacks,
        isPlaying: Binding<Bool>
    ) {
        self.videoFile = videoFile
        self._isPlaying = isPlaying
        self.callbacks = callbacks
        self.callbacks.seekForward = { [weak self] in
            self?.vc?.seekForward()
        }
        self.callbacks.seekBackward = { [weak self] in
            self?.vc?.seekBackward()
        }
        self.callbacks.getCurrentState =  { [weak self] in
            self?.vc?.currentState ?? .default
        }
        self.callbacks.updateProgress = { [weak self] progress in
            self?.vc?.update(progress: progress)
        }
    }
    
    func makeUIViewController(context: Context) -> VideoPlayerContainerViewController {
        .init(videoFile: videoFile)
    }
    
    func updateUIViewController(_ uiViewController: VideoPlayerContainerViewController, context: Context) {
        vc = uiViewController
        uiViewController.update(isPlaying: isPlaying)
    }
}

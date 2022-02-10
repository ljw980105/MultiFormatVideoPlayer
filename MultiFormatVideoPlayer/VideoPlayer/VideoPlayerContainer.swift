//
//  VideoPlayerContainer.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import Foundation
import SwiftUI

final class VideoPlayerContainer: UIViewControllerRepresentable {
    typealias UIViewControllerType = VideoPlayerContainerViewController
    let videoFile: VideoFile
    
    init(videoFile: VideoFile) {
        self.videoFile = videoFile
    }
    
    func makeUIViewController(context: Context) -> VideoPlayerContainerViewController {
        .init(videoFile: videoFile)
    }
    
    func updateUIViewController(_ uiViewController: VideoPlayerContainerViewController, context: Context) {
        
    }
    
    
}

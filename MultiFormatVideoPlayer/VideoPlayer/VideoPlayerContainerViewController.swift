//
//  VideoPlayerContainerViewController.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import UIKit
import SnapKit

class VideoPlayerContainerViewController: UIViewController {
    let videoView: VideoPlayable
    
    init(videoFile: VideoFile) {
        videoView = videoFile.makeView()
        super.init(nibName: nil, bundle: nil)
        view.addSubview(videoView)
        videoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(isPlaying: Bool) {
        videoView.update(isPlaying: isPlaying)
    }
    
    func update(progress: Double) {
        videoView.update(progress: progress)
    }
    
    func seekForward() {
        videoView.goForwardFifteenSeconds()
    }
    
    func seekBackward() {
        videoView.goBackwardsFifteenSeconds()
    }
    
    var currentState: VideoPlayerPlayheadState {
        videoView.currentState
    }
}

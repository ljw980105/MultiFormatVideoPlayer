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
    var onDisappear: (() -> Void)?
    var firstShown = true
    
    init(videoFile: VideoFile) {
        videoView = videoFile.makeView()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if firstShown {
            firstShown = false
            videoView.seekToLastPlayTime()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.addSubview(videoView)
        videoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onDisappear?()
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

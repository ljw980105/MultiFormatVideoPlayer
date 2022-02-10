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
        self.videoView = videoFile.makeView()
        super.init(nibName: nil, bundle: nil)
        view.addSubview(videoView)
        videoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoView.play()
    }
}

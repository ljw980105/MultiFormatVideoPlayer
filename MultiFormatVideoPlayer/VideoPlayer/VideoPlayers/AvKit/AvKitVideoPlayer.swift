//
//  AvKitVideoPlayer.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import UIKit
import AVKit

class AvKitVideoPlayer: UIView, VideoPlayable {
    var videoFile: VideoFile
    weak var delegate: VideoPlayerDelegate?
    let player: AVPlayer
    var observationToken: Any?
    
    init(videoFile: VideoFile) {
        self.videoFile = videoFile
        let asset = AVAsset(url: videoFile.url)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        self.player = player
        super.init(frame: .zero)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        guard let newSuperview = newSuperview else {
            return
        }
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = newSuperview.bounds
        playerLayer.videoGravity = .resizeAspect
        layer.addSublayer(playerLayer)
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        guard let asset = player.currentItem?.asset else {
            return
        }

        observationToken = player.addPeriodicTimeObserver(forInterval: 0.2.cmTime, queue: .main) { [weak self] cmTime in
            guard let self = self else { return }
            self.delegate?.videoPlayer(
                self,
                didChangeTime: cmTime.double,
                totalDuration: asset.duration.double,
                progress: cmTime.double / asset.duration.double
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func goForwardFifteenSeconds() {
        let currentTime = player.currentTime()
        player.seek(to: currentTime + 15.cmTime)
    }
    
    func goBackwardsFifteenSeconds() {
        let currentTime = player.currentTime()
        player.seek(to: currentTime - 15.cmTime)
    }
    
    func update(progress: Double) {
        guard let asset = player.currentItem?.asset else {
            return
        }
        player.seek(to: CMTimeMultiplyByFloat64(asset.duration, multiplier: Float64(progress)))
    }
}

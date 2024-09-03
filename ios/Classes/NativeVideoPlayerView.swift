import UIKit
import AVFoundation

class NativeVideoPlayerView: UIView {
     let playerLayer: AVPlayerLayer


    required init?(coder: NSCoder) {
        fatalError("init(coder:) - use init(frame:) instead")
    }

    init(
        frame: CGRect,
        player: AVPlayer
    ) {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        
        super.init(frame: frame)

        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        layer.addSublayer(playerLayer)
    }

    deinit {
        playerLayer.removeFromSuperlayer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
        playerLayer.removeAllAnimations()
    }
}

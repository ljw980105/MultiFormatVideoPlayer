//
//  Double+Extensions.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/11/22.
//

import Foundation

extension Double {
    var timeString: String {
        let hours = String(Int(self) / 3600)
        let secondsRemainingAfterHours = Int(self) % 3600
        let minute = String(secondsRemainingAfterHours / 60)
        let seconds = String(secondsRemainingAfterHours % 60)
        return "\(hours.additionalZeroAdded):\(minute.additionalZeroAdded):\(seconds.additionalZeroAdded)"
    }
}

fileprivate extension String {
    var additionalZeroAdded: String {
        self.count == 1 ? "0\(self)" : self
    }
}

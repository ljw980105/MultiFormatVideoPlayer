//
//  BackwardButton.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

struct BackwardButton: View {
    var body: some View {
        ZStack {
            Image(systemName: "gobackward.15")
                .font(.system(size: 40.0))
                .foregroundColor(Color.white)
            TappableArea(width: 40, height: 40)
        }
    }
}

struct BackwardButton_Previews: PreviewProvider {
    static var previews: some View {
        BackwardButton()
    }
}

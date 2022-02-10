//
//  ForwardButton.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

struct ForwardButton: View {
    var body: some View {
        Image(systemName: "gobackward.15")
            .font(.system(size: 40.0))
            .foregroundColor(Color.white)
    }
}

struct ForwardButton_Previews: PreviewProvider {
    static var previews: some View {
        ForwardButton()
    }
}

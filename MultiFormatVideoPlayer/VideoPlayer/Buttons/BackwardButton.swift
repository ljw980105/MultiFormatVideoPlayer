//
//  BackwardButton.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

struct BackwardButton: View {
    var body: some View {
        Image(systemName: "goforward.15")
            .font(.system(size: 40.0))
            .foregroundColor(Color.white)
    }
}

struct BackwardButton_Previews: PreviewProvider {
    static var previews: some View {
        BackwardButton()
    }
}

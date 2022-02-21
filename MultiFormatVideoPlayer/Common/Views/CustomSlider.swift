//
//  CustomSlider.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/20/22.
//

import Foundation
import SwiftUI

/// [Source](https://swiftuirecipes.com/blog/custom-slider-in-swiftui)
struct CustomSlider<Track, Fill, Thumb>: View
where Track: View, Fill: View, Thumb: View {
    /// the value of the slider, inside `bounds`
    @Binding var value: Double
    /// range to which the thumb offset is mapped
    let bounds: ClosedRange<Double>
    /// tells how discretely does the value change
    let step: Double
    /// called with `true` when sliding starts and with `false` when it stops
    let onEditingChanged: ((Bool) -> Void)?
    /// the track view
    let track: () -> Track
    /// the fill view
    let fill: (() -> Fill)?
    /// the thumb view
    let thumb: () -> Thumb
    /// tells how big the thumb is. This is here because there's no good
    /// way in SwiftUI to get the thumb size at runtime, and its an important
    /// to know it in order to compute its insets in the track overlay.
    let thumbSize: CGSize
    
    let minimumValueLabel: () -> Text?
    
    let maximumValueLabel: () -> Text?
    
    /// x offset of the thumb from the track left-hand side
    @State private var xOffset: CGFloat = 0
    /// last moved offset, used to decide if sliding has started
    @State private var lastOffset: CGFloat = 0
    
    @State private var firstDragged = true

    
    /// initializer allows us to set default values for some view params
    init(value: Binding<Double>,
         in bounds: ClosedRange<Double> = 0...1,
         step: Double = 0.001,
         minimumValueLabel: @escaping () -> Text? = { nil },
         maxinumValueLabel: @escaping () -> Text? = { nil },
         onEditingChanged: ((Bool) -> Void)? = nil,
         track: @escaping () -> Track,
         fill: (() -> Fill)?,
         thumb: @escaping () -> Thumb,
         thumbSize: CGSize) {
        _value = value
        self.bounds = bounds
        self.step = step
        self.onEditingChanged = onEditingChanged
        self.track = track
        self.fill = fill
        self.thumb = thumb
        self.thumbSize = thumbSize
        self.maximumValueLabel = maxinumValueLabel
        self.minimumValueLabel = minimumValueLabel
    }
    
    /// where does the current value sit, percentage-wise, in the provided bounds
    private var percentage: Double {
        1 - (bounds.upperBound - value) / (bounds.upperBound - bounds.lowerBound)
    }
    
    var body: some View {
        HStack {
            minimumValueLabel()
            GeometryReader { proxy in
                ZStack {
                    track()
                    fill?()
                    // `fill` changes both its position and frame as its
                    // anchor point is in its middle (at (0.5, 0.5)).
                        .position(x: fillWidth(proxy: proxy) - proxy.size.width / 2, y: proxy.size.height / 2)
                        .frame(width: fillWidth(proxy: proxy))
                }
                // the thumb lives in the ZStack overlay
                .overlay(thumb()
                         // adjust the insets so that `thumb` doesn't sit outside the `track`
                            .position(x: thumbSize.width / 2,
                                      y: thumbSize.height / 2)
                         // set the size here to make sure it's really the same as the
                         // provided `thumbSize` parameter
                            .frame(width: thumbSize.width, height: thumbSize.height)
                         // set the offset to, well, the stored xOffset
                            .offset(x: thumbPosition(proxy: proxy))
                         // use the DragGesture to move the `thumb` around as adjust xOffset
                            .gesture(DragGesture(minimumDistance: 0).onChanged({ gestureValue in
                    // make sure at least some dragging was done to trigger `onEditingChanged`
                    if abs(gestureValue.translation.width) < 0.1 {
                        lastOffset = xOffset
                        onEditingChanged?(true)
                    }
                    
                    if firstDragged {
                        firstDragged = false
                        lastOffset = fillWidth(proxy: proxy)
                    }
                    
                    // update xOffset by the gesture translation, making sure it's within the view's bounds
                    let availableWidth = proxy.size.width - thumbSize.width
                    xOffset = max(0, min(lastOffset + gestureValue.translation.width, availableWidth))
                    // update the value by mapping xOffset to the track width and then to the provided bounds
                    // also make sure that the value changes discretely based on the `step` para
                    let newValue = (bounds.upperBound - bounds.lowerBound) * Double(xOffset / availableWidth) + bounds.lowerBound
                    let steppedNewValue = (round(newValue / step) * step)
                    value = min(bounds.upperBound, max(bounds.lowerBound, steppedNewValue))
                }).onEnded({ _ in
                    // once the gesture ends, trigger `onEditingChanged` again
                    onEditingChanged?(false)
                })),
                         alignment: .leading
                )
            }
            maximumValueLabel()
        }
    }
    
    private func fillWidth(proxy: GeometryProxy) -> CGFloat {
        percentage * proxy.size.width
    }
    
    private func thumbPosition(proxy: GeometryProxy) -> CGFloat {
        max(0, fillWidth(proxy: proxy) - 10)
    }
}

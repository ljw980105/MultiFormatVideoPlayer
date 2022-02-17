//
//  VideoPlayerView.swift
//  MultiFormatVideoPlayer
//
//  Created by Jing Wei Li on 2/10/22.
//

import SwiftUI

fileprivate enum Styles {
    static var controlPanelGraident: Gradient {
        Gradient(stops: [
            .init(color: Color(red: 115/255, green: 115/255, blue: 115/255), location: 0),
            .init(color: .black, location: 0.8)
        ])
    }
    static var controlPanelStrokeColor: Color {
        .init(red: 152/255, green: 152/255, blue: 152/255)
    }
    static var topBarGraident: Gradient {
        Gradient(stops: [
            .init(color: Color(red: 44/255, green: 44/255, blue: 44/255), location: 0),
            .init(color: .black, location: 0.3)
        ])
    }
    static var doneButtonGraident: Gradient {
        Gradient(stops: [
            .init(color: Color(red: 125/255, green: 153/255, blue: 227/255), location: 0),
            .init(color: Color(red: 53/255, green: 97/255, blue: 213/255), location: 0.5)
        ])
    }
    static var thumbRadius: CGFloat { 30 }
}

struct VideoPlayerView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isUnsupported = false
    @StateObject var viewModel: VideoPlayerViewModel = .init()
    let file: VideoFile
    let callbacks: VideoPlayerCallbacks
    
    init(file: VideoFile) {
        self.file = file
        self.callbacks = .init()
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VideoPlayerContainer(
                    videoFile: file,
                    callbacks: callbacks,
                    isPlaying: $viewModel.isPlaying
                )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.isControlsHidden.toggle()
                            viewModel.autoHideUI()
                        }
                    }
                VStack {
                    HStack(alignment: .center, spacing: 0) {
                        FixedWidthSpacer(length: 20)
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Done")
                                .font(.headline)
                                .padding(10)
                                .background(LinearGradient(gradient: Styles.doneButtonGraident, startPoint: .top, endPoint: .bottom))
                                .cornerRadius(5)
                                .foregroundColor(.white)
                        })
                        FixedWidthSpacer(length: 20)
                        CustomSlider(
                            value: $viewModel.progress,
                            minimumValueLabel: Text($viewModel.currentTime.wrappedValue).foregroundColor(.white),
                            maximumValueLabel: Text($viewModel.remainingTime.wrappedValue).foregroundColor(.white),
                            onEditingChanged: { isEditing in
                                if isEditing {
                                    stopTimer()
                                    viewModel.isPlaying = false
                                } else {
                                    startTimer()
                                    viewModel.isPlaying = true
                                    callbacks.updateProgress?(viewModel.progress)
                                }
                            }, track: {
                                Capsule()
                                    .foregroundColor(.init(red: 0.9, green: 0.9, blue: 0.9))
                                    .frame(width: max(0, proxy.size.width - 300), height: 5)
                            }, fill: {
                                Capsule()
                                    .foregroundColor(.blue)
                            }, thumb: {
                                Image("thumb")
                                    .resizable()
                                    .shadow(radius: 20)
                            }, thumbSize: CGSize(width: 20, height: 20)
                        )
                        Spacer()
                }
                        .frame(height: 60)
                        .background(
                            LinearGradient(gradient: Styles.controlPanelGraident, startPoint: .top, endPoint: .bottom)
                                .opacity(0.8)
                        )
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Styles.controlPanelStrokeColor, lineWidth: 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 20).fill(
                                        LinearGradient(gradient: Styles.controlPanelGraident, startPoint: .top, endPoint: .bottom)
                                    )
                                )
                                .frame(width: 300, height: 120)
        
                                .opacity(0.5)
                            VStack {
                                Text(file.fileName)
                                    .font(.headline)
                                HStack {
                                    FixedWidthSpacer(length: 20)
                                    BackwardButton()
                                        .onTapGesture {
                                            callbacks.seekBackward?()
                                            viewModel.autoHideUI()
                                        }
                                    FixedWidthSpacer(length: 40)
                                    ZStack {
                                        PlayButton()
                                            .opacity(viewModel.isPlaying ? 0 : 1)
                                        PauseButton()
                                            .opacity(viewModel.isPlaying ? 1 : 0)
                                        TappableArea(width: 40, height: 40)
                                            .onTapGesture {
                                                viewModel.isPlaying.toggle()
                                                viewModel.autoHideUI()
                                            }
                                    }
                                    FixedWidthSpacer(length: 40)
                                    ForwardButton()
                                        .onTapGesture {
                                            callbacks.seekForward?()
                                            viewModel.autoHideUI()
                                        }
                                    FixedWidthSpacer(length: 20)
                                }
                            }
                            .padding(.init(top: 5, leading: 5, bottom: 10, trailing: 5))
                        }
                        Spacer()
                    }
                }
                .opacity(viewModel.isControlsHidden ? 0 : 1)
            }
            .onAppear {
                isUnsupported = file.ext == .unknown
                stopTimer()
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
            .padding(.init(top: 10, leading: 0, bottom: 20, trailing: 0))
            .alert("This video format is not supported", isPresented: $isUnsupported) {
                Button("OK", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func stopTimer() {
        viewModel.timer?.invalidate()
        viewModel.cancelAutoHide()
    }
    
    func startTimer() {
        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if let state = callbacks.getCurrentState?() {
                self.viewModel.process(state: state)
            }
        }
        viewModel.autoHideUI()
    }
}

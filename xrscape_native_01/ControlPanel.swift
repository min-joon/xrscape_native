import Foundation
import AVFoundation
import SwiftUI
import RealityKit

struct ControlPanel: View {
    @Binding var isWindowVisible: Bool
    
    @EnvironmentObject var appModel: AppModel
    
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var userInput: String = ""
    @State private var audioPlayer: AVAudioPlayer?
    let playHTService = PlayHTService()
    @State private var apiResponse: String = ""
    private var openAiApiKey: String = Secrets.OPENAI_API_KEY
    private var chatGPTService: ChatGPTService
    
    init(isWindowVisible: Binding<Bool>) {
        self._isWindowVisible = isWindowVisible
        self.openAiApiKey = Secrets.OPENAI_API_KEY
        self.chatGPTService = ChatGPTService(apiKey: self.openAiApiKey)
    }

    let imageDiameter: CGFloat = 100
    let imageSpacing: CGFloat = 40
    
    var body: some View {
        GeometryReader { geometry in
            if isWindowVisible { // 조건부 뷰 추가
                VStack {
                    HStack (spacing: imageSpacing) {
                        ScenaryButton(identifier: "yosemite", title: "Yosemite", imageDiameter: imageDiameter, isHidden: false)
                        ScenaryButton(identifier: "liberty_island", title: "Liberty Island", imageDiameter: imageDiameter, isHidden: true)
                        ScenaryButton(identifier: "chigogafuchi_abyss", title: "Chigogafuchi Abyss", imageDiameter: imageDiameter, isHidden: true)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 1/5)
                    .offset(y: geometry.size.height * 1/5)
                }
                HStack (spacing: imageSpacing) {
                    ScenaryButton(identifier: "matsumoto_castle", title: "Matsumoto Castle", imageDiameter: imageDiameter, isHidden: true)
                    ScenaryButton(identifier: "santa_monica_pier", title: "Santa Monica Pier", imageDiameter: imageDiameter, isHidden: true)
                    ScenaryButton(identifier: "lake_martin", title: "Lake Martin", imageDiameter: imageDiameter, isHidden: false)
                    ScenaryButton(identifier: "oshima_bridge", title: "Oshima Bridge", imageDiameter: imageDiameter, isHidden: true)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 1/5)
                .offset(y: geometry.size.height * 2/5)
                HStack (spacing: imageSpacing) {
                    ScenaryButton(identifier: "lewis", title: "Lewis", imageDiameter: imageDiameter, isHidden: false)
                    ScenaryButton(identifier: "han_river", title: "Han River", imageDiameter: imageDiameter, isHidden: true)
                    ScenaryButton(identifier: "ulleng", title: "Ullengdo", imageDiameter: imageDiameter, isHidden: true)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 1/5)
                .offset(y: geometry.size.height * 3/5)
                VStack {
                    TextField("User Input", text: $speechRecognizer.speechInput)
                        .padding()
                        .opacity(0.0)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(true)
                        .onChange(of: speechRecognizer.speechInput, perform: { newValue in
                            if !newValue.isEmpty {
                                chatGPTService.sendToOpenAI(input: newValue) { result in
                                    switch result {
                                    case .success(let response):
                                        DispatchQueue.main.async {
                                            self.apiResponse = response
                                            Task {
                                                await playHTService.generateTTS(text: self.apiResponse)
                                            }
                                        }
                                    case .failure(let error):
                                        DispatchQueue.main.async {
                                            self.apiResponse = "Error: \(error.localizedDescription)"
                                        }
                                    }
                                }
                            }
                        })
                    HStack {
                        Button(action: {
                            speechRecognizer.startListening()
                        }) {
                            Text("Start Listening")
                        }
                        .padding()
                        .disabled(speechRecognizer.isListening)
                    }
                }
                .padding(.top)
            }
        }
        .persistentSystemOverlays(.hidden)
        .animation(.snappy, value: isWindowVisible)
        .onChange(of: isWindowVisible) { newValue in
            if newValue {
                SoundPlayer.shared.playSystemSound(id: 1397) // unlock sound
            } else {
                SoundPlayer.shared.playSystemSound(id: 1396) // lock sound
            }
        }
    }
}

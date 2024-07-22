import Speech
import AVFoundation
import SwiftUI

class SpeechRecognizer: ObservableObject {
    @Published var recognizedText = ""
    @Published var isListening = false
    @Published var speechInput = ""
    
    private let speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private let audioSession = AVAudioSession.sharedInstance()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var silenceTimer: Timer?

    func startListening() {
        // Play system sound to indicate the start of listening
        AudioServicesPlaySystemSound(1104) // Example sound ID

        self.isListening = true
        self.recognizedText = ""

        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session properties weren't set because of an error.")
            return
        }

        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            print("Speech recognizer is not available.")
            return
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            print("Audio Engine couldn't start because of an error.")
            return
        }

        recognitionTask = speechRecognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                    self.resetSilenceTimer()
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
                self.stopListening()
            }
        }

        resetSilenceTimer()
    }

    private func resetSilenceTimer() {
        silenceTimer?.invalidate()
        silenceTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            self.stopListening()
        }
    }

    func stopListening() {
        // Play system sound to indicate the end of listening
        AudioServicesPlaySystemSound(1105) // Example sound ID

        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.finish()
        recognitionTask = nil
        silenceTimer?.invalidate()
        
        // Only update speechInput if recognizedText is not empty
        if !recognizedText.isEmpty {
            speechInput = recognizedText
        }

        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session properties weren't set because of an error.")
        }

        self.isListening = false
    }
}

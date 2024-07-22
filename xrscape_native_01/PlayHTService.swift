//import Foundation
//import AVFoundation
//
//class PlayHTService {
//    var audioPlayer: AVAudioPlayer?
//
//    func generateTTS(text: String) async {
//        print("text: \(text)")
//        let parameters = [
//            "text": text,
//            "voice": "s3://voice-cloning-zero-shot/d9ff78ba-d016-47f6-b0ef-dd630f59414e/female-cs/manifest.json",
//            "quality": "draft",
//            "output_format": "mp3",
//            "speed": 0.8,
//            "sample_rate": 24000,
//            "seed": nil,
//            "temperature": nil,
//            "voice_engine": "PlayHT2.0-turbo",
//            "emotion": "female_happy",
//            "voice_guidance": 3,
//            "style_guidance": 20,
//            "text_guidance": 1
//        ] as [String : Any?]
//
//        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
//            print("Failed to serialize JSON")
//            return
//        }
//
//        guard let url = URL(string: "https://api.play.ht/api/v2/tts/stream") else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.timeoutInterval = 30
//        request.allHTTPHeaderFields = [
//            "accept": "audio/mpeg",
//            "content-type": "application/json",
//            "AUTHORIZATION": Secrets.AUTHORIZATION,
//            "X-USER-ID": Secrets.X_USER_ID
//        ]
//        request.httpBody = postData
//
//        do {
//            let (data, _) = try await URLSession.shared.data(for: request)
//            playAudio(data: data)
//        } catch {
//            print("Error generating TTS: \(error)")
//        }
//    }
//
//    func playAudio(data: Data) {
//        do {
//            audioPlayer = try AVAudioPlayer(data: data)
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.play()
//        } catch {
//            print("Error playing audio: \(error)")
//        }
//    }
//}


import Foundation
import AVFoundation
import RealityKit

class PlayHTService {
    var audioPlayerNode: AVAudioPlayerNode?
    var audioEngine: AVAudioEngine?
    var audioFormat: AVAudioFormat?

    func generateTTS(text: String) async {
        print("text: \(text)")
        let parameters = [
            "text": text,
            "voice": "s3://voice-cloning-zero-shot/d9ff78ba-d016-47f6-b0ef-dd630f59414e/female-cs/manifest.json",
            "quality": "draft",
            "output_format": "mp3",
            "speed": 0.8,
            "sample_rate": 24000,
            "seed": nil,
            "temperature": nil,
            "voice_engine": "PlayHT2.0-turbo",
            "emotion": "female_happy",
            "voice_guidance": 3,
            "style_guidance": 20,
            "text_guidance": 1
        ] as [String : Any?]

        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Failed to serialize JSON")
            return
        }

        guard let url = URL(string: "https://api.play.ht/api/v2/tts/stream") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.allHTTPHeaderFields = [
            "accept": "audio/mpeg",
            "content-type": "application/json",
            "AUTHORIZATION": Secrets.AUTHORIZATION,
            "X-USER-ID": Secrets.X_USER_ID
        ]
        request.httpBody = postData

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            playAudio(data: data)
        } catch {
            print("Error generating TTS: \(error)")
        }
    }

    func playAudio(data: Data) {
        do {
            audioEngine = AVAudioEngine()
            audioPlayerNode = AVAudioPlayerNode()
            audioFormat = AVAudioFormat(standardFormatWithSampleRate: 24000, channels: 2)
            
            audioEngine?.attach(audioPlayerNode!)
            audioEngine?.connect(audioPlayerNode!, to: audioEngine!.mainMixerNode, format: audioFormat)
            
            if let audioFileURL = URL(dataRepresentation: data, relativeTo: nil) {
                let audioFile = try AVAudioFile(forReading: audioFileURL)
                audioPlayerNode?.scheduleFile(audioFile, at: nil, completionHandler: nil)
            } else {
                print("Failed to create URL from data")
                return
            }
            
            try audioEngine?.start()
            audioPlayerNode?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }
}

import AVFoundation

class SoundPlayer {
    static var shared = SoundPlayer()
    
    func playSystemSound(id: SystemSoundID) {
        AudioServicesPlaySystemSound(id)
    }
}

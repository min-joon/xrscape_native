import Foundation
import AVFoundation
import SwiftUI
import RealityKit

struct ControlPanel: View {
    @EnvironmentObject var appModel: AppModel
    @Binding var isWindowVisible: Bool
    
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    let imageDiameter: CGFloat = 100
    let imageSpacing: CGFloat = 40
    
    var body: some View {
        GeometryReader { geometry in
            if isWindowVisible { // 조건부 뷰 추가
                VStack {
                    HStack (spacing: imageSpacing) {
                        ScenaryButton(identifier: "yosemite", title: "Yosemite", imageDiameter: imageDiameter, isHidden: false)
                        ScenaryButton(identifier: "liberty_island", title: "Liberty Island", imageDiameter: imageDiameter, isHidden: true)
                        ScenaryButton(identifier: "oshima_bridge", title: "Oshima Bridge", imageDiameter: imageDiameter, isHidden: true)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 1/5)
                    .offset(y: geometry.size.height * 1/5)
                }
                HStack (spacing: imageSpacing) {
                    ScenaryButton(identifier: "santa_monica_pier", title: "Santa Monica Pier", imageDiameter: imageDiameter, isHidden: true)
                    ScenaryButton(identifier: "ulleng", title: "Ullengdo", imageDiameter: imageDiameter, isHidden: true)
                    ScenaryButton(identifier: "lake_martin", title: "Lake Martin", imageDiameter: imageDiameter, isHidden: true)
                    ScenaryButton(identifier: "yeosoo", title: "Yeosoo", imageDiameter: imageDiameter, isHidden: true)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 1/5)
                .offset(y: geometry.size.height * 2/5)
                HStack (spacing: imageSpacing) {
                    ScenaryButton(identifier: "diamond", title: "Lewis", imageDiameter: imageDiameter, isHidden: true)
                    ScenaryButton(identifier: "han_river", title: "Han River", imageDiameter: imageDiameter, isHidden: true)
                    ScenaryButton(identifier: "matsumoto_castle", title: "Coming soon", imageDiameter: imageDiameter, isHidden: false)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 1/5)
                .offset(y: geometry.size.height * 3/5)
            }
        }
        .persistentSystemOverlays(.hidden)
        .animation(.snappy, value: isWindowVisible)
        .onChange(of: isWindowVisible) { newValue in
            if newValue {
                SoundPlayer.shared.playSystemSound(id: 1397) // unlock sound
                print("SoundPlayer unlocked")
            } else {
                SoundPlayer.shared.playSystemSound(id: 1396) // lock sound
                print("SoundPlayer locked")
            }
        }
    }
}

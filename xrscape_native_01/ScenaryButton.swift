import SwiftUI
import RealityKit
import AVFoundation

struct ScenaryButton: View {
    var identifier: String
    var title: String
    var imageDiameter: CGFloat
    var isHidden: Bool

    @EnvironmentObject private var appModel: AppModel
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Button(action: {
                appModel.nextIdentifier = identifier
                Task { @MainActor in
                    if !isHidden {
                        if appModel.currentIdentifier == appModel.nextIdentifier {
                            SoundPlayer.shared.playSystemSound(id: 1396) // unlock sound
                        }
                        await dismissImmersiveSpace()
                    }
                    if appModel.currentIdentifier != appModel.nextIdentifier && !isHidden {
                        appModel.isWindowVisible.toggle()
                        await openImmersiveSpace(id: appModel.immersiveSpaceID)
                        appModel.currentIdentifier = appModel.nextIdentifier
                    } else {
                        appModel.currentIdentifier = ""
                    }
                }
            }) {
                Image(identifier)
                    .resizable()
                    .frame(alignment: .center)
                    .scaledToFill()
                    .frame(width: imageDiameter * 1.8, height: imageDiameter)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Text(title)
                .font(.subheadline)
        }
        .buttonStyle(ScenaryButtonStyle(isHidden: isHidden))
    }
    
    struct ScenaryButtonStyle: ButtonStyle {
        var isHidden: Bool
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(.thinMaterial)
                .clipShape(.capsule)
                .glassBackgroundEffect(in: .capsule)
                .hoverEffect { effect, isActive, proxy in
                    effect
                        .clipShape(.capsule.size(
                            width: isActive ? proxy.size.width : proxy.size.height,
                            height: proxy.size.height,
                            anchor: .center
                        )
                        )
                        .scaleEffect(isActive ? 1.1 : 1.0)
                }
                .opacity(isHidden ? 0.4 : 1)
        }
    }
}

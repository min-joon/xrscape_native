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
                appModel.currentIdentifier = identifier
                Task { @MainActor in
                    if isHidden {      } else { appModel.isWindowVisible.toggle() }
                    switch appModel.immersiveSpaceState {
                        case .open:
//                            appModel.immersiveSpaceState = .closed
//                            await dismissImmersiveSpace()
//                            // Don't set immersiveSpaceState to .closed because there
//                            // are multiple paths to ImmersiveView.onDisappear().
//                            // Only set .closed in ImmersiveView.onDisappear().
                            print("opened")
                        case .closed:
                            appModel.immersiveSpaceState = .open
                            switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
                                case .opened:
                                    // Don't set immersiveSpaceState to .open because there
                                    // may be multiple paths to ImmersiveView.onAppear().
                                    // Only set .open in ImmersiveView.onAppear().
                                    break

                                case .userCancelled, .error:
                                    // On error, we need to mark the immersive space
                                    // as closed because it failed to open. 
                                    fallthrough
                                @unknown default:
                                    // On unknown response, assume space did not open.
                                    appModel.immersiveSpaceState = .closed
                            }
                    case .inTransition:
                        print("inTransition")
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

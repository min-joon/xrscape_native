import SwiftUI
import RealityKit
import RealityKitContent

@MainActor
struct ImmersiveView: View {
    @EnvironmentObject var appModel: AppModel
    @State private var tapCount = 0
    @State var immersiveContentEntity = Entity()
    @State private var contentEntity = Entity()
    @State var spatialTapGestureListener = ModelEntity()
    @State private var lastTapTime: Date?

    func setupContentEntity() -> Entity {
        return contentEntity
    }
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            content.add(setupContentEntity())
            if let immersiveContentEntity = try? await Entity(named: "Scenes/\(appModel.nextIdentifier)", in: realityKitContentBundle) {
                if let spatialTapGestureListener = immersiveContentEntity.findEntity(named: "GestureListener") as? ModelEntity {
                    spatialTapGestureListener.components.set(HoverEffectComponent())
                    spatialTapGestureListener.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                    spatialTapGestureListener.components.set(CollisionComponent(shapes: [.generateBox(size: [10000, 10000, 10000])]))
                }
                contentEntity.removeChild(appModel.currentEntity)
                contentEntity.addChild(immersiveContentEntity)
                appModel.currentEntity = immersiveContentEntity
                appModel.currentIdentifier = appModel.nextIdentifier
            }
//                // Put skybox here.  See example in World project available at
//                // https://developer.apple.com/
        }
        .onAppear {
            print("appear")
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    if let lastTapTime = lastTapTime {
                        let timeInterval = Date().timeIntervalSince(lastTapTime)
                        if timeInterval < 0.5 { // 0.5초 이내의 연속된 탭을 더블 탭으로 인식
                            if appModel.immersiveSpaceState == .closed {
                                appModel.immersiveSpaceState = .open
                            } else {
                                appModel.immersiveSpaceState = .closed
                            }
                            appModel.isWindowVisible.toggle()
                        }
                    }
                    lastTapTime = Date()
                }
        )
    }
}

//
//import SwiftUI
//import RealityKit
//import RealityKitContent
//import AVFoundation
//
//@MainActor
//struct ImmersiveView: View {
//    @EnvironmentObject var appModel: AppModel
//    @State private var tapCount = 0
//    @State var immersiveContentEntity = Entity()
//    @State private var contentEntity = Entity()
//    @State var spatialTapGestureListener = ModelEntity()
//    @State private var lastTapTime: Date?
//
//    let playHTService = PlayHTService()
//    
//    func setupContentEntity() -> Entity {
//        return contentEntity
//    }
//    
//    var body: some View {
//        RealityView { content in
//            // Add the initial RealityKit content
//            content.add(setupContentEntity())
//            if let immersiveContentEntity = try? await Entity(named: "Scenes/\(appModel.nextIdentifier)", in: realityKitContentBundle) {
//                if let spatialTapGestureListener = immersiveContentEntity.findEntity(named: "GestureListener") as? ModelEntity {
//                    spatialTapGestureListener.components.set(HoverEffectComponent())
//                    spatialTapGestureListener.components.set(InputTargetComponent(allowedInputTypes: .indirect))
//                    spatialTapGestureListener.components.set(CollisionComponent(shapes: [.generateBox(size: [10000, 10000, 10000])]))
//                }
//                contentEntity.removeChild(appModel.currentEntity)
//                contentEntity.addChild(immersiveContentEntity)
//                appModel.currentEntity = immersiveContentEntity
//                appModel.currentIdentifier = appModel.nextIdentifier
//                
//                // Adding spatial audio component
//                if let audioPlayerNode = playHTService.audioPlayerNode {
//                    let audioComponent = AudioComponent()
//                    immersiveContentEntity.components.set(audioComponent)
//                    immersiveContentEntity.addAudioChild(audioPlayerNode)
//                }
//            }
////                // Put skybox here.  See example in World project available at
////                // https://developer.apple.com/
//        }
//        .onAppear {
//            print("appear")
//        }
//        .gesture(
//            SpatialTapGesture()
//                .targetedToAnyEntity()
//                .onEnded { value in
//                    if let lastTapTime = lastTapTime {
//                        let timeInterval = Date().timeIntervalSince(lastTapTime)
//                        if timeInterval < 0.5 { // 0.5초 이내의 연속된 탭을 더블 탭으로 인식
//                            if appModel.immersiveSpaceState == .closed {
//                                appModel.immersiveSpaceState = .open
//                            } else {
//                                appModel.immersiveSpaceState = .closed
//                            }
//                            appModel.isWindowVisible.toggle()
//                        }
//                    }
//                    lastTapTime = Date()
//                }
//        )
//    }
//}

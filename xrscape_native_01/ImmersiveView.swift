import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @EnvironmentObject var appModel: AppModel
    @State private var tapCount = 0
    @State var immersiveContentEntity = Entity()
    @State private var contentEntity = Entity()
    @State var cube1 = ModelEntity()
    @State var sphere = ModelEntity()
    @State private var lastTapTime: Date?

    func setupContentEntity() -> Entity {
        return contentEntity
    }
    
    func addCube(name: String, posision: SIMD3<Float>, color: UIColor) -> ModelEntity {
        let entity = ModelEntity(
            mesh: .generateBox(size: 0.5, cornerRadius: 0),
            materials: [SimpleMaterial(color: color, isMetallic: false)],
            collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0.5)),
            mass: 0.0
        )

        entity.name = name
        entity.position = posision
        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        entity.components.set(CollisionComponent(shapes: [ShapeResource.generateBox(size: SIMD3<Float>(repeating: 0.5))], isStatic: true))
        entity.components.set(HoverEffectComponent())

        contentEntity.addChild(entity)
        
        return entity
    }

    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            content.add(setupContentEntity())
            
            if let immersiveContentEntity = try? await Entity(named: "Scenes/\(appModel.currentIdentifier)", in: realityKitContentBundle) {
                
                if let sphere = immersiveContentEntity.findEntity(named: "Sphere") as? ModelEntity {
                    sphere.components.set(HoverEffectComponent())
                    sphere.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                    sphere.components.set(CollisionComponent(shapes: [.generateBox(size: [10000, 10000, 10000])]))
                }
                contentEntity.addChild(immersiveContentEntity)
            }   
//
//                // Put skybox here.  See example in World project available at
//                // https://developer.apple.com/
//            }
        }
        .onAppear {
            print("appear")
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
//                .targetedToEntity(scene004)
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

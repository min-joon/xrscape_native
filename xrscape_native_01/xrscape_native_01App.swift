import SwiftUI

@main
struct xrscape_native_01App: App {
    
    @State private var appModel = AppModel()
    @State var immersionAmount: Double?
    @State private var immersionStyle: ImmersionStyle = .progressive(0...1.0, initialAmount: 1.0)
    
    var body: some Scene {
        WindowGroup {
            ControlPanel(isWindowVisible: $appModel.isWindowVisible)
//                .persistentSystemOverlays(.hidden)
                .environmentObject(appModel)
        }
        .windowStyle(.plain)
        
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environmentObject(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
                .onImmersionChange { context in
                    immersionAmount = context.amount
                }
        }
        .immersionStyle(selection: $immersionStyle, in: .mixed, .progressive, .full)
//        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}

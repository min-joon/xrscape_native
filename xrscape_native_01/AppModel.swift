import SwiftUI

/// Maintains app-wide state
@MainActor
class AppModel: ObservableObject {
    static let shared = AppModel()
    
    let immersiveSpaceID = "ImmersiveSpace"
    
    enum ImmersiveSpaceState {
        case closed
        case open
        case inTransition
    }
    
    @Published var isWindowVisible: Bool = true
    @Published var immersiveSpaceState: ImmersiveSpaceState = .closed
    @Published var currentIdentifier: String = ""

    public init() {}
}

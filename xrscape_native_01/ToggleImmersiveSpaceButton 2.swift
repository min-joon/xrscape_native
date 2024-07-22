////
////  ToggleImmersiveSpaceButton.swift
////  MeditationPoC_03
////
////  Created by DUG on 6/21/24.
////
//
//import SwiftUI
//
//struct ToggleImmersiveSpaceButton2: View {
//
//    @EnvironmentObject var appModel: AppModel
//
//    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
//    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
//
//    var body: some View {
//        Button {
//            Task { @MainActor in
//                switch appModel.immersiveSpaceState {
//                    case .open:
//                        appModel.immersiveSpaceState = .open
//                        await dismissImmersiveSpace()
//                        // Don't set immersiveSpaceState to .closed because there
//                        // are multiple paths to ImmersiveView.onDisappear().
//                        // Only set .closed in ImmersiveView.onDisappear().
//
//                    case .closed:
//                        appModel.immersiveSpaceState = .closed
//                        switch await openImmersiveSpace(id: appModel.immersiveSpaceID) {
//                            case .opened:
//                                // Don't set immersiveSpaceState to .open because there
//                                // may be multiple paths to ImmersiveView.onAppear().
//                                // Only set .open in ImmersiveView.onAppear().
//                                break
//
//                            case .userCancelled, .error:
//                                // On error, we need to mark the immersive space
//                                // as closed because it failed to open.
//                                fallthrough
//                            @unknown default:
//                                // On unknown response, assume space did not open.
//                                appModel.immersiveSpaceState = .closed
//                        }
//                }
//            }
//        } label: {
//            Text(appModel.immersiveSpaceState == .open ? "Hide Immersive Space" : "Show Immersive Space")
//        }
//        .animation(.none, value: 0)
//        .fontWeight(.semibold)
//    }
//}

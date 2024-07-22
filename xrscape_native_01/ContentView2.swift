import SwiftUI

struct ContentView: View {
    @State private var immersionAmount: Double = 0.0
    @State private var immersionStyle: ImmersionStyle = .progressive(0...1.0, initialAmount: 1.0)

    var body: some View {
        VStack {
            Text("Immersion Amount: \(immersionAmount)")
            // 슬라이더 또는 다른 UI 요소를 통해 immersionAmount 조정
            Slider(value: $immersionAmount, in: 0...1.0)
        }
        .onAppear {
            self.immersionStyle = .progressive(self.immersionAmount...1.0, initialAmount: self.immersionAmount)
        }
        .onChange(of: immersionAmount) { newValue in
            self.immersionStyle = .progressive(newValue...1.0, initialAmount: newValue)
        }
    }
}

enum ImmersionStyle {
    case progressive(ClosedRange<Double>, initialAmount: Double)
}

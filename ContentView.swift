import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 0.025, green: 0.045, blue: 0.09).ignoresSafeArea()
            VStack(spacing: 18) {
                Text("SMARK")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                Text("AUTO DROP KEYBOARD")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(Color.cyan)
                Image(systemName: "keyboard")
                    .font(.system(size: 54))
                    .foregroundStyle(Color.blue)
                    .padding(.top, 18)
                Text("Enable SMARK Keyboard")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                Text("Open Settings → General → Keyboard → Keyboards → Add New Keyboard, then select SMARK. In a text field, hold the globe key to switch to SMARK.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.78))
                    .padding(.horizontal, 26)
                Text("Drag the blue circle on the keyboard. When you tap a key, it drops onto that key with an animation.")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(.horizontal, 26)
            }
            .padding()
        }
        .preferredColorScheme(.dark)
    }
}

import SwiftUI

/// Ana CTA butonu — gradient arka plan, haptic feedback, premium his.
struct NuvyraPrimaryButton: View {
    
    let title: String
    let icon: String?
    let isLoading: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button {
            NuvyraHaptics.medium()
            action()
        } label: {
            HStack(spacing: NuvyraSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.9)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    
                    Text(title)
                        .font(NuvyraTypography.button)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: NuvyraSpacing.buttonRadius, style: .continuous)
                    .fill(NuvyraColors.primaryGradient)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(NuvyraMotion.springQuick, value: isPressed)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .opacity(isLoading ? 0.8 : 1.0)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .accessibilityAddTraits(.isButton)
    }
}

/// İkincil buton — outline/ghost style, hafif dokunuş.
struct NuvyraSecondaryButton: View {
    
    let title: String
    let icon: String?
    let action: () -> Void
    
    @State private var isPressed = false
    
    init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button {
            NuvyraHaptics.light()
            action()
        } label: {
            HStack(spacing: NuvyraSpacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .medium))
                }
                
                Text(title)
                    .font(NuvyraTypography.buttonSmall)
            }
            .foregroundStyle(NuvyraColors.primaryAdaptive)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: NuvyraSpacing.buttonRadius, style: .continuous)
                    .stroke(NuvyraColors.primaryAdaptive.opacity(0.3), lineWidth: 1.5)
                    .fill(NuvyraColors.primaryAdaptive.opacity(0.06))
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(NuvyraMotion.springQuick, value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
        .accessibilityAddTraits(.isButton)
    }
}

#Preview("Buttons") {
    VStack(spacing: 16) {
        NuvyraPrimaryButton("Devam Et", icon: "arrow.right") {
            print("Primary tapped")
        }
        
        NuvyraPrimaryButton("Kaydediliyor...", isLoading: true) {}
        
        NuvyraSecondaryButton("Atla", icon: "arrow.right.circle") {
            print("Secondary tapped")
        }
    }
    .padding()
    .background(NuvyraColors.background)
}

import SwiftUI

/// Seçilebilir chip — hedef seçimi, Türk yemek hızlı seçimi, filtre gibi.
struct NuvyraChip: View {
    
    let title: String
    let icon: String?
    let isSelected: Bool
    let action: () -> Void
    
    init(
        _ title: String,
        icon: String? = nil,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button {
            NuvyraHaptics.selection()
            action()
        } label: {
            HStack(spacing: NuvyraSpacing.xxs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .medium))
                }
                
                Text(title)
                    .font(NuvyraTypography.buttonSmall)
            }
            .foregroundStyle(isSelected ? .white : NuvyraColors.textPrimary)
            .padding(.horizontal, NuvyraSpacing.md)
            .padding(.vertical, NuvyraSpacing.xs + 2)
            .background {
                if isSelected {
                    Capsule(style: .continuous)
                        .fill(NuvyraColors.primaryAdaptive)
                } else {
                    Capsule(style: .continuous)
                        .fill(NuvyraColors.cardBackground)
                        .overlay {
                            Capsule(style: .continuous)
                                .stroke(NuvyraColors.textTertiary.opacity(0.3), lineWidth: 1)
                        }
                }
            }
            .shadow(color: isSelected ? NuvyraColors.primaryAdaptive.opacity(0.2) : .clear, radius: 4, y: 2)
        }
        .buttonStyle(.plain)
        .animation(NuvyraMotion.springQuick, value: isSelected)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

#Preview("Chips") {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 8) {
            NuvyraChip("Kilo vermek", icon: "scalemass", isSelected: true) {}
            NuvyraChip("Daha çok yürümek", icon: "figure.walk", isSelected: false) {}
            NuvyraChip("Düzenli beslenmek", icon: "leaf", isSelected: true) {}
            NuvyraChip("Kilomu korumak", isSelected: false) {}
        }
        .padding()
    }
    .background(NuvyraColors.background)
}

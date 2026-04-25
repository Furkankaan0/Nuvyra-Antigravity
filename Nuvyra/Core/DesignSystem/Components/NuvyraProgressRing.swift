import SwiftUI

/// Dairesel progress ring — kalori veya adım hedefi görselleştirmesi.
/// Animasyonlu dolma, reduced motion desteği, büyük merkez rakamı.
struct NuvyraProgressRing: View {
    
    let progress: Double // 0.0 - 1.0
    let lineWidth: CGFloat
    let size: CGFloat
    let gradientColors: [Color]
    let label: String?
    let value: String?
    let unit: String?
    
    @State private var animatedProgress: Double = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    init(
        progress: Double,
        lineWidth: CGFloat = NuvyraSpacing.progressRingLineWidth,
        size: CGFloat = 180,
        gradientColors: [Color] = [NuvyraColors.primaryAdaptive, NuvyraColors.secondaryAdaptive],
        label: String? = nil,
        value: String? = nil,
        unit: String? = nil
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.size = size
        self.gradientColors = gradientColors
        self.label = label
        self.value = value
        self.unit = unit
    }
    
    var body: some View {
        ZStack {
            // Background track
            Circle()
                .stroke(
                    NuvyraColors.textTertiary.opacity(0.15),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
            
            // Progress arc
            Circle()
                .trim(from: 0, to: min(animatedProgress, 1.0))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: gradientColors),
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            // Center content
            VStack(spacing: NuvyraSpacing.xxxs) {
                if let value {
                    Text(value)
                        .font(NuvyraTypography.metricMedium)
                        .foregroundStyle(NuvyraColors.textPrimary)
                        .contentTransition(.numericText())
                }
                
                if let unit {
                    Text(unit)
                        .font(NuvyraTypography.caption)
                        .foregroundStyle(NuvyraColors.textSecondary)
                }
                
                if let label {
                    Text(label)
                        .font(NuvyraTypography.caption2)
                        .foregroundStyle(NuvyraColors.textTertiary)
                }
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(
                reduceMotion
                    ? .easeInOut(duration: 0.2)
                    : .easeInOut(duration: 1.2).delay(0.2)
            ) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(NuvyraMotion.easeSlow) {
                animatedProgress = newValue
            }
        }
    }
}

#Preview("Progress Ring") {
    VStack(spacing: 32) {
        NuvyraProgressRing(
            progress: 0.72,
            value: "1.512",
            unit: "kcal",
            label: "alındı"
        )
        
        NuvyraProgressRing(
            progress: 0.45,
            size: 120,
            gradientColors: [NuvyraColors.water, .cyan],
            value: "1.5",
            unit: "L"
        )
    }
    .padding()
    .background(NuvyraColors.background)
}

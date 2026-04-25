import SwiftUI
import StoreKit

/// Paywall ekranı — şeffaf fiyatlandırma, net deneme/iptal bilgisi
struct PaywallView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var storeService = StoreKitService()
    @State private var selectedProduct: Product?
    @State private var isPurchasing = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: NuvyraSpacing.xl) {
                    // Header
                    VStack(spacing: NuvyraSpacing.sm) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 40))
                            .foregroundStyle(NuvyraColors.primaryAdaptive)
                        
                        Text("Nuvyra Premium")
                            .font(NuvyraTypography.onboardingTitle)
                            .foregroundStyle(NuvyraColors.textPrimary)
                        
                        Text("Günlük ritim koçunu tam kapasite kullan.")
                            .font(NuvyraTypography.onboardingSubtitle)
                            .foregroundStyle(NuvyraColors.textSecondary)
                    }
                    
                    // Features
                    VStack(spacing: NuvyraSpacing.sm) {
                        ForEach(PaywallFeature.premiumFeatures) { feature in
                            featureRow(feature)
                        }
                    }
                    
                    // Products
                    if storeService.products.isEmpty {
                        ProgressView("Fiyatlar yükleniyor...")
                    } else {
                        VStack(spacing: NuvyraSpacing.sm) {
                            ForEach(storeService.products, id: \.id) { product in
                                productCard(product)
                            }
                        }
                    }
                    
                    // Purchase button
                    if let selectedProduct {
                        NuvyraPrimaryButton("Abone Ol", isLoading: isPurchasing) {
                            purchase(selectedProduct)
                        }
                    }
                    
                    // Restore
                    Button("Satın Alımları Geri Yükle") {
                        Task { await storeService.restorePurchases() }
                    }
                    .font(NuvyraTypography.buttonSmall)
                    .foregroundStyle(NuvyraColors.textSecondary)
                    
                    // Legal
                    VStack(spacing: NuvyraSpacing.xxxs) {
                        Text("Abonelik Apple ID hesabınız üzerinden faturalandırılır.")
                        Text("İstediğiniz zaman Ayarlar > Abonelikler'den iptal edebilirsiniz.")
                        HStack(spacing: NuvyraSpacing.md) {
                            Link("Gizlilik Politikası", destination: URL(string: "https://nuvyra.com/privacy")!)
                            Link("Kullanım Koşulları", destination: URL(string: "https://nuvyra.com/terms")!)
                        }
                    }
                    .font(NuvyraTypography.caption)
                    .foregroundStyle(NuvyraColors.textTertiary)
                    .multilineTextAlignment(.center)
                    
                    Spacer(minLength: NuvyraSpacing.lg)
                }
                .padding(.horizontal, NuvyraSpacing.pageHorizontal)
                .padding(.top, NuvyraSpacing.xl)
            }
            .background(NuvyraColors.background.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(NuvyraColors.textTertiary)
                    }
                }
            }
            .task { await storeService.loadProducts() }
        }
    }
    
    private func featureRow(_ feature: PaywallFeature) -> some View {
        HStack(spacing: NuvyraSpacing.sm) {
            Image(systemName: feature.icon)
                .font(.system(size: 18))
                .foregroundStyle(NuvyraColors.primaryAdaptive)
                .frame(width: 36, height: 36)
                .background(NuvyraColors.primaryAdaptive.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(feature.title).font(NuvyraTypography.bodyBold).foregroundStyle(NuvyraColors.textPrimary)
                Text(feature.description).font(NuvyraTypography.caption).foregroundStyle(NuvyraColors.textSecondary)
            }
            Spacer()
        }
    }
    
    private func productCard(_ product: Product) -> some View {
        Button {
            NuvyraHaptics.selection()
            selectedProduct = product
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.displayName).font(NuvyraTypography.bodyBold).foregroundStyle(NuvyraColors.textPrimary)
                    Text(product.description).font(NuvyraTypography.caption).foregroundStyle(NuvyraColors.textSecondary)
                }
                Spacer()
                Text(product.displayPrice).font(NuvyraTypography.metricCard).foregroundStyle(NuvyraColors.primaryAdaptive)
            }
            .padding(NuvyraSpacing.md)
            .background(NuvyraColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: NuvyraSpacing.chipRadius, style: .continuous))
            .overlay {
                if selectedProduct?.id == product.id {
                    RoundedRectangle(cornerRadius: NuvyraSpacing.chipRadius, style: .continuous)
                        .stroke(NuvyraColors.primaryAdaptive, lineWidth: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private func purchase(_ product: Product) {
        isPurchasing = true
        Task {
            let _ = try? await storeService.purchase(product)
            isPurchasing = false
            dismiss()
        }
    }
}

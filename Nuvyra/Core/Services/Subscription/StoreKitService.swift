import Foundation
import StoreKit

/// StoreKit 2 abonelik yönetim servisi
@Observable
final class StoreKitService {
    
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isLoading: Bool = false
    
    private let productIDs: Set<String> = [
        "com.nuvyra.premium.monthly",
        "com.nuvyra.premium.yearly",
        "com.nuvyra.plus.monthly",
        "com.nuvyra.plus.yearly"
    ]
    
    private var transactionListener: Task<Void, Error>?
    
    init() {
        transactionListener = listenForTransactions()
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    // MARK: - Products
    
    @MainActor
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            products = try await Product.products(for: productIDs)
                .sorted { $0.price < $1.price }
        } catch {
            print("Ürün yükleme hatası: \(error)")
        }
    }
    
    // MARK: - Purchase
    
    @MainActor
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await refreshEntitlements()
            return transaction
            
        case .userCancelled:
            return nil
            
        case .pending:
            return nil
            
        @unknown default:
            return nil
        }
    }
    
    // MARK: - Restore
    
    @MainActor
    func restorePurchases() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }
    
    // MARK: - Entitlements
    
    @MainActor
    func refreshEntitlements() async {
        var purchased: Set<String> = []
        
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                purchased.insert(transaction.productID)
            }
        }
        
        purchasedProductIDs = purchased
    }
    
    // MARK: - Private
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified: throw StoreError.failedVerification
        case .verified(let safe): return safe
        }
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached {
            for await result in Transaction.updates {
                if let transaction = try? self.checkVerified(result) {
                    await transaction.finish()
                    await self.refreshEntitlements()
                }
            }
        }
    }
    
    enum StoreError: Error {
        case failedVerification
    }
}

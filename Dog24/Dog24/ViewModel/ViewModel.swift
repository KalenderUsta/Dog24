//
//  ViewModel.swift
//  Dog24
//
//  Created by Kalender Usta on 06.09.24.
//

import Foundation
import Combine
import FirebaseAuth

@MainActor
class ViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var products: [Product] = []
    @Published var recommendedProducts: [Product] = []
    @Published var newArrivals: [Product] = []
    @Published var bestSellers: [Product] = []
    @Published var popularGifts: [Product] = []
    @Published var cartItems: [CartItem] = []
    @Published var isUserLoggedIn: Bool = false
    @Published var categorySpielzeuge: Category = .spielzeug
    @Published var categoryFutter: Category = .futter
    @Published var twoCategorys: [Category] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var favoriteProductIds: [Int] = []
    @Published var searchTerm: String = ""{
        didSet{
            Task{
                await searProductByName(title: searchTerm)
            }
        }
    }
    var selectedCategory: Category?
    
    private let firebaseService = FirebaseService()
    private let firestoreService = FirestoreService()
    
    private func fetchInitialData() async {
        checkIfUserIsLoggedIn()
        loadFavoriteProducts()
        await fetchToysProducts()
    }
    
    init(category: Category? = nil) {
        self.selectedCategory = category
        Task {
            await fetchInitialData()
        }
    }
    
    func searProductByName(title: String) async {
        do {
            self.products = try await ProductRepository.shared.fetchSreachProductByTitle(title: title)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Fehler beim Laden der Produkte: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    func fetchToysProducts() async {
        isLoading = true
        do {
            self.products =  try await ProductRepository.shared.fetchProducts()
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Fehler beim Laden der Produkte: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func fetchAllRecommended() async {
        isLoading = true
        do {
            self.recommendedProducts = try await ProductRepository.shared.fetchfilterRecommended()
        } catch {
            print("Fehler beim Laden der Empfehlungen: \(error.localizedDescription)")
            self.errorMessage = "Fehler beim Laden der Empfehlungen: \(error.localizedDescription)"
        }
    }
    
    func fetchAllNewArrivals() async {
        do{
            self.newArrivals = try await ProductRepository.shared.fetchfilterNewArrivals()
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Fehler beim Laden der Produkte: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func fetchAllBestSellers() async {
        do {
            self.bestSellers = try await ProductRepository.shared.fetchfilterBestSellers()
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Fehler beim Laden der Produkte: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func fetchAllPopularGifts() async {
        do {
            self.popularGifts = try await ProductRepository.shared.fetchfilterPopularGiftss()
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Fehler beim Laden der Produkte: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func buyProduct(_ product: Product, amount: Int) {
        guard amount > 0 && amount <= 3 else {
            print("Du kannst nur maximal 3 Stück eines Produkts kaufen.")
            return
        }
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            let actualAmount = min(amount, products[index].quantity)
            products[index].reduceQuantity(by: actualAmount)
        }
    }
    
    var cartItemCount: Int {
        return cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var total: Double {
        return cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    var discount: Double {
        return cartItems.count > 3 ? total * 0.1 : 0
    }
    
    var totalPriceAfterDiscount: Double {
        return total - discount
    }
    
    func addToCart(item: CartItem) {
        guard isUserLoggedIn, let userId = profile?.uid else {
            self.errorMessage = "Bitte melde dich an, um Artikel in den Warenkorb zu legen."
            return
        }
        
        Task {
            do {
                let currentCartItems = try await firestoreService.loadCartItems(for: userId)
                
                if let existingItemIndex = currentCartItems.firstIndex(where: { $0.product.id == item.product.id }) {
                    var existingItem = currentCartItems[existingItemIndex]
                    let newQuantity = min(existingItem.quantity + item.quantity, 3)
                    existingItem.quantity = newQuantity
                    
                    try await firestoreService.updateCartItem(cartItem: existingItem, uid: userId)
                } else {
                    let newItem = CartItem(product: item.product, quantity: min(item.quantity, 3))
                    try await firestoreService.addToShoppingCart(cartItem: newItem, uid: userId)
                }
                
                await loadCartItems(for: userId)
            } catch {
                self.errorMessage = "Fehler beim Hinzufügen des Artikels: \(error.localizedDescription)"
                print("Fehler: \(error)")
            }
        }
    }
    
    func clearShoppingCart() {
        guard isUserLoggedIn, let userId = profile?.uid else {
            self.errorMessage = "Bitte melde dich an, um den Warenkorb zu leeren."
            return
        }
        
        Task {
            do {
                try await firestoreService.removeAllFromShoppingCart(uid: userId)
                await loadCartItems(for: userId)
            } catch {
                self.errorMessage = "Fehler beim Leeren des Warenkorbs: \(error.localizedDescription)"
                print("Fehler: \(error)")
            }
        }
    }
    
    func removeFromCart(item: CartItem) {
        guard isUserLoggedIn, let userId = profile?.uid else {
            self.errorMessage = "Bitte melde dich an, um Artikel aus dem Warenkorb zu entfernen."
            return
        }
        
        Task {
            do {
                try await firestoreService.removeFromShoppingCart(cartItemId: item.product.id, uid: userId)
                await loadCartItems(for: userId)
            } catch {
                self.errorMessage = "Fehler beim Entfernen des Artikels: \(error.localizedDescription)"
            }
        }
    }
    
    func loadCartItems(for userId: String) async {
        do {
            cartItems = try await firestoreService.loadCartItems(for: userId)
        } catch {
            self.errorMessage = "Fehler beim Laden der Warenkorb-Artikel: \(error.localizedDescription)"
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if (Auth.auth().currentUser?.uid) != nil {
            self.profile = firebaseService.getCurrentUser() 
            isUserLoggedIn = true
        } else {
            isUserLoggedIn = false
        }
    }
    
    func signIn(email: String, password: String) async throws {
        let user = try await firebaseService.signIn(email: email, password: password)
        
        DispatchQueue.main.async {
            self.isUserLoggedIn = true
            self.profile = user
        }
    }
    
    func createUser(email: String, password: String, firstName: String, lastName: String) async throws {
        let profile = try await firebaseService.createUser(email: email, password: password)
        
        let updatedProfile = Profile(
            email: profile.email,
            name: "\(firstName) \(lastName)",
            imageUrl: profile.imageUrl,
            uid: profile.uid
        )
        
        try await firestoreService.createProfile(profile: updatedProfile)
        
        self.profile = updatedProfile
    }
    
    func signOut() async throws {
        try await firebaseService.signOut()

        self.profile = nil
        self.isUserLoggedIn = false
    }
    
    func loadProfile(userId: String) async throws {
        let profile = try await firestoreService.loadProfile(userId: userId)
        
        DispatchQueue.main.async {
            self.profile = profile
        }
    }
    
    func loadFavoriteProducts() {
        guard isUserLoggedIn, let userId = profile?.uid else {
            self.errorMessage = "Bitte melde dich an, um deine Favoriten zu laden."
            return
        }
        
        Task {
            do {
                let favoriteProductIds = try await firestoreService.loadFavoriteProducts(uid: userId)
                self.favoriteProductIds = favoriteProductIds
            } catch {
                self.errorMessage = "Fehler beim Laden der Favoriten: \(error.localizedDescription)"
            }
        }
    }
    
    func decreaseQuantityOrRemove(item: CartItem) {
        if item.quantity > 1 {
            if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
                cartItems[index].quantity -= 1
            }
        } else {
            removeFromCart(item: item)
        }
    }
}

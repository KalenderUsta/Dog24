//
//  FirestoreService.swift
//  Dog24
//
//  Created by Kalender Usta on 13.09.24.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    private let db = Firestore.firestore()
    
    func createProfile(profile: Profile) async throws {
        let profileData: [String: Any] = [
            "email": profile.email,
            "name": profile.name ?? "",
            "imageUrl": profile.imageUrl ?? "",
            "uid": profile.uid
        ]
        
        try await db.collection("profiles").document(profile.uid).setData(profileData)
    }
    
    func loadProfile(userId: String) async throws -> Profile? {
        let documentSnapshot = try await db.collection("profiles").document(userId).getDocument()
        
        guard documentSnapshot.exists else {
            print("Das Dokument existiert nicht.")
            return nil
        }
        
        return try documentSnapshot.data(as: Profile.self)
    }

    func addToShoppingCart(cartItem: CartItem, uid: String) async throws {
        let documentRef = db.collection("profiles").document(uid).collection("Shopping carts").document(String(cartItem.product.id))
        try documentRef.setData(from: cartItem)
    }
    
    func loadCartItems(for userId: String) async throws -> [CartItem] {
        let snapshot = try await db.collection("profiles").document(userId).collection("Shopping carts").getDocuments()
        return snapshot.documents.compactMap { document -> CartItem? in
            try? document.data(as: CartItem.self)
        }
    }
    
    func removeFromShoppingCart(cartItemId: Int, uid: String) async throws {
        let documentRef = db.collection("profiles").document(uid).collection("Shopping carts").document(String(cartItemId))
        try await documentRef.delete()
    }
    
    func removeAllFromShoppingCart(uid: String) async throws {
        let querySnapshot = try await db.collection("profiles").document(uid).collection("Shopping carts").getDocuments()
        let batch = db.batch()
        
        for document in querySnapshot.documents {
            batch.deleteDocument(document.reference)
        }
        
        try await batch.commit()
    }
    
    func updateCartItem(cartItem: CartItem, uid: String) async throws {
        let documentRef = db.collection("profiles").document(uid).collection("Shopping carts").document(String(cartItem.product.id))
        try documentRef.setData(from: cartItem)
    }
    
    func addFavorite(productId: Int, uid: String) async throws {
        let documentId = String(productId)
        let documentRef = db.collection("profiles").document(uid)
            .collection("favorites")
            .document(documentId)
        try await documentRef.setData(["isFavorited": true])
    }
    
    func removeFavorite(productId: Int, uid: String) async throws {
        let documentId = String(productId)
        let documentRef = db.collection("profiles").document(uid)
            .collection("favorites")
            .document(documentId)
        try await documentRef.delete()
    }
    
    func isProductFavorited(productId: Int, uid: String) async throws -> Bool {
        let documentId = String(productId)
        let documentRef = db.collection("profiles").document(uid)
            .collection("favorites")
            .document(documentId)
        let document = try await documentRef.getDocument()
        return document.exists && (document.data()?["isFavorited"] as? Bool ?? false)
    }
    
    func loadFavoriteProducts(uid: String) async throws -> [Int] {
        let snapshot = try await db.collection("profiles").document(uid)
            .collection("favorites").getDocuments()
        
        return snapshot.documents.compactMap { document in
            if let productId = Int(document.documentID) {
                return productId
            } else {
                return nil
            }
        }
    }
}


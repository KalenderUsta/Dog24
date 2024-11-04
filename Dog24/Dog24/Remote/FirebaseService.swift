//
//  FirebaseService.swift
//  Dog24
//
//  Created by Kalender Usta on 13.09.24.
//

import Foundation
import FirebaseAuth

class FirebaseService {
    private let firebaseAuth = Auth.auth()
    
    func createUser(email: String, password: String) async throws -> Profile {
        let authResult = try await firebaseAuth.createUser(withEmail: email, password: password)
        let user = authResult.user
        let appUser = Profile(email: user.email ?? "", uid: user.uid)
        return appUser
    }
    
    func signIn(email: String, password: String) async throws -> Profile {
            let result = try await firebaseAuth.signIn(withEmail: email, password: password)
            let user = result.user
            let profile = Profile(email: email, name: user.displayName ?? "Unknown", imageUrl: user.photoURL?.absoluteString, uid: user.uid)
            return profile
        }
    
    func signOut() async throws {
        do {
            try firebaseAuth.signOut()
        } catch {
            throw error
        }
    }
    
    func getCurrentUser() -> Profile? {
        if let user = firebaseAuth.currentUser {
            return Profile(email: user.email ?? "", uid: user.uid)
        }
        return nil
    }
}

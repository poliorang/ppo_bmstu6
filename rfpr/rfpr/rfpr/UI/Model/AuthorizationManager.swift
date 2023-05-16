//
//  AuthorizationManager.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

final class AuthorizationManager {    
    static let shared = AuthorizationManager()
    
    private init() { }
    
    private static var user: User?

    func setUser(_ user: User) {
        AuthorizationManager.user = user
    }
    
    func getUser() -> User? {
        return AuthorizationManager.user
    }
    
    func getRight() -> Bool {
        switch getUser()?.role {
            
        case .participant:
            return false
            
        case .referee:
            return true
        
        default:
            return false
        }
    }
}

//
//  UserModel.swift
//  rfpr
//
//  Created by poliorang on 14.05.2023.
//
    
struct User {
    var id: String?
    var role: Role
    var authorization: Authorization?
    
    func getRight() -> Bool {
        switch role {
            
        case .participant:
            return false
            
        case .referee:
            return true
        
        default:
            return false
        }
    }
}

//
//  AuthorizationModel.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

struct Authorization {
    var id: String?
    var login: String
    var password: String
}

extension Authorization: Equatable {
    static func == (lhs: Authorization, rhs: Authorization) -> Bool {
        if lhs.id == rhs.id &&
            lhs.password == rhs.password {
            return true
        }
        
        return false
    }
    
    static func != (lhs: Authorization, rhs: Authorization) -> Bool {
        return !(lhs == rhs)
    }
}

//
//  AutorizationModel.swift
//  rfpr
//
//  Created by poliorang on 28.03.2023.
//

class Autorization {
    var login: String
    var password: String
    
    init() {
        login = ""
        password = ""
    }
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
    
    func isParticipant(participant: Autorization, database: [Autorization]) -> Bool {
        if database.contains(participant) {
            return true
        }
        
        return false
    }
}

extension Autorization: Equatable {
    static func == (lhs: Autorization, rhs: Autorization) -> Bool {
        if lhs.login == rhs.login &&
            lhs.password == rhs.password  {
            return true
        }
        else {
            return false
        }
    }
    
    static func != (lhs: Autorization, rhs: Autorization) -> Bool {
        return !(lhs == rhs)
    }
}

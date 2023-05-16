//
//  UserExtencion.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

import RealmSwift

extension User {
    func convertUserToRealm(_ realm: Realm) throws -> UserRealm {
        // проверка, что уже есть в бд
        var userFromDB: UserRealm? = nil
        if let id = self.id {
            let objId = try ObjectId.init(string: id)
            userFromDB = realm.objects(UserRealm.self).where {
                $0._id == objId
            }.first
        }
        
        if let userFromDB = userFromDB {
            return userFromDB
        }
        
        do {
            return try UserRealm(id: self.id, role: self.role.rawValue, authorization: self.authorization?.convertAuthorizationToRealm(realm))
        } catch {
            throw DatabaseError.addError
        }
    }
}

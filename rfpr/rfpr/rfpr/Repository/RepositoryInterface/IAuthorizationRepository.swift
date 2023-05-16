//
//  IAuthorizationRepository.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

protocol IAuthorizationRepository {
    func createAuthorization(authorization: Authorization) throws -> Authorization?
    
    func updateAuthorization(previousAuthorization: Authorization, newAuthorization: Authorization) throws -> Authorization?
    func deleteAuthorization(authorization: Authorization) throws
    
    func getAuthorizationByLoginPassword(authorization: Authorization) throws -> Authorization?
    func getAuthorizations() throws -> [Authorization]?
}

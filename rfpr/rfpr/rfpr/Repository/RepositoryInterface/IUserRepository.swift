//
//  IUserRepository.swift
//  rfpr
//
//  Created by poliorang on 15.05.2023.
//

protocol IUserRepository {
    func createUser(user: User) throws -> User?
    
    func updateUser(previousUser: User, newUser: User) throws -> User?
    func deleteUser(user: User) throws
    
    func getUserByAuthorization(authorization: Authorization) throws -> User?
    func getUsers() throws -> [User]?
}

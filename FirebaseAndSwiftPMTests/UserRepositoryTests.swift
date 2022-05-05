//
//  UserRepositoryTests.swift
//  FirebaseAndSwiftPMTests
//
//  Created by Christopher Elbert on 5/5/22.
//

import XCTest
@testable import FirebaseAndSwiftPM

class UserRepositoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddUser() async {
        let userService = UserService(userRepository: MockUserRepository() as IUserRepository)
        let user = User(email: "celbert96@gmail.com", password: "password", photoURL: "http://localhost:8080", nickname: "Tito", isPremium: false)
        let result = await userService.addUser(user: user, photo: nil)
        
        if result != .success() {
            XCTFail("Result was not success")
            return
        }
        
        guard let newUser = result.get() as? User else {
            XCTFail("RepositoryResult enum had no User associated with it")
            return
        }
        
        XCTAssertTrue(newUser.uid == user.uid)
    }
    
    func testUpdateUser() async {
        let userService = UserService(userRepository: MockUserRepository() as IUserRepository)
        let user = User(email: "celbert96@gmail.com", password: "password", photoURL: "http://localhost:8080", nickname: "Tito", isPremium: false)
        let uid = "1a"
        let result = await userService.updateUser(uid: uid, user: user)
        
        if result != .success() {
            XCTFail("Result was not success")
            return
        }
        
        guard let newUser = result.get() as? User else {
            XCTFail("RepositoryResult enum had no User associated with it")
            return
        }
        
        XCTAssertTrue(newUser.uid == user.uid)
    }
    
    func testDeleteUser() async {
        let userService = UserService(userRepository: MockUserRepository() as IUserRepository)

        let uid = "1a"
        let result = await userService.deleteUser(uid: uid)
        
        if result != .success() {
            XCTFail("Result was not success")
            return
        }
        
        guard let newUser = result.get() as? User else {
            XCTFail("RepositoryResult enum had no User associated with it")
            return
        }
        
        XCTAssertTrue(newUser.uid == uid)
    }

}

class MockUserRepository: IUserRepository {
    func addUser(user: User, photo: UIImage?) async -> RepositoryResponse<User> {
        let newUser = User(email: user.email, password: user.password, photoURL: user.photoURL, nickname: user.nickname, isPremium: user.isPremium)
        
        return .success(newUser)
    }
    
    func updateUser(uid: String, user: User) async -> RepositoryResponse<User> {
        var oldUser = User(email: "celbert96@gmail.com", password: "password", photoURL: "http://localhost:8080", nickname: "Tito", isPremium: false)
        oldUser.uid = uid
        
        oldUser = user
        
        return .success(user)
    }
    
    func deleteUser(uid: String) async -> RepositoryResponse<User> {
        let oldUser = User(email: "celbert96@gmail.com", password: "password", photoURL: "http://localhost:8080", nickname: "Tito", isPremium: false)
        oldUser.uid = uid
        return .success(oldUser)
    }
}

//
//  CoreDataManager.swift
//  Baro_Task
//
//  Created by 전성규 on 3/16/25.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Baro_Task")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    // MARK: - 회원 저장
    func saveUser(id: String, password: String, nickname: String) -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            if !existingUsers.isEmpty { return false }  // 중복 아이디 존재
        } catch {
            print("Error checking exising error: \(error)")
            return false
        }
        
        let newUser = User(context: context)
        newUser.id = id
        newUser.password = password
        newUser.nickname = nickname
        
        do {
            try context.save()
            return true // 회원 가입 성공
        } catch {
            print("Failed to save user: \(error)")
            return false
        }
    }
    

    // MARK: - 회원 조회
    func fetchUser(id: String) -> User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let users = try context.fetch(fetchRequest)
            return users.first
        } catch {
            print("Failed to fetch user: \(error)")
            return nil
        }
    }

    // MARK: - 회원 삭제 (탈퇴)
    func deleteUser(id: String) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)

        do {
            let users = try context.fetch(fetchRequest)
            for user in users {
                context.delete(user)
            }
            try context.save()
        } catch {
            print("Failed to delete user: \(error)")
        }
    }

    // MARK: - 전체 회원 삭제 (테스트용)
    func deleteAllUsers() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to delete all users: \(error)")
        }
    }
}

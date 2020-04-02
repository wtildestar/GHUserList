//
//  CoreDataManager.swift
//  GHUserList
//
//  Created by wtildestar on 30/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GHUserListModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError( "Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchUsers() -> [User] {
        print("Trying to fetch users")
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
//        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        
        do {
            let users = try context.fetch(fetchRequest)
            return users
            
        } catch let fetchErr {
            print("Failed to fetch users:", fetchErr)
            return []
        }
    }
    
//    func createEmployee(employeeName: String, employeeType: String, birthday: Date, company: Company) -> (Employee?, Error?) {
//        print("create employee..")
//        let context = persistentContainer.viewContext
//
//        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
//        employee.company = company
//        employee.type = employeeType
//        employee.setValue(employeeName, forKey: "name")
//
//        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
//        employeeInformation.taxId = "456"
//        employeeInformation.birthday = birthday
////        employeeInformation.setValue("456", forKey: "taxId")
//        employee.employeeInformation = employeeInformation
//
//        do {
//            try context.save()
//            return (employee, nil)
//
//        } catch let err {
//            print("Failed to create employee", err)
//            return (nil, err)
//        }
//
//    }
}

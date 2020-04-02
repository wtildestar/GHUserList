//
//  NetworkService.swift
//  GHUserList
//
//  Created by wtildestar on 28/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit
import CoreData

protocol NetworkServiceProtocol {
    func getSearchUsers(url: String, completion: @escaping (([String: String]) -> Void))
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void)
    //    func getUsers(completion: @escaping (Result<[User]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    let cache = NSCache<NSString, UIImage>()
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
    
    func getSearchUsers(url: String, completion: @escaping (([String: String]) -> Void)) {
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Failed to download users:", error)
                return
            }
//            if error != nil {
//                completion(.failure(.invalidData))
//                return
//            }
            
            if response != nil {
                let httpResponse = response as! HTTPURLResponse
                let field = httpResponse.allHeaderFields["Link"] as? String
                guard let linkHeader = field else { return }
                let links = linkHeader.components(separatedBy: ",")
                
                var dictionary: [String: String] = [:]
                
                links.forEach({
                    let components = $0.components(separatedBy: "; ")
                    let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: "< >"))
                    dictionary[components[1]] = cleanPath
                })
                
                // print(dictionary)
                completion(dictionary)
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonUsers = try decoder.decode([JSONUser].self, from: data)
//                    completion(.success(jsonUsers))
//                    print(jsonUsers)
                    
                    let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                    privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                    
                    
                    jsonUsers.forEach { jsonUser in
//                        do {
//                            try privateContext.delete(user)
//                        }
                        
                        print(jsonUser.login)
                        let user = User(context: privateContext)
                        user.login = jsonUser.login
                        
//                        print(user) 
//                        user.imageData = jsonUser.avatarUrl

                        
//                        jsonUser.employees?.forEach({ (jsonEmployee) in
//                            print("  \(jsonEmployee.name)")
//                            let employee = Employee(context: privateContext)
//                            employee.name = jsonEmployee.name
//                            employee.type = jsonEmployee.type
//
//                            let employeeInformation = EmployeeInformation(context: privateContext)
//                            let birthdayDate = dateFormatter.date(from: jsonEmployee.birthday)
//                            employeeInformation.birthday = birthdayDate
//                            employee.employeeInformation = employeeInformation
//                            employee.company = user
//                        })
                        
                        do {
                            try privateContext.save()
                            try privateContext.parent?.save()
                            
                        } catch let saveErr {
                            print("Failed to save users:", saveErr)
                        }
                    }
                    
                } catch let jsonDecoderErr {
//                    completion(.failure(.invalidData))
                    print("Failed to decode:", jsonDecoderErr)
                }
            }
            
        }.resume()
    }
    //
    //    func getUsers(completion: @escaping (Result<[User]?, Error>) -> Void) {
    ////        let urlString = "https://api.github.com/search/users?q=page&s=updated"
    //        let urlString = "https://api.github.com/users?since=0"
    //        guard let url = URL(string: urlString) else { return }
    //
    //        URLSession.shared.dataTask(with: url) { data, _, error in
    //            if let error = error {
    //                completion(.failure(error))
    //                return
    //            }
    //
    //            do {
    //                let obj = try JSONDecoder().decode([User].self, from: data!)
    //                completion(.success(obj))
    //                print(obj)
    //            } catch {
    //                completion(.failure(error))
    //            }
    //        }.resume()
    //    }
}

////
////  DataStore.swift
////  GHUserList
////
////  Created by wtildestar on 08/04/2020.
////  Copyright © 2020 wtildestar. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//class DataStore: NSObject {
//
//    let persistence = PersistenceService.shared
//    let presenter: MainPresenter!
//
//    private override init() {
//        super.init()
//    }
//
//    static let shared = DataStore()
//
//    func request(completion: @escaping ([User]) -> Void) {
//
//        presenter.networkService.getSearchUsers(url: "https://api.github.com/users?since=0", completion: { result in
//            switch result {
//            case .success(let data):
//                do {
//                    guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: [])
//                        as? [[String: Any]] else { return }
//                    jsonArray.forEach { [weak self] in
//                        guard
//                            let strongSelf = self,
//                            let login = $0["login"] as? String,
//                            let avatarUrl = $0["avatar_url"] as? String
//                            else { return }
//
//                        let user = User(context: strongSelf.persistence.context)
//                        user.login = login
//                        user.avatarUrl = avatarUrl
//
//                    }
//                    DispatchQueue.main.async {
//                        self.persistence.save() {
//                            self.persistence.fetch(User.self) { objects in
//                                completion(objects)
//                            }
//                        }
//                    }
//                } catch {
//                    print(error)
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }) { headerLinks in
//            if let nextPagePath = headerLinks["rel=\"next\""] {
//                self.presenter.nextLink = nextPagePath
//            }
//
//            if let prevPage = headerLinks["rel=\"prev\""] {
//                self.presenter.prevLink = prevPage
//            }
//        }
//    }
//
//}

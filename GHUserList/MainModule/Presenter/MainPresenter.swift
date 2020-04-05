//
//  MainPresenter.swift
//  GHUserList
//
//  Created by wtildestar on 28/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit
import CoreData

protocol MainViewProtocol: class {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: Router)
    func getUsers()
    var user: User? { get set }
    var followers: [Follower]? { get }
    func tapOnTheUser(follower: Follower?)
    var userSearchUrl: String { get }
    var nextLink: String? { get }
    var prevLink: String? { get }
}

class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    var nextLink: String?
    var prevLink: String?
    var userSearchUrl: String = "https://api.github.com/users?since=0"
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    var users = [User]()
    var user: User?
    var followers: [Follower]?
    var mainViewCell: MainViewCell!
    private let persistence = PersistenceService.shared
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: Router) {
        self.view = view
        self.networkService = networkService
        self.router = router
//        getUsers()
    }
    
    func tapOnTheUser(follower: Follower?) {
        router?.showDetail(follower: follower)
    }
    
    func getUsers() {
        
        networkService.getSearchUsers(url: userSearchUrl, completion: { result in
            switch result {
            case .success(let data):
                do {
                    guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
                    let users: [User] = jsonArray.compactMap { [weak self] in
                        guard
                            let strongSelf = self,
                            let login = $0["login"] as? String,
                            let avatarUrl = $0["avatarUrl"] as? String
                            else { return nil }
                        
                        let user = User(context: strongSelf.persistence.context)
                        user.login = login
                        user.avatarUrl = avatarUrl
                        
                        return user
                    }
                    print(users)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }) { headerLinks in
                if let nextPagePath = headerLinks["rel=\"next\""] {
                self.nextLink = nextPagePath
            }
            
            if let prevPage = headerLinks["rel=\"prev\""] {
                self.prevLink = prevPage
            }
        }
        
        /* getSearchUsers(url: userSearchUrl, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
//                    self.users = users
                    self.view?.success()
                case .failure(let error):
                    print(error)
                }
            }
        }) { headerLinks in
            if let nextPagePath = headerLinks["rel=\"next\""] {
                self.nextLink = nextPagePath
            }
            
            if let prevPage = headerLinks["rel=\"prev\""] {
                self.prevLink = prevPage
            }
        } */
    }
    
}

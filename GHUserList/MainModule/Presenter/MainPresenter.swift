//
//  MainPresenter.swift
//  GHUserList
//
//  Created by wtildestar on 28/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import Foundation

protocol MainViewProtocol: class {
    func success()
    func failure(error: Error)
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: Router)
    func getUsers()
    var users: [User]? { get set }
    var followers: [Follower]? { get set }
    func tapOnTheUser(follower: Follower?)
}

class MainPresenter: MainViewPresenterProtocol {
    weak var view: MainViewProtocol?
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    var users: [User]?
    var followers: [Follower]?
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, router: Router) {
        self.view = view
        self.networkService = networkService
        self.router = router
        getUsers()
    }
    
    func tapOnTheUser(follower: Follower?) {
        router?.showDetail(follower: follower)
    }
    
    func getUsers() {
        networkService.getUsers { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                    self.view?.success()
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
}

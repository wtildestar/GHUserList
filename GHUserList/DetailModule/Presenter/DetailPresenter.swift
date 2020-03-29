//
//  DetailPresenter.swift
//  GHUserList
//
//  Created by wtildestar on 28/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import Foundation

protocol DetailViewProtocol: class {
    func setFollower(follower: Follower?)
}

protocol DetailViewPresenterProtocol: class {
    init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, follower: Follower?)
    func setFollower()
    func popRoot()
}

class DetailPresenter: DetailViewPresenterProtocol {
    
    weak var view: DetailViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var follower: Follower?
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, follower: Follower?) {
        self.view = view
        self.router = router
        self.networkService = networkService
        self.follower = follower
    }
    
    func setFollower() {
        view?.setFollower(follower: follower)
    }
    
    func popRoot() {
        router?.popRoot()
    }
    
}

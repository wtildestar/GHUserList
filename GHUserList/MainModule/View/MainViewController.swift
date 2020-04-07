//
//  MainViewController.swift
//  GHUserList
//
//  Created by wtildestar on 28/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: MainPresenter!
    var fetchingMore: Bool = false
    
    lazy var fetchedResultsController: NSFetchedResultsController<User> = {
        let context = PersistenceService.shared.persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "login", ascending: true)
        ]
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "login",
            cacheName: nil
        )
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch let err {
            print(err)
        }
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getUsers()
        tableView.register(UINib(nibName: "MainViewCell", bundle: nil), forCellReuseIdentifier: "MainViewCell")
        NotificationCenter.default.addObserver(forName: NSNotification.Name("PersistedDataUpdated"), object: nil, queue: .main) { _ in
            
        }
        presenter.persistence.fetch(User.self) { [weak self] users in
            guard let self = self else { return }
            self.presenter.users = users
            self.presenter.view?.success()
        }
    }
    
//    private func clearData() {
//        do {
//            let context = CoreDataManager.shared.persistentContainer.viewContext
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//            do {
//                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
//                _ = objects.map{$0.map{context.delete($0)}}
//                CoreDataManager.shared.saveContext()
//            } catch let error {
//                print("ERROR DELETING : \(error)")
//            }
//        }
//    }
    
    func beginBatchFetch() {
        
//        guard var nextLink = presenter.nextLink else { return }
        fetchingMore = true
        print("Begin batch fetch..")
        
//        presenter.networkService.get
     
       /* getSearchUsers(url: nextLink, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
//                    self.presenter.users?.append(contentsOf: users ?? [])
                    self.presenter.view?.success()
                case .failure(let error):
                    print(error)
                }
            }
        }) */ /* { headerLink in
            if let nextPagePath = headerLink["rel=\"next\""] {
                nextLink = nextPagePath
                //                DispatchQueue.main.async {
                // self.nextButton.isEnabled = true
                //                }
            }
            
        } */
        
        fetchingMore = false
        
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.users.count
//        return fetchedResultsController.sections![section].numberOfObjects
//        if let count = fetchedResultsController.sections?.first?.numberOfObjects {
//            return count
//        }
//        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
        
//        if let user = fetchedResultsController.object(at: indexPath) as? User {
////            cell.setPhotoCellWith(photo: user)
//            cell.setUserCellWith(user: user)
//        }
        
//        if let user = fetchedResultsController.object(at: indexPath) as? User {
//            cell.setUserCellWith(user: user)
//        }

        
//        let user = fetchedResultsController.object(at: indexPath)
//        presenter.user = user
//        cell.user = user
        
        let user = presenter.users[indexPath.row]
        cell.user = user
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MainViewCell", for: indexPath) as! MainViewCell
//        tableView.register(UINib(nibName: "MainViewCell", bundle: nil), forCellReuseIdentifier: "MainViewCell")
        
//        let user = presenter.users[indexPath.row]
//        cell.userLabel.text = user.login
        
//        cell.userImageView.image = user.imageData as? UIImage
        
//        presenter.getUsers()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let follower = presenter.followers?[indexPath.row]
        presenter.tapOnTheUser(follower: follower)
    }
}

extension MainViewController: MainViewProtocol {
    func success() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}


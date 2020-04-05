//
//  MainViewCell.swift
//  GHUserList
//
//  Created by wtildestar on 30/03/2020.
//  Copyright © 2020 wtildestar. All rights reserved.
//

import UIKit

class MainViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    
//    var user: User? {
//        didSet {
//            userLabel.text = user?.login
//
////            if let imageData = user?.imageData {
////                userImageView.image = UIImage(data: imageData)
////            }
//        }
//    }
    
    func setUserCellWith(user: User) {
        
        DispatchQueue.main.async {
            self.userLabel.text = user.login
            if let url = user.avatarUrl {
                self.userImageView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "avatar-placeholder"))
            }
        }
    }
    
//    var presenter: MainPresenter! {
//        didSet {
//            userLabel.text = presenter.user?.login
//        }
//    }
//    var networkService: NetworkService!
    
    // MARK: - View Controller
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
//        func set(user: User) {
//            downloadImage(fromURL: user.avatarUrl)
//        }
        
//        func downloadImage(fromURL url: String) {
//            var placeholderImage = UIImage(named: "avatar-placeholder")
//
//            networkService.downloadImage(from: url) { image in
                //            guard let self = self else { return }
//                DispatchQueue.main.async {
                    //                self.mainViewCell.userImageView.image = image
//                    placeholderImage = image
//                }
//            }
//        }
//        presenter.networkService.downloadImage(from: presenter.user!) { image in
//            self.userImageView.image = image
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

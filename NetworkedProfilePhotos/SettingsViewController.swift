//
//  SettingsViewController.swift
//  NetworkedProfilePhotos
//
//  Created by Eric Ludlow on 4/4/18.
//  Copyright © 2018 EricLudlow. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var photosProfileView: UIView!
    
    @IBOutlet var photoViews: [PhotoView]!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bioTextView.text = ""
        
        if let users = User.getUsers() {
            self.users = users
        }
        
        guard users.count > 0 else { return }
        
        countLabel.text = "1 / \(users.count)"
        bioTextView.text = users[0].bio
        
        for (index, photoView) in photoViews.enumerated() {
            guard users.count > index else { return }
            
            let user = users[index]
            photoView.user = user
            photoView.delegate = self
            
            if let avatar = user.avatar {
                photoView.image = avatar
            } else {
                //TODO:- maybe add some kind of load indicator, for slow connections
                user.fetchAvatar() { (_, _) in
                    //TODO:- end load indicator
                    photoView.image = user.avatar ?? UIImage(named: "benfolds")
                }
            }
        }
    }
}

extension SettingsViewController: PhotoViewDelegate {
    func imageTapped(user: User?) {
        guard let user = user else { return }
        
        countLabel.text = "\(user.id + 1) / \(users.count)"
        bioTextView.text = user.bio
    }
    
    func imageLongSelected() {
        photoViews.forEach({ $0.showClearButton() })
    }
}

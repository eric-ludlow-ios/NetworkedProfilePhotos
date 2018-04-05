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
    @IBOutlet weak var bigPhotoView: PhotoView!
    @IBOutlet weak var smallPhotoView1: PhotoView!
    @IBOutlet weak var smallPhotoView2: PhotoView!
    @IBOutlet weak var smallPhotoView3: PhotoView!
    @IBOutlet weak var smallPhotoView4: PhotoView!
    @IBOutlet weak var smallPhotoView5: PhotoView!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bioTextView.text = ""
        photoViews.forEach({ $0.delegate = self })
        
        if let users = User.getUsers() {
            self.users = users
        }
        
        guard users.count > 0 else { return }
        
        countLabel.text = "1 / \(users.count)"
        bioTextView.text = users[0].bio
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // this logic should be adjusted or moved out of `viewWillAppear` if there is ever any other way to leave this view besides popping (or dismissing) the VC
        for (index, photoView) in photoViews.enumerated() {
            guard users.count > index else { return }
            
            let user = users[index]
            
            if let avatar = user.avatar {
                photoView.imageView.image = avatar
            } else {
                //TODO:- some kind of load indicator, for slow connections
                user.fetchAvatar() { (_, _) in
                    //TODO:- end load indicator
                    photoView.imageView.image = user.avatar ?? UIImage(named: "benfolds")
                }
            }
        }
    }
}

extension SettingsViewController: PhotoViewDelegate {
    func imageLongSelected() {
        photoViews.forEach({ $0.showClearButton() })
    }
}

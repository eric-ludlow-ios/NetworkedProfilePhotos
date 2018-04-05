//
//  SettingsViewController.swift
//  NetworkedProfilePhotos
//
//  Created by Eric Ludlow on 4/4/18.
//  Copyright © 2018 EricLudlow. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var basicsLabel: UILabel!
    @IBOutlet weak var preferencesLabel: UILabel!
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
        setView(for: 0)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard MFMailComposeViewController.canSendMail() else { return }
        guard let screenshot = UIImage.screenshot(), let picture = UIImagePNGRepresentation(screenshot) else { return }
        
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setToRecipients(["cpratt@sofi.org", "tlawson@sofi.org"])
        mailViewController.setPreferredSendingEmailAddress("eric.ludlow.ios@gmail.com")
        mailViewController.setSubject("Eric Ludlow's take home screenshot")
        mailViewController.setMessageBody("Hello. Please find attached below the screenshot of the take home project. Please keep your eyes open for a follow-up email with the project.", isHTML: false)
        mailViewController.addAttachmentData(picture, mimeType: "image/png", fileName: "screenshot")
        
        present(mailViewController, animated: true, completion: nil)
    }
    
    @IBAction func controlValueChanged(_ sender: UISegmentedControl) {
        setView(for: sender.selectedSegmentIndex)
    }
    
    private func setView(for index: Int) {
        basicsLabel.isHidden = index != 0
        preferencesLabel.isHidden = index != 1
        photosProfileView.isHidden = index != 2
    }
}

extension SettingsViewController: PhotoViewDelegate {
    func imageTapped(user: User?) {
        guard let user = user else { return }
        
        countLabel.text = "\(user.id + 1) / \(users.count)"
        bioTextView.isScrollEnabled = false
        bioTextView.text = user.bio
        bioTextView.contentOffset = .zero
        bioTextView.isScrollEnabled = true
    }
    
    func imageLongSelected() {
        photoViews.forEach({ $0.showClearButton() })
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}

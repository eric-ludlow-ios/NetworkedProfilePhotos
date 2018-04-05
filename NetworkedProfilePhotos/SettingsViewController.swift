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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        photoViews.forEach({ $0.delegate = self })
    }
}

extension SettingsViewController: PhotoViewDelegate {
    func imageLongSelected() {
        photoViews.forEach({ $0.showClearButton() })
    }
}

//
//  PhotoView.swift
//  NetworkedProfilePhotos
//
//  Created by Eric Ludlow on 4/4/18.
//  Copyright © 2018 EricLudlow. All rights reserved.
//

import UIKit

@IBDesignable

class PhotoView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBInspectable var image: UIImage? {
        get {
            return imageView.image
        }
        set(image) {
            imageView.image = image
        }
    }
    
    private var imageWasPressed: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpContent()
    }
    
    func setUpContent() {
        contentView = loadViewFromXib()
        
        setUpClearButton()
        setUpRoundedCorners()
        setUpGestureRecognizer()
        
        clearButton.isHidden = true
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: PhotoView.self)
        let nib = UINib(nibName: "PhotoView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    func setUpClearButton() {
        clearButton.layer.cornerRadius = clearButton.frame.width / 2
        clearButton.clipsToBounds = true
    }
    
    func setUpRoundedCorners() {
        let cornerRadius: CGFloat = 3.0
        imageView.layer.cornerRadius = cornerRadius
        contentView.layer.cornerRadius = cornerRadius
        layer.cornerRadius = cornerRadius
        
        imageView.clipsToBounds = true
        contentView.clipsToBounds = true
        clipsToBounds = true
    }
    
    func setUpGestureRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(showClearButton))
        longPressGestureRecognizer.minimumPressDuration = 1.5
        imageView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func showClearButton() {
        if !imageWasPressed {
            imageWasPressed = true
            clearButton.alpha = 0.0
            clearButton.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.clearButton.alpha = 1.0
            }, completion: nil)
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.imageView.alpha = 0.0
            self.clearButton.alpha = 0.0
        }, completion: { _ in
            self.imageView.isHidden = true
            self.clearButton.isHidden = true
        })
    }
}

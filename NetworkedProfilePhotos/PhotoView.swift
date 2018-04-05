//
//  PhotoView.swift
//  NetworkedProfilePhotos
//
//  Created by Eric Ludlow on 4/4/18.
//  Copyright © 2018 EricLudlow. All rights reserved.
//

import UIKit

protocol PhotoViewDelegate {
    func imageTapped(user: User?)
    func imageLongSelected()
}

@IBDesignable

class PhotoView: UIView {
    //MARK:- outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clearButton: UIButton!
    
    //MARK:- inspectables
    @IBInspectable var image: UIImage? {
        get {
            return imageView.image
        }
        set(image) {
            imageView.image = image
        }
    }
    
    //MARK:- properties
    var user: User?
    var delegate: PhotoViewDelegate?
    
    private var imageWasPressed: Bool = false
    
    //MARK:- initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpContent()
    }
    
    //MARK:- methods
    func showClearButton() {
        clearButton.alpha = 0.0
        clearButton.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.clearButton.alpha = 1.0
        }, completion: nil)
    }
    
    //MARK:- IBActions and gesture methods
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.imageView.alpha = 0.0
            self.clearButton.alpha = 0.0
        }, completion: { _ in
            self.imageView.isHidden = true
            self.clearButton.isHidden = true
        })
    }
    
    @objc func imageViewWasTapped() {
        delegate?.imageTapped(user: user)
    }
    
    @objc func imageViewWasPressed() {
        if !imageWasPressed {
            imageWasPressed = true
            if let delegate = delegate {
                delegate.imageLongSelected()
            } else {
                showClearButton()
            }
        }
    }
    
    //MARK:- private methods
    private func setUpContent() {
        contentView = loadViewFromXib()
        
        setUpClearButton()
        setUpRoundedCorners()
        setUpGestureRecognizers()
        
        clearButton.isHidden = true
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: PhotoView.self)
        let nib = UINib(nibName: "PhotoView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    private func setUpClearButton() {
        clearButton.layer.cornerRadius = clearButton.frame.width / 2
        clearButton.clipsToBounds = true
    }
    
    private func setUpRoundedCorners() {
        let cornerRadius: CGFloat = 3.0
        imageView.layer.cornerRadius = cornerRadius
        contentView.layer.cornerRadius = cornerRadius
        layer.cornerRadius = cornerRadius
        
        imageView.clipsToBounds = true
        contentView.clipsToBounds = true
        clipsToBounds = true
    }
    
    private func setUpGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewWasTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(imageViewWasPressed))
        longPressGestureRecognizer.minimumPressDuration = 1.5
        imageView.addGestureRecognizer(longPressGestureRecognizer)
    }
}

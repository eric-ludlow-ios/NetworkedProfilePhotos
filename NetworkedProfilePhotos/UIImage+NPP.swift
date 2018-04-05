//
//  UIImage+NPP.swift
//  NetworkedProfilePhotos
//
//  Created by Eric Ludlow on 4/5/18.
//  Copyright © 2018 EricLudlow. All rights reserved.
//

import UIKit

extension UIImage {
    static func screenshot(_ shouldSave: Bool = false) -> UIImage? {
        var screenshotImage: UIImage?
        
        guard let layer = UIApplication.shared.keyWindow?.layer else { return nil }
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        return screenshotImage
    }
}

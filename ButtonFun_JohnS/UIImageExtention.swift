//
//  UIImageExtention.swift
//  ButtonFun_JohnS
//
//  Created by xavier on 1/15/17.
//  Copyright © 2017 John. All rights reserved.
//

import UIKit


extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

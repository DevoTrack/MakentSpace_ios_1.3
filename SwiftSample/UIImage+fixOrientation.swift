//
//  UIImage+fixOrientation.swift
//  Makent
//
//  Created by trioangle on 30/11/21.
//  Copyright © 2021 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    func fixOrientation()->UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}

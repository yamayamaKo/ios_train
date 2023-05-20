//
//  UIImageExtension.swift
//  EffectView
//
//  Created by 山田紘暉 on 2023/05/20.
//

import Foundation
import UIKit

extension UIImage {
    func resized() -> UIImage? {
        let rate = 1024.0 / self.size.width
        let rect = CGRect(x: 0, y: 0, width: self.size.width * rate, height: self.size.height * rate)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

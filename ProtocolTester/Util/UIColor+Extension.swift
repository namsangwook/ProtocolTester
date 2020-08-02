//
//  UIColor+Extension.swift
//  thaiOTT
//
//  Created by MB-0017 on 2020/05/06.
//  Copyright © 2020 MB-0017. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init(_ r: Int, _ g: Int, _ b: Int) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
    public convenience init(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
    }
    
    public static var gradientStart: UIColor {
        return UIColor(248, 151, 29)
    }
    
    public static var gradientCenter: UIColor {
        return UIColor(241, 90, 38)
    }
    
    public static var gradientEnd: UIColor {
        return UIColor(235, 39, 39)
    }
    
    @nonobjc class var black: UIColor {
      return UIColor(white: 25.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var veryLightPink: UIColor {
      return UIColor(white: 200.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var white: UIColor {
      return UIColor(white: 1.0, alpha: 1.0)
    }

    @nonobjc class var black84: UIColor {
      return UIColor(white: 25.0 / 255.0, alpha: 0.84)
    }

    @nonobjc class var blackTwo: UIColor {
      return UIColor(white: 54.0 / 255.0, alpha: 1.0)
    }

}


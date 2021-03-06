//
//  UIImage+.swift
//  HackerNews
//
//  Created by Никита Васильев on 24/08/2018.
//  Copyright © 2018 Никита Васильев. All rights reserved.
//

import UIKit

extension UIImage {
    enum Asset: String {
        case appIcon = "AppIcon"
        case earth = "Earth"
        case news = "News"
        case ask = "Ask"
        case show = "Show"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}

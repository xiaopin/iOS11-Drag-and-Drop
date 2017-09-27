//
//  extensions.swift
//  demo
//
//  Created by nhope on 2017/9/27.
//  Copyright © 2017年 nhope. All rights reserved.
//

import UIKit


extension UIColor {
    
    /// 随机颜色
    static var random: UIColor {
        get {
            let r = CGFloat(arc4random() % 255) / 255.0
            let g = CGFloat(arc4random() % 255) / 255.0
            let b = CGFloat(arc4random() % 255) / 255.0
            return UIColor(red: r, green: g, blue: b, alpha: 1.0)
        }
    }
    
}


extension UIImage {
    
    /// 将UIColor转换成UIImage
    ///
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片大小,默认大小为`1x1`point
    /// - Returns: 颜色对应的图片
    static func fromColor(_ color: UIColor, imageSize: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: imageSize)
        UIGraphicsBeginImageContext(rect.size)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}

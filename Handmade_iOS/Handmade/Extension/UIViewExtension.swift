//
//  UIViewExtension.swift
//  Handmade
//
//  Created by mk on 2019/12/18.
//  Copyright © 2019 mk. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get {
            
            return layer.cornerRadius
        }
        
        set {
            
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            
            return layer.borderWidth
        }
        
        set {
            
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        
        get {
            
            return UIColor(cgColor: layer.borderColor!)
        }
        
        set {
            
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func setShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat, masksToBounds: Bool = false) {
        
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = masksToBounds
    }
    
    func transitionAnimation(duration: CFTimeInterval, type: CATransitionType, subType: CATransitionSubtype?) {
        
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = type
        animation.subtype = subType
        animation.duration = duration
        layer.add(animation, forKey: type.rawValue)
    }
    
    func transitionAnimation(duration: TimeInterval, options: UIView.AnimationOptions, animations: (() -> Void)?, completion: ((Bool) -> Void)?) {
        
        UIView.transition(with: self, duration: duration, options: options, animations: animations, completion: completion)
    }
    
    // Draw Dotted Border
    func setDottedBorder() {
        
        let dottedBorder = CAShapeLayer()
        dottedBorder.strokeColor = UIColor.white.cgColor
        dottedBorder.lineDashPattern = [4, 4]
        dottedBorder.frame = self.bounds
        dottedBorder.fillColor = nil
        dottedBorder.path = UIBezierPath(rect: self.bounds).cgPath
        
        self.layer.addSublayer(dottedBorder)
        
        return
    }
}

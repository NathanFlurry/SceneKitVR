//
//  UIView+Magic.swift
//  VRMusicRoom
//
//  Created by Nathan Flurry on 5/5/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import UIKit

extension UIView {
    func forceLayout() {
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func addQuickConstraints(constraints: [(String, NSLayoutFormatOptions?)], views: [String: UIView], metrics: [String: CGFloat]? = nil) {
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        var combinedConstraints = [NSLayoutConstraint]()
        for (format, options) in constraints {
            combinedConstraints += NSLayoutConstraint.constraintsWithVisualFormat(
                format,
                options: options != nil ? options! : [],
                metrics: metrics,
                views: views
            )
        }
        
        addConstraints(combinedConstraints)
    }
}
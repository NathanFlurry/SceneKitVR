//
//  SCNNode+Magic.swift
//  VRMusicRoom
//
//  Created by Nathan Flurry on 5/8/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

extension SCNNode {
    func parentNodeWithName(name: String, includeChild: Bool) -> SCNNode? {
        // Check itself
        if includeChild {
            if self.name == name {
                return self
            }
        }
        
        // Check the parent, if no parent, return nil
        if let parent = self.parentNode {
            if parent.name == name {
                return parent
            } else {
                return parentNodeWithName(name, includeChild: false)
            }
        } else {
            return nil
        }
    }
}

//
//  OverlayScene.swift
//  VRMusicRoom
//
//  Created by Nathan Flurry on 5/7/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SpriteKit

class OverlayScene: SKScene {
    let centerIndicator: SKShapeNode
    
    var indicatorOffset: CGPoint = CGPointZero {
        didSet {
            updateIndicatorPosition()
        }
    }
    
    override var size: CGSize {
        didSet {
            updateIndicatorPosition()
        }
    }
    
    override init(size: CGSize) {
        centerIndicator = SKShapeNode(circleOfRadius: 2)
        centerIndicator.fillColor = SKColor.whiteColor()
        
        super.init(size: size)
        
        addChild(centerIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateIndicatorPosition() {
        centerIndicator.position = CGPoint(x: size.width / 2 + indicatorOffset.x, y: size.height / 2 + indicatorOffset.y)
    }
}

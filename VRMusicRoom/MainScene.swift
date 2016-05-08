//
//  MainScene.swift
//  VRMusicRoom
//
//  Created by Nathan Flurry on 5/5/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit
import CoreMotion

class MainScene: VRScene {
    override init() {
        super.init()
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        // Load the url and scene source for the scene
        do {
            if let url = NSBundle.mainBundle().URLForResource("art.scnassets/Main", withExtension: "scn"),
                sceneSource = SCNSceneSource(URL: url, options: nil) {
                do {
                    // Get the scene
                    let scene = try sceneSource.sceneWithOptions(nil)
                    
                    // Move all children to this node
                    for child in scene.rootNode.childNodes {
                        rootNode.addChildNode(child)
                    }
                } catch {
                    print("There was an error loading the scene.\n\(error)")
                    return
                }
            } else {
                print("Could not get url or scene source for main scene.")
                return
            }
        }

        
        // Animate the ship rotating
        do {
            // Retrieve the ship node
            let ship = rootNode.childNodeWithName("ship", recursively: true)!
            
            // Animate the 3d object
            ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        }
    }
}

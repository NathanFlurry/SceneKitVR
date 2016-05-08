//
//  GameViewController.swift
//  VRMusicRoom
//
//  Created by Nathan Flurry on 5/5/16.
//  Copyright (c) 2016 Nathan Flurry. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var vrView: VRView? {
        return view as? VRView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new scene
        let scene = MainScene()
        
        // Create the view
        view = VRView(scene: scene, frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        vrView?.backgroundColor = UIColor.blackColor()
        vrView?.debug = true
        
        // Move the camera up
        vrView?.camera.position.y = 5
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            return .AllButUpsideDown
//        } else {
//            return .All
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

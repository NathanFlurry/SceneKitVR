//
//  GameViewController.swift
//  VRMusicRoom
//
//  Created by Nathan Flurry on 5/5/16.
//  Copyright (c) 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    // Automatically converts the view to a VRView
    var vrView: VRView?
    
    // The scene
    var scene: MainScene?
    
    // The target camera separation
    var targetCameraSeparation = 0 as Float
    
//    // The overlay scenes
//    var overlayIndicatorOffset: CGPoint = CGPointZero {
//        willSet(value) {
//            overlayLeft?.indicatorOffset = CGPoint(x: value.x, y: value.y)
//            overlayRight?.indicatorOffset = CGPoint(x: -value.x, y: value.y)
//        }
//    }
//    var overlayLeft: OverlayScene?
//    var overlayRight: OverlayScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new scene
        scene = MainScene()
        
        // Create the view
        vrView = VRView(scene: scene!, frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        // Force the view to fit the superview
        view.addSubview(vrView!)
        view.addQuickConstraints(
            [
                ("H:|[vrView]|", nil),
                ("V:|[vrView]|", nil)
            ],
            views: [ "vrView": vrView!]
        )
        
        // Configure the view
//        vrView?.debug = true
        vrView?.delegate = self
        vrView?.backgroundColor = UIColor.blackColor()
        vrView?.antialiasingMode = .Multisampling4X
        
        // Add tap gesture to detect triggers
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(triggered(_:)))
        gesture.minimumPressDuration = 0 // Trigger instantly
        gesture.allowableMovement = CGFloat(INT_MAX) // Allow touch to move anywhere on the screen
        vrView?.addGestureRecognizer(gesture)
        
//        // Create the overlay scene
//        overlayLeft = OverlayScene(size: CGSizeZero)
//        overlayRight = OverlayScene(size: CGSizeZero)
//        overlayIndicatorOffset = CGPoint(x: -30, y: 0)
//        vrView?.overlaySKScene = .Separate(overlayLeft!, overlayRight!)
        
        // Configure the camera
        vrView?.vrScene.camera.separationDistance = -1.1
        vrView?.camera.position.y = 5
    }
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        // Update the position of the focus indicator
        scene?.updateFocusTransform()
        
        // Deal with hit tests
        scene?.executeHitTest()
    }
    
    func triggered(gesture: UILongPressGestureRecognizer) {
        // Deal with scene being triggered based on gesture state
        switch gesture.state {
        case .Began, .Changed:
            scene?.triggering = true
        default:
            scene?.triggering = false
        }
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

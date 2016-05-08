//
//  VRViewView.swift
//  VRMusicRoom
//
//  Created by Nathan Flurry on 5/5/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit
import SpriteKit

enum VROverlaySceneType {
    case None, Shared(SKScene), Separate(SKScene, SKScene)
}

class VRView: UIView, SCNSceneRendererDelegate {
    // The scene
    var vrScene: VRScene
    var camera: VRCamera {
        return vrScene.camera
    }
    
    // Debug stats
    var debug: Bool = false {
        willSet(value) {
            leftView.allowsCameraControl = value
            leftView.showsStatistics = value
            rightView.allowsCameraControl = value
            rightView.showsStatistics = value
        }
    }
    
    // Delegates the events from the viewports to this delegate
    weak var delegate: SCNSceneRendererDelegate?
    
    // The views
    var leftView: VRViewportView
    var rightView: VRViewportView
    
    // The view modifiers
    override var backgroundColor: UIColor? {
        willSet(value) {
            leftView.backgroundColor = value
            rightView.backgroundColor = value
        }
    }
    var overlaySKScene: VROverlaySceneType = .None { // Note: overlay scenes are not good for VR because they aren't centered properly with each eye
        willSet(value) {
            let sceneSize = CGSize(width: bounds.width / 2, height: bounds.height)
            
            // Assign the scene
            switch value {
            case .None:
                leftView.overlaySKScene = nil
                rightView.overlaySKScene = nil
            case .Shared(let scene):
                leftView.overlaySKScene = scene
                rightView.overlaySKScene = scene
                
                scene.size = sceneSize
            case .Separate(let leftScene, let rightScene):
                leftView.overlaySKScene = leftScene
                rightView.overlaySKScene = rightScene
                
                leftScene.size = sceneSize
                rightScene.size = sceneSize
            }
        }
    }
    var antialiasingMode: SCNAntialiasingMode = .None {
        willSet(value) {
            leftView.antialiasingMode = antialiasingMode
            rightView.antialiasingMode = antialiasingMode
        }
    }
    
    init(scene scn: VRScene, frame: CGRect, options: [String : AnyObject]? = nil) {
        // Save the scene
        vrScene = scn
        
        // Set a camera
        vrScene.camera = VRCamera()
        
        // Create the views
        leftView = VRViewportView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), options: options)
        rightView = VRViewportView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), options: options)
        
        super.init(frame: frame)
        
        // Configure the views
        configureSceneView(leftView, cameraSide: .Left)
        configureSceneView(rightView, cameraSide: .Right)
        
        // Add views as subviews
        addSubview(leftView)
        addSubview(rightView)
        
        // Add constraints to the views
        addQuickConstraints(
            [
                ("H:|[left(>=1)][right(==left)]|", nil),
                ("V:|[left(>=1)]|", nil),
                ("V:|[right(>=1)]|", nil)
            ],
            views: [
                "left": leftView,
                "right": rightView
            ]
        )
        forceLayout()
        
        // Tell the scene it's ready
        vrScene.vrSceneReady()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // Resize the overlay
        let sceneSize = CGSize(width: bounds.width / 2, height: bounds.height)
        switch overlaySKScene {
        case .Shared(let scene):
            scene.size = sceneSize
        case .Separate(let leftScene, let rightScene):
            leftScene.size = sceneSize
            rightScene.size = sceneSize
        default:
            break
        }
    }
    
    private func configureSceneView(view: SCNView, cameraSide: VRCameraSide) {
        // Set the scenes
        view.scene = vrScene
        
        // Set the delegate
        view.delegate = self
        
        // Make sure the scene is playing
        view.playing = true
        
        // Set the proper camera
        switch cameraSide {
        case .Left:
            view.pointOfView = vrScene.camera.cameraLeft
        case .Right:
            view.pointOfView = vrScene.camera.cameraRight
        }
    }
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        // FIXME: This will be called twice per frame
        // Render the VR camera
        vrScene.camera.renderer(renderer, updateAtTime: time)
        
        // Delegate the event
        delegate?.renderer?(renderer, updateAtTime: time)
    }
    
    func renderer(renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: NSTimeInterval) {
        // Delegate the event
        delegate?.renderer?(renderer, didApplyAnimationsAtTime: time)
    }
    
    func renderer(renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: NSTimeInterval) {
        // Delegate the event
        delegate?.renderer?(renderer, didSimulatePhysicsAtTime: time)
    }
    
    func renderer(renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: NSTimeInterval) {
        // Delegate the event
        delegate?.renderer?(renderer, willRenderScene: scene, atTime: time)
    }
    
    func renderer(renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: NSTimeInterval) {
        // Delegate the event
        delegate?.renderer?(renderer, didRenderScene: scene, atTime: time)
    }
}

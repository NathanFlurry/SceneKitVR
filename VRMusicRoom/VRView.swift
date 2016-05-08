//
//  VRViewView.swift
//  VRMusicRoom
//
//  Created by Nathan Flurry on 5/5/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit

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
    
    // The views
    override var backgroundColor: UIColor? {
        willSet(value) {
            leftView.backgroundColor = value
            rightView.backgroundColor = value
        }
    }
    var leftView: SCNView
    var rightView: SCNView
    
    init(scene scn: VRScene, frame: CGRect, options: [String : AnyObject]? = nil) {
        // Save the scene
        vrScene = scn
        
        // Set a camera
        vrScene.camera = VRCamera()
        
        // Create the views
        leftView = SCNView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), options: options)
        rightView = SCNView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), options: options)
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSceneView(view: SCNView, cameraSide: VRCameraSide) {
        // Set the scenes
        view.scene = vrScene
        
        // Set the delegate
        view.delegate = self
        
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
    }
}

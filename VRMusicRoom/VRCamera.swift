//
//  VRCamera.swift
//  VRMusicRoom
//
//  Created by Nathan Flurry on 5/5/16.
//  Copyright © 2016 Nathan Flurry. All rights reserved.
//

import SceneKit
import CoreMotion

enum VRCameraSide {
    case Left, Right
}

class VRCamera: SCNNode {
    // Determines if the camera position will be updated based on the CoreMotion update cycle or the frames
    var automaticCoreMotionUpdates: Bool = false {
        willSet(value) {
            // Check it actually changed
            guard value == automaticCoreMotionUpdates else {
                return
            }
            
            // Deal with the CM updates
            if value {
                
            } else {
                
            }
        }
    }
    
    // The field of view of the camera
    var fieldOfView: Double = 0 {
        willSet(value) {
            cameraLeft.camera?.xFov = value
            cameraLeft.camera?.yFov = value
            cameraRight.camera?.xFov = value
            cameraRight.camera?.yFov = value
        }
    }
    
    // How far apart the cameras are
    var separationDistance: Float = 0 {
        willSet(value) {
            cameraLeft.position.x = -value
            cameraRight.position.x = value
        }
    }
    
    var cameraLeft: SCNNode
    var cameraRight: SCNNode
    var cameraRollNode: SCNNode
    var cameraPitchNode: SCNNode
    var cameraYawNode: SCNNode
    
    var motionManager: CMMotionManager
    
    init(fieldOfView fov: Double = 120, separationDistance separation: Float = 0) {
        // Setup cameras
        cameraLeft = SCNNode()
        cameraRight = SCNNode()
        cameraLeft.camera = SCNCamera()
        cameraRight.camera = SCNCamera()
        cameraLeft.position.x = -separation
        cameraRight.position.x = separation
        
        // Setup transforms
        cameraRollNode = SCNNode()
        cameraPitchNode = SCNNode()
        cameraYawNode = SCNNode()
        
        // Setup motion manager
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 1 / 60
        motionManager.startDeviceMotionUpdatesUsingReferenceFrame(.XArbitraryZVertical)
        
        super.init()
        
        // Setup node hierarchy
        cameraRollNode.addChildNode(cameraLeft)
        cameraRollNode.addChildNode(cameraRight)
        cameraPitchNode.addChildNode(cameraRollNode)
        cameraYawNode.addChildNode(cameraPitchNode)
        addChildNode(cameraYawNode)
        
        // Setup camera properties
        fieldOfView = fov
        separationDistance = separation
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Called every frame, since camera position should be changed on a per-frame basis, not on a per-update basis
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        // Update the transform based on the most recent mtion
        if let motion = motionManager.deviceMotion {
            let currentAttitude = motion.attitude
            let offset = cameraOffsetAngles()
            
            // Transform roll properly for lanscape orientation
            var roll : Double = currentAttitude.roll
            if UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeRight {
                roll = -1.0 * (-M_PI - roll) // FIXME: This is not working properly
            }
            
            // Update the rotations
            cameraRollNode.eulerAngles.x = Float(roll) + offset.x
            cameraPitchNode.eulerAngles.z = Float(currentAttitude.pitch) + offset.z
            cameraYawNode.eulerAngles.y = Float(currentAttitude.yaw) + offset.y
        } else {
//            print("There was no device motion available.")
        }
    }
    
    // The angle offset of the camera
    private func cameraOffsetAngles() -> SCNVector3 {
        /*
         var camerasNodeAngle1: Double!              = 0.0
         var camerasNodeAngle2: Double!              = 0.0
         
         let orientation = UIApplication.sharedApplication().statusBarOrientation.rawValue
         
         if orientation == 1 {
         camerasNodeAngle1                       = -M_PI_2
         } else if orientation == 2 {
         camerasNodeAngle1                       = M_PI_2
         } else if orientation == 3 {
         camerasNodeAngle1                       = 0.0
         camerasNodeAngle2                       = M_PI
         }
         
         return [ -M_PI_2, camerasNodeAngle1, camerasNodeAngle2]
         */
 
        return SCNVector3(-M_PI / 2, 0, 0)
    }
    
    // Returns a new constraint that allows one to easily pin items to the camera
    func newCameraPinConstraint() -> SCNTransformConstraint {
        return SCNTransformConstraint(
            inWorldSpace: true,
            withBlock: {
                (node, transform) -> SCNMatrix4 in
                return SCNMatrix4Mult(
                    self.transform,
                    SCNMatrix4Mult(
                        SCNMatrix4Mult(self.cameraRollNode.transform, self.cameraPitchNode.transform),
                        self.cameraYawNode.transform
                    )
                )
            }
        )
    }
}

import UIKit
import ARKit
import SceneKit
import PlaygroundSupport

class ViewController: NSObject {
    
    var sceneView: ARSCNView
    init(sceneView: ARSCNView) {
        self.sceneView = sceneView
        
        super.init()

        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.setupWorldTracking()
        
        self.sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(_:))))
    }
    
    private func setupWorldTracking() {
        if ARWorldTrackingSessionConfiguration.isSupported {
            let configuration = ARWorldTrackingSessionConfiguration()
            configuration.planeDetection = .horizontal
            configuration.isLightEstimationEnabled = true
            self.sceneView.session.run(configuration, options: [])
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let results = self.sceneView.hitTest(gesture.location(in: gesture.view), types: ARHitTestResult.ResultType.featurePoint)
        guard let result: ARHitTestResult = results.first else {
            return
        }
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        let color = SCNMaterial()
        color.diffuse.contents = UIColor.white
        color.lightingModel = .constant
        box.materials = [color]
        
        let node = SCNNode(geometry: box)
        
        let position = SCNVector3Make(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        node.position = position
        
        self.sceneView.scene.rootNode.addChildNode(node)
    }
}

let sceneView = ARSCNView()
let viewController = ViewController(sceneView: sceneView)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = viewController.sceneView

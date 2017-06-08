import UIKit
import SceneKit

// 1
extension GameViewController: SCNSceneRendererDelegate {
    // 2
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // 3
        if(self.particleCounter < 200) {
            spawnShape()
            self.particleCounter+=1
        }
        
        cleanScene()
        
    }
}



class GameViewController: UIViewController {
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    public var particleCounter:Int = 1
    private var _currentCollor:UIColor = UIColor.green
    private var currentCollor:UIColor {
        get {
            return _currentCollor
        }
        
        set {
            switch _currentCollor {
            case UIColor.green:
                _currentCollor = UIColor.red
            case UIColor.red:
                _currentCollor = UIColor.blue
            case UIColor.blue:
                _currentCollor = UIColor.orange
            case UIColor.orange:
                _currentCollor = UIColor.yellow
            case UIColor.yellow:
                _currentCollor = UIColor.green

            default:
                _currentCollor = UIColor.white
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("a")
        setupView()
        setupScene()
        //setupCamera()
        spawnShape()
        //spawnShape2()
        
        
     
        
        
        
    }
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        
        scnView.delegate = self
        
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = false
        // 3
        //scnView.autoenablesDefaultLighting = true
        
        scnView.isPlaying = true
    }
    
    func setupScene() {
        scnScene = SCNScene(named: "Scenes.scnassets/scenes/Standard.scn")!
        scnView.scene = scnScene
    
    }
    
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 2, z: 10)
        cameraNode.eulerAngles = SCNVector3(x: -0.1, y: 0, z: 0)
        // 4
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnShape() {
        
        // 1
        var geometry:SCNGeometry
        // 2
        switch ShapeType.random() {
        
        default:
            // 3
            geometry = SCNSphere(radius: CGFloat(0.1))
            //geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        }
        // 4
        geometry.materials.first?.diffuse.contents = UIColor.yellow
        let geometryNode = SCNNode(geometry: geometry)
        // 5
        scnScene.rootNode.addChildNode(geometryNode)
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        geometryNode.position = SCNVector3(x: 0, y: 5, z: 0)

       
        // 1
        let randomX = Float(0)
        let randomY = Float(0)
        // 2
        let force = SCNVector3(x: randomX, y: randomY , z: 0)
        // 3
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        // 4
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        
//        let color = UIColor.green
//        geometry.materials.first?.diffuse.contents = color
//        let trailEmitter = createTrail(color: color, geometry: geometry)
//        geometryNode.addParticleSystem(trailEmitter)
    }
    
    
    func cleanScene() {
        // 1
        for node in scnScene.rootNode.childNodes {
            // 2
            if node.presentation.position.y < -5 {
                // 3
                node.removeFromParentNode()
                self.particleCounter -= 1
            }
        }
    }
    
    func createTrail(color: UIColor, geometry: SCNGeometry) ->
        SCNParticleSystem {
            // 2
            let trail = SCNParticleSystem(named: "Fire.scnp", inDirectory: nil)!
            // 3
            trail.particleColor = color
            // 4
            trail.emitterShape = geometry
            // 5
            return trail
    }
    
    func handleTouchFor(node: SCNNode) {
        
        //node.removeFromParentNode()
        //let color = UIColor.green
        //node.addParticleSystem(createTrail(color: color, geometry: node.geometry!))
        print("touch!")

        
    }
    
    func move(node: SCNNode, event: UIEvent?) {
        
        if let evento = event {
            
        }
        let force = SCNVector3(x: Float(1), y: Float(0) , z: Float(1))
        // 3
        let position = SCNVector3(x: node.position.x, y: node.position.y, z: node.position.z)
        // 4
        node.physicsBody?.applyForce(force, at: position, asImpulse: true)
        node.geometry?.materials.first?.diffuse.contents = currentCollor
        currentCollor = UIColor.yellow
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        // 1
        let touch = touches.first!
        // 2
        let location = touch.location(in: scnView)
        // 3
        let hitResults = scnView.hitTest(location, options: nil)
        // 4
        if let result = hitResults.first {
            // 5
            handleTouchFor(node: result.node)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        // 2
        let location = touch.location(in: scnView)
        // 3
        let hitResults = scnView.hitTest(location, options: nil)
        // 4
        if let result = hitResults.first {
            // 5
            move(node: result.node, event: event)
        }

    }
}

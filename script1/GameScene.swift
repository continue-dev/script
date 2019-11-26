//
//  GameScene.swift
//  script1
//
//  Created by Yoshiki Izumi on 2019/11/26.
//  Copyright © 2019 Yoshiki Izumi. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        guard let path = Bundle.main.path(forResource: "script", ofType: "jump") else {return}
        do {
            let script = try String(contentsOfFile: path, encoding: String.Encoding.utf8)


            guard let begin1 = script.range(of: "var") else {return}
            guard let end1 = script.range(of: "=") else {return}
            let varRange = begin1.upperBound..<end1.lowerBound
            var variable = script[varRange]

            while let range = variable.range(of: " ") {
                variable.replaceSubrange(range, with: "")
            }
//            print(variable)     // 青い花

            
            
//            print("@" + variable + "@")


            guard let begin = script.range(of: "\"") else {return}
            let nextRange = begin.upperBound..<script.endIndex
            guard let end = script.range(of: "\"", options: .caseInsensitive, range: nextRange) else {return}
            let wordRange = begin.upperBound..<end.lowerBound


//            print(script[wordRange])
//
            
            
            
            guard let begin3 = script.range(of: "print(") else {return}
            guard let end3 = script.range(of: ")") else {return}
            let printRange = begin3.upperBound..<end3.lowerBound
            let print1 = script[printRange]

//            while let range = variable.range(of: " ") {
//                variable.replaceSubrange(range, with: "")
//            }
            
            if print1 == variable {
                print(script[wordRange])
            }
//            print(print1)     // 青い花

            
            
            
            
        } catch let error as NSError {
            print("エラー: \(error)")
            return
        }
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

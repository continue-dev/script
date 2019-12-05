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
    private var funcArray : [String] = []
    private var funcScript : [String] = []
    
    func searchFunc(script: String) {
        var nextRange0 = script.startIndex..<script.endIndex
        while let begin0 = script.range(of: "func", options: .caseInsensitive, range: nextRange0) {
            
            nextRange0 = begin0.upperBound..<script.endIndex
            guard let end0 = script.range(of: "()", options: .caseInsensitive, range: nextRange0) else {break}
            
            let funcRange = begin0.upperBound..<end0.lowerBound
            var function = script[funcRange]

            while let range = function.range(of: " ") {
                function.replaceSubrange(range, with: "")
            }

            funcArray.append(function.description)
            
            nextRange0 = end0.upperBound..<script.endIndex
            
            guard let bracket0 = script.range(of: "{", options: .caseInsensitive, range: nextRange0) else {break}
            guard let bracket1 = script.range(of: "}", options: .caseInsensitive, range: nextRange0) else {break}
            let bracketRange = bracket0.upperBound..<bracket1.lowerBound

            funcScript.append(script[bracketRange].description)
        }

    }
    func funcParse(script:String) {
        var nextRange1 = script.startIndex..<script.endIndex
        for i in 0..<funcArray.count {
            while let end1 = script.range(of: funcArray[i] + "()", options: .caseInsensitive, range: nextRange1 ) {
                routine(script: funcScript[i])
                nextRange1 = end1.upperBound..<script.endIndex
            }
        }

    }
    func routine(script:String) {
        funcParse(script: script)

        var varArray: [Substring] = []
        var valArray: [Substring] = []
        
        var begin010 = script.startIndex
        while let begin01 = script.range(of: "var", options: .caseInsensitive, range: begin010..<script.endIndex) {
            guard let end1 = script.range(of: "=", options: .caseInsensitive, range: begin01.upperBound..<script.endIndex) else {return}
            let varRange = begin01.upperBound..<end1.lowerBound
            var variable = script[varRange]

            while let range = variable.range(of: " ") {
                variable.replaceSubrange(range, with: "")
            }
            varArray.append(variable)
            
            guard let nl1 = script.range(of: "\n", options: .caseInsensitive, range: end1.upperBound..<script.endIndex) else {return}
            let valRange = end1.upperBound..<nl1.lowerBound
            var value = script[valRange]
            while let range = value.range(of: " ") {
                value.replaceSubrange(range, with: "")
            }
            while let range = value.range(of: "\"") {
                value.replaceSubrange(range, with: "")
            }
            valArray.append(value)
            begin010 = nl1.upperBound
        }
        
        var begin020 = script.startIndex
        while let begin = script.range(of: "print(\"", options: .caseInsensitive, range: begin020..<script.endIndex) {
            let nextRange = begin.upperBound..<script.endIndex
            guard let end = script.range(of: "\"", options: .caseInsensitive, range: nextRange) else {return}
            let wordRange = begin.upperBound..<end.lowerBound
            begin020 = end.upperBound
            print(script[wordRange])
        }
        
        var begin030 = script.startIndex
        while let begin3 = script.range(of: "print(", options: .caseInsensitive, range: begin030..<script.endIndex) {
            let nextRange3 = begin3.upperBound..<script.endIndex
            guard let end3 = script.range(of: ")", options: .caseInsensitive, range: nextRange3) else {return}
            let printRange = begin3.upperBound..<end3.lowerBound
            let print1 = script[printRange]
            
            for i in 0..<varArray.count {
                if print1 == varArray[i] {
                    print(valArray[i])
                }
            }
            
            begin030 = end3.upperBound
        }

    }
    override func didMove(to view: SKView) {
        guard let path = Bundle.main.path(forResource: "script", ofType: "jump") else {return}
        do {
            let script = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            
            searchFunc(script: script)

            for i in 0..<funcArray.count {
                if funcArray[i] == "main" {
                    funcParse(script: funcScript[i])
                }
            }
            
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

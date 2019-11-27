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
    
    func routine(script:String) {
        guard let begin1 = script.range(of: "var") else {return}
        guard let end1 = script.range(of: "=") else {return}
        let varRange = begin1.upperBound..<end1.lowerBound
        var variable = script[varRange]

        while let range = variable.range(of: " ") {
            variable.replaceSubrange(range, with: "")
        }

        guard let begin = script.range(of: "\"") else {return}
        let nextRange = begin.upperBound..<script.endIndex
        guard let end = script.range(of: "\"", options: .caseInsensitive, range: nextRange) else {return}
        let wordRange = begin.upperBound..<end.lowerBound

        
        guard let begin3 = script.range(of: "print(") else {return}
        let nextRange3 = begin.upperBound..<script.endIndex
        guard let end3 = script.range(of: ")", options: .caseInsensitive, range: nextRange3) else {return}
        let printRange = begin3.upperBound..<end3.lowerBound
        let print1 = script[printRange]
        
        if print1 == variable {
            print(script[wordRange])
        }

    }
    override func didMove(to view: SKView) {
        guard let path = Bundle.main.path(forResource: "script", ofType: "jump") else {return}
        do {
            let script = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            
            var nextRange0 = script.startIndex..<script.endIndex //最初は文字列全体から探す
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


            var funcWords:[String] = []
            for i in 0..<funcScript.count {
                var nextRange1 = funcScript[i].startIndex..<funcScript[i].endIndex
                var begin1 = funcScript[i].startIndex
                while let end1 = funcScript[i].range(of: "()", options: .caseInsensitive, range: nextRange1 ) {
                    let funcRange = begin1..<end1.lowerBound
                    var funcWord = funcScript[i][funcRange]
                    while let range = funcWord.range(of: "\n") {
                        funcWord.replaceSubrange(range, with: "")
                    }
                    while let range = funcWord.range(of: " ") {
                        funcWord.replaceSubrange(range, with: "")
                    }
                    funcWords.append(funcWord.description)

                    nextRange1 = end1.upperBound..<funcScript[i].endIndex
                    begin1 = end1.upperBound
                }
            }
            for funcWord in funcWords {
                for j in 0..<funcArray.count {
                    if funcWord == funcArray[j] {
                        routine(script: funcScript[j])
                    }
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

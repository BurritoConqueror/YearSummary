//
//  GameScene.swift
//  Air Hockey
//
//  Created by 90302781 on 3/6/20.
//  Copyright © 2020 90302781. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var puck = SKShapeNode.init(circleOfRadius: 50)
    var P1 = SKShapeNode.init(circleOfRadius: 50)
    var P2 = SKShapeNode.init(circleOfRadius: 50)
    var P1Hitters = 0
    var P2Hitters = 0
    var Goal2 = SKSpriteNode()
    var Goal1 = SKSpriteNode()
    var SwitchButton = SKSpriteNode()
    var P1Score = 0
    var P2Score = 0
    var P1ScoreLabel = SKLabelNode()
    var P2ScoreLabel = SKLabelNode()
    var LastToScore = 0
    
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = border
        //make border
        
        Goal1.childNode(withName: "goal1")
        Goal1.physicsBody?.collisionBitMask = 0
        
        Goal2.childNode(withName: "goal2")
        Goal2.physicsBody?.collisionBitMask = 0
        
        P1ScoreLabel = self.childNode(withName: "P1ScoreLabel") as! SKLabelNode
        P2ScoreLabel = self.childNode(withName: "P2ScoreLabel") as! SKLabelNode
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if touch.location(in: self).y > 0 && P2Hitters == 0{
                P2.fillColor = UIColor.white
                P2.physicsBody = SKPhysicsBody.init(circleOfRadius: 50)
                P2.physicsBody?.affectedByGravity = false
                P2.physicsBody?.restitution = 1
                P2.physicsBody?.usesPreciseCollisionDetection = true
                P2.position = touch.location(in: self)
                self.addChild(P2)
                P2Hitters = 1
            }else if touch.location(in: self).y < 0 && P1Hitters == 0{
                P1.physicsBody = SKPhysicsBody.init(circleOfRadius: 50)
                P1.fillColor = UIColor.white
                P1.physicsBody?.affectedByGravity = false
                P1.physicsBody?.restitution = 1
                P1.physicsBody?.usesPreciseCollisionDetection = true
                P1.position = touch.location(in: self)
                self.addChild(P1)
                P1Hitters = 1
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if touch.location(in: self).y > 0{
                
                P2.physicsBody?.velocity = (CGVector(dx:(touch.location(in: self).x - P2.position.x) * 15, dy: (touch.location(in: self).y - P2.position.y) * 15))
            }
            else if touch.location(in: self).y  < 0{
                P1.physicsBody?.velocity = (CGVector(dx:(touch.location(in: self).x - P1.position.x) * 20, dy: ((touch.location(in: self).y - P1.position.y)) * 20))
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if touch.location(in: self).y > 0 {
                P2.removeFromParent()
                P2Hitters = 0
            }else if touch.location(in: self).y < 0{
                P1.removeFromParent()
                P1Hitters = 0
            }
        }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.contactTestBitMask == 1 && contact.bodyB.contactTestBitMask == 4 {
            collision(Goal: contact.bodyA.node!, Puck: contact.bodyB.node!)
        }else if contact.bodyA.contactTestBitMask == 2 && contact.bodyB.contactTestBitMask == 4{
            collision(Goal: contact.bodyA.node!, Puck: contact.bodyB.node!)
        }else if contact.bodyA.contactTestBitMask == 4 && contact.bodyB.contactTestBitMask == 1 {
            collision(Goal: contact.bodyB.node!, Puck: contact.bodyA.node!)
        }else if contact.bodyA.contactTestBitMask == 4 && contact.bodyB.contactTestBitMask == 2{
            collision(Goal: contact.bodyB.node!, Puck: contact.bodyA.node!)
        }
    }
    func collision(Goal :SKNode, Puck:SKNode){
        if Goal.physicsBody?.contactTestBitMask == 1 {
            P2Score = P2Score + 1
            P2ScoreLabel.text = "\(P2Score)"
            puck.removeFromParent()
            LastToScore = 2
        }else if Goal.physicsBody?.contactTestBitMask == 2{
            P1Score = P1Score + 1
            P1ScoreLabel.text = "\(P1Score)"
            puck.removeFromParent()
            LastToScore = 1
        }
    }
    override func update(_ currentTime: TimeInterval) {
        if P1.position.y > 0 {
            P1.removeFromParent()
            P1Hitters = 0
        }
        if P2.position.y < 0 {
            P2.removeFromParent()
            P2Hitters = 0
        }
        if LastToScore == 1 {
            puck.position = CGPoint(x: 0, y: 180)
            puck.physicsBody = SKPhysicsBody.init(circleOfRadius: 50)
            puck.physicsBody?.affectedByGravity = false
            puck.physicsBody?.restitution = 1
            puck.physicsBody?.isDynamic = true
            puck.physicsBody?.usesPreciseCollisionDetection = true
            puck.physicsBody?.collisionBitMask = 4
            puck.physicsBody?.contactTestBitMask = 4
            self.addChild(puck)
            LastToScore = 4
        }else if LastToScore == 2{
            puck.position = CGPoint(x: 0, y: -320)
            puck.physicsBody = SKPhysicsBody.init(circleOfRadius: 50)
            puck.physicsBody?.affectedByGravity = false
            puck.physicsBody?.restitution = 1
            puck.physicsBody?.isDynamic = true
            puck.physicsBody?.usesPreciseCollisionDetection = true
            puck.physicsBody?.collisionBitMask = 4
            puck.physicsBody?.contactTestBitMask = 4
            self.addChild(puck)
            LastToScore = 4
        }else if LastToScore == 0{
            puck.position = CGPoint(x: 0, y: 0)
            puck.physicsBody = SKPhysicsBody.init(circleOfRadius: 50)
            puck.physicsBody?.affectedByGravity = false
            puck.physicsBody?.restitution = 1
            puck.physicsBody?.isDynamic = true
            puck.physicsBody?.usesPreciseCollisionDetection = true
            puck.physicsBody?.collisionBitMask = 4
            puck.physicsBody?.contactTestBitMask = 4
            self.addChild(puck)
            LastToScore = 4
        }
        if P1Score == 7 || P2Score == 7 {
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameScene = GameScene(fileNamed: "MenuScene")
            gameScene?.scaleMode = .aspectFill
            scene?.view?.presentScene(gameScene!, transition: transition)
        }
    }
}

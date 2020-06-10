//
//  GameScene.swift
//  PoolTest
//
//  Created by 90302781 on 2/10/20.
//  Copyright © 2020 90302781. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var downTheHole = SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.resize(toWidth: 0, height: 0, duration: 1)])
    
    var originalTouchLocation = CGPoint()
    var movedTouchLocation = CGPoint()
    var label = SKLabelNode()
    var ball = SKSpriteNode()
    var arrow = SKSpriteNode()
    var redBall1 = SKSpriteNode()
    var redBall2 = SKSpriteNode()
    var redBall3 = SKSpriteNode()
    var redBall4 = SKSpriteNode()
    var redBall5 = SKSpriteNode()
    var redBall6 = SKSpriteNode()
    var hole1 = SKSpriteNode()
    var hole2 = SKSpriteNode()
    var hole3 = SKSpriteNode()
    var hole4 = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        label = self.childNode(withName: "label") as! SKLabelNode
        label.fontSize = 24
        ball = self.childNode(withName: "Ball") as! SKSpriteNode
        redBall1 = self.childNode(withName: "redBall1") as! SKSpriteNode
        redBall2 = self.childNode(withName: "redBall2") as! SKSpriteNode
        redBall3 = self.childNode(withName: "redBall3") as! SKSpriteNode
        redBall4 = self.childNode(withName: "redBall4") as! SKSpriteNode
        redBall5 = self.childNode(withName: "redBall5") as! SKSpriteNode
        redBall6 = self.childNode(withName: "redBall6") as! SKSpriteNode
        hole1 = self.childNode(withName: "hole1") as! SKSpriteNode
        hole2 = self.childNode(withName: "hole2") as! SKSpriteNode
        hole3 = self.childNode(withName: "hole3") as! SKSpriteNode
        hole4 = self.childNode(withName: "hole4") as! SKSpriteNode
        hole1.physicsBody!.contactTestBitMask = redBall1.physicsBody!.collisionBitMask
        hole2.physicsBody!.contactTestBitMask = redBall1.physicsBody!.collisionBitMask
        hole3.physicsBody!.contactTestBitMask = redBall1.physicsBody!.collisionBitMask
        hole4.physicsBody!.contactTestBitMask = redBall1.physicsBody!.collisionBitMask
        
        
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = border
        border.restitution = 0.7
        arrow = self.childNode(withName: "arrow") as! SKSpriteNode
        arrow.isHidden = true
        arrow.size.height = 0
        }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if ball.physicsBody?.velocity == CGVector(dx: 0, dy: 0){
        for touch in touches{
            if ball.contains(originalTouchLocation){
                movedTouchLocation = touch.location(in: self)
                arrow.position = ball.position
                if abs(abs(ball.position.x) - abs(touch.location(in: self).x)) > abs(abs(ball.position.y) - abs(touch.location(in: self).y)){
                    arrow.size.height = (arrow.size.height + (ball.position.x - (touch.location(in: self).x)))/2
                    arrow.zRotation = atan((ball.position.y - touch.location(in: self).y)/(ball.position.x - touch.location(in: self).x))
                }else{
                arrow.size.height = (arrow.size.height + (ball.position.y - (touch.location(in: self).y)))/2
                    arrow.zRotation = atan((ball.position.x - touch.location(in: self).x)/(ball.position.y - touch.location(in: self).y))
                }
            }
            }
            
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if physicsBody?.velocity == CGVector(dx: 0, dy: 0){
                
            
            let location = touch.location(in: self)
            if ball.contains(location){
                originalTouchLocation = location
                arrow.position = ball.position
                arrow.isHidden = false
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if ball.contains(originalTouchLocation){
                movedTouchLocation = touch.location(in: self)
                let impulseX = ball.position.x - movedTouchLocation.x
                let impulseY = ball.position.y - movedTouchLocation.y
                ball.physicsBody?.applyImpulse(CGVector(dx: impulseX, dy: impulseY))
                arrow.isHidden = true
                arrow.size.height = 0
            }
        }
    }
    func collision(between :SKNode,object:SKNode){
        if object.physicsBody?.categoryBitMask == 0 {
            label.text = "hi"
            let stopTheHole = SKAction.sequence([downTheHole, SKAction.run {
                between.physicsBody = nil
            }])
            
            between.run(stopTheHole)
            
            
                    }
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 4294967292{
           collision(between: contact.bodyA.node!, object: contact.bodyB.node!)
        }else if contact.bodyB.categoryBitMask == 4294967292{
            collision(between: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    override func update(_ currentTime: TimeInterval) {
        
    }
}

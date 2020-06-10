//
//  MenuScene.swift
//  Air Hockey
//
//  Created by 90302781 on 4/7/20.
//  Copyright © 2020 90302781. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class MenuScene: SKScene {
    var StartButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        StartButton = self.childNode(withName: "StartButton") as! SKSpriteNode
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            if StartButton.contains(touch.location(in: self)) {
              let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                scene?.view?.presentScene(gameScene!, transition: transition)
            }
        }
    }
    
}

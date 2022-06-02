//
//  GameScene.swift
//  pong
//
//  Created by david on 12/14/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var theBall = SKNode()
    var bottom = SKSpriteNode()
    var top = SKSpriteNode()
    var topCol = SKSpriteNode()
    var botCol = SKSpriteNode()
    var fingerOnBottom = false
    var cpuScore = 0
    var myScore = 0
    var scorelabel = SKLabelNode()
    override func didMove(to view: SKView)
    {
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        theBall = self.childNode(withName: "ball")!
        bottom = self.childNode(withName: "bottom") as! SKSpriteNode
        theBall.physicsBody?.mass = 0.5
        theBall.physicsBody?.velocity = CGVector(dx: 500, dy: -500)
        theBall.physicsBody?.friction = 0
        theBall.physicsBody?.categoryBitMask = 1
        topCol.physicsBody?.categoryBitMask = 2
        botCol.physicsBody?.categoryBitMask = 3
        theBall.physicsBody?.contactTestBitMask = 2 | 3
        createTop()
        createCo()
        physicsWorld.contactDelegate = self
    setupLabel()
    }
  
    func setupLabel()
    {
        scorelabel = SKLabelNode(text: "CPU: \(cpuScore)|Player: \(myScore)")
        scorelabel.position = CGPoint(x: frame.width * 0.75, y: frame.height * 0.5)
        scorelabel.position = CGPoint(x: 0, y: 0)
        addChild(scorelabel)
    }
    
    
    func createCo()
    {
        topCol = SKSpriteNode(color: UIColor.black, size: CGSize(width: frame.width, height: 50))
        topCol.position = CGPoint(x: 0, y: 345)
        topCol.physicsBody = SKPhysicsBody(rectangleOf: topCol.frame.size)
        topCol.physicsBody?.isDynamic = false
        topCol.physicsBody?.categoryBitMask = 2
        topCol.name = "topCol"
        
        botCol = SKSpriteNode(color: UIColor.black, size: CGSize(width: frame.width, height: 50))
        botCol.position = CGPoint(x: 0, y: -345)
        botCol.physicsBody = SKPhysicsBody(rectangleOf: topCol.frame.size)
        botCol.physicsBody?.isDynamic = false
        botCol.physicsBody?.categoryBitMask = 3
        botCol.name = "botCol"
        
    
        addChild(botCol)
        addChild(topCol)
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2
        {
            myScore+=1
            resetBall()
        }
        
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1
        {
            myScore+=1
            resetBall()
        }
        
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 3
        {
            cpuScore+=1
            resetBall()
        }
        
        if contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 1
        {
            cpuScore+=1
            resetBall()
        }
        
        
        
       // print(theBall.physicsBody?.velocity)
        scorelabel.text = "CPU: \(cpuScore)|Player: \(myScore)"
        
        
        
        
        
    }
    
    func createTop()
    {
        top = SKSpriteNode(color: UIColor.red, size: CGSize(width: 173.455, height: 34.996))
        top.position = CGPoint(x: 0, y: 302.502)
        top.physicsBody = SKPhysicsBody(rectangleOf: top.size)
        top.physicsBody?.affectedByGravity = false
        top.physicsBody?.allowsRotation = false
        top.physicsBody?.friction = 0
        top.physicsBody?.isDynamic = false
        
        followBall()
        addChild(top)
        
        
        
        run(SKAction.repeatForever(SKAction.sequence(
            [
            SKAction.run(followBall),
            SKAction.wait(forDuration: 0.1)
            ]
        )))
    }
    
    func followBall()
    {
        let move = SKAction.moveTo(x: theBall.position.x, duration: 0.2)
        top.run(move)
    }
    
    
    //-311 is bottom
    //311 is top
    
    
    func resetBall()
    {
        theBall.physicsBody?.velocity = .zero
        let wait = SKAction.wait(forDuration: 1.0)
        
        let sequence = SKAction.sequence([wait, SKAction.run {self.ballCenter()}, wait, SKAction.run {self.push()}])
        run(sequence)
        
        
        
        
        
        
        bottom.position = CGPoint(x: 0, y: -302.502)
        top.position = CGPoint(x: 0, y: 302.502)
    }
    func ballCenter()
    {
        theBall.position = CGPoint(x: 0, y: 0)
    }
    
    
    func push()
    {
        var nums = [-500, 500]
        theBall.physicsBody?.velocity = CGVector(dx: nums.randomElement()!, dy: nums.randomElement()!)
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = touches.first?.location(in: self)
        
        
        if bottom.contains(location!)
        {
            fingerOnBottom = true
        }
        
        if theBall.contains(location!)
        {
            theBall.physicsBody?.velocity = CGVector(dx: -500, dy: -500)
        }
        
        
//        if Int(theBall.position.x) = -165 | Int(theBall.position.x) = 165
//        {
//            theBall.physicsBody?.velocity = CGVector(dx: -500, dy: -500)
//        }
//
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let location = touches.first?.location(in: self)
        
        
        if fingerOnBottom == true
        {
            bottom.position = CGPoint(x: location!.x, y: bottom.position.y)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        fingerOnBottom = false
    }
    
    
    
    
    
    
    
    
    
    
    
    
}

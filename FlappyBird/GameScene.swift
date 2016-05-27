//
//  GameScene.swift
//  FlappyBird
//
//  Created by El Capitan on 13/05/16.
//  Copyright (c) 2016 Order of the Banana. All rights reserved.
//

import SpriteKit

enum Category
{
    static let bird : UInt32 = 0b1
    static let pipes : UInt32 = 0b10
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var birdAtlas : SKTextureAtlas = SKTextureAtlas(named:"player.atlas")
    var birdSprites = [SKTexture]()
    
    var background = SKSpriteNode()
    var floor1 = SKSpriteNode()
    var floor2 = SKSpriteNode()
    
    var lblPontos = SKLabelNode()
    var goal1 = SKShapeNode()
    var goal2 = SKShapeNode()
    
    var bottomPipe1 = SKSpriteNode()
    var bottomPipe2 = SKSpriteNode()
    var topPipe1 = SKSpriteNode()
    var topPipe2 = SKSpriteNode()
    var pipeHeight = CGFloat(200)
    
    var isActive : Bool = false
    var started :Bool = false
	
    
    override func didMoveToView(view: SKView) {
        
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsWorld.contactDelegate = self
        
        background = SKSpriteNode(imageNamed: "background")
        background.anchorPoint = CGPoint(x: 0, y:0)
        background.position = CGPoint(x:100, y:0)
        
        backgroundColor = SKColor(red:0.31, green: 0.75, blue: 0.80, alpha: 1.0)
        addChild(background)
        
        
        CreateBird()
        CreateFloor()
        CreatePipes()
        CreateLabelPontos()
        
        goal1 = CreateGoals(topPipe1, bottom: bottomPipe1)
        goal2 = CreateGoals(topPipe2, bottom: bottomPipe2)
        
    }
    
    private func CreateGoals(top : SKSpriteNode, bottom : SKSpriteNode) -> SKShapeNode
    {
        let goalSize = top.position.y - top.size.height/2 - (bottom.position.y + bottom.size.height/2)
        
        let y = (top.position.y - top.size.height/2)-goalSize/2
        let sizeRec = CGSize(width: top.size.width, height: goalSize)
        let goal = SKShapeNode(rectOfSize: sizeRec)
        goal.fillColor = SKColor.redColor()
        goal.position = CGPoint(x: bottom.position.x,y: y)
        addChild(goal)
        return goal
    }
    
    private func CreateLabelPontos()
    {
        lblPontos = SKLabelNode(fontNamed: "Chalkduster")
        lblPontos.text = "Pontos: 0"
        lblPontos.position = CGPoint(x: size.width - 375, y: size.height - 25)
        lblPontos.fontSize = 18
        lblPontos.fontColor = SKColor.blackColor()
        addChild(lblPontos)
        
    }
    
    private func CreateBird()
    {
        
        birdSprites.append(birdAtlas.textureNamed("player1"))
        birdSprites.append(birdAtlas.textureNamed("player2"))
        birdSprites.append(birdAtlas.textureNamed("player3"))
        birdSprites.append(birdAtlas.textureNamed("player4"))
        
        let animatedBird = SKAction.animateWithTextures(birdSprites, timePerFrame: 0.1)
        let repeatAction = SKAction.repeatActionForever(animatedBird)
        
        bird = SKSpriteNode(texture: birdSprites[0])
        bird.position = CGPoint(x: size.width/2, y: size.height/2)
        bird.size.width = bird.size.width/10
        bird.size.height = bird.size.height/8.5
        bird.runAction(repeatAction)
        addChild(bird)
        
    }
    
    private func CreateFloor()
    {
        
        /*    bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width/2)
        bird.physicsBody?.categoryBitMask = Category.bird
        bird.physicsBody?.contactTestBitMask  = Category.pipes
        bird.physicsBody?.linearDamping = 1.1 */
        
        floor1 = SKSpriteNode(imageNamed:"floor")
        floor1.anchorPoint = CGPointZero
        floor1.position = CGPointZero
        floor1.physicsBody = SKPhysicsBody(edgeLoopFromRect: floor1.frame)
        addChild(floor1)
        
        floor2 = SKSpriteNode(imageNamed:"floor")
        floor2.anchorPoint = CGPointZero
        floor2.position = CGPoint(x: floor1.size.width-1, y:0)
        floor2.physicsBody = SKPhysicsBody(edgeLoopFromRect: floor2.frame)
        addChild(floor2)
    }
    
    private func CreatePhysicsPipe(node : SKSpriteNode)
    {
            node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
            node.physicsBody?.dynamic = false
            node.physicsBody?.categoryBitMask = Category.pipes
            node.physicsBody?.contactTestBitMask = Category.bird
    }
    
    private func CreatePipes()
    {
        /*//Pipe number:
        //Even -> Bottom
        //Uneven -> Top
        
        LowPipe = SKSpriteNode(imageNamed:"bottomPipe")
        UpPipe = SKSpriteNode(imageNamed: "topPipe")
        
        LowPipe.position = CGPoint(x: size.width + LowPipe.size.width, y: size.height/2 + 100)
        UpPipe.position = CGPoint(x: size.width + UpPipe.size.width, y: size.height/2 - 100)
        */
        
        bottomPipe1 = SKSpriteNode(imageNamed: "bottomPipe")
        bottomPipe1.size = CGSize(width:bottomPipe1.size.width/2 ,height:bottomPipe1.size.height/2)
        bottomPipe1.position = CGPoint(x: 	1000, y: 200)
        CreatePhysicsPipe(bottomPipe1)
        
        topPipe1 = SKSpriteNode(imageNamed: "topPipe")
        topPipe1.size = CGSize(width:topPipe1.size.width/2 ,height:topPipe1.size.height/2)
        topPipe1.position = CGPoint(x: 1000, y: 700)
        CreatePhysicsPipe(topPipe1)
        
        
        var auxSize = CGSize(width: bottomPipe1.size.width, height: topPipe1.position.y - (bottomPipe1.position.y + bottomPipe1.size
            .height))
        goal1 = SKShapeNode(rectOfSize: auxSize)
        goal1.fillColor = SKColor.redColor()
        
        
        bottomPipe2 = SKSpriteNode(imageNamed: "bottomPipe")
        bottomPipe2.size = CGSize(width:bottomPipe2.size.width/2 ,height:bottomPipe2.size.height/2)
        bottomPipe2.position = CGPoint(x: 800, y: 200)
        CreatePhysicsPipe(bottomPipe2)
        
        topPipe2 = SKSpriteNode(imageNamed: "topPipe")
        topPipe2.size = CGSize(width:topPipe2.size.width/2 ,height:topPipe2.size.height/2)
        topPipe2.position = CGPoint(x: 800, y: 800)
        CreatePhysicsPipe(topPipe2)
        
        auxSize = CGSize(width: bottomPipe2.size.width, height: topPipe2.position.y - (bottomPipe2.position.y + bottomPipe2.size.height))
        goal2 = SKShapeNode(rectOfSize: auxSize)
        goal2.fillColor = SKColor.redColor()
        
        
        addChild(bottomPipe1)
        addChild(bottomPipe2)
        addChild(topPipe1)
        addChild(topPipe2)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        started = true
        
        if(!isActive)
        {
            isActive = true
            CreateBirdPhysics()}
        
        else
        {
            bird.physicsBody?.applyImpulse(CGVectorMake(0,250))
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        var timer = CFTimeInterval()
        timer += currentTime
        
        UpdatePipes()
        UpdateFloors()
        
    }
    
    private func random(first: CGFloat, _ second: CGFloat) -> CGFloat
    {
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(first - second) + min(first, second);
    }
    
    private func UpdateFloors()
    {
        floor1.position = CGPoint(x:floor1.position.x - 4, y:floor1.position.y)
        floor2.position = CGPoint(x:floor2.position.x - 4	, y: floor2.position.y)
        
        
        if(floor1.position.x + 30 < (-floor1.size.width/2))
        {floor1.position = CGPoint(x: floor2.position.x + floor2.size.width,
            y: floor1.position.y)}
        
        if(floor2.position.x + 30 < (-floor2.size.width/2))
        {floor2.position = CGPoint(x:floor1.position.x + floor1.size.width,
            y: floor2.position.y)}
    }
    
    private func UpdatePipes()
    {
        if(started)
        {
            topPipe1.position = CGPointMake(topPipe1.position.x - 8, 800)
            topPipe2.position = CGPointMake(topPipe2.position.x - 8, 700)
            bottomPipe1.position = CGPointMake(bottomPipe1.position.x - 8, 200)
            bottomPipe2.position = CGPointMake(bottomPipe2.position.x - 8, bottomPipe2.position.y)
            
            goal1.position = CGPointMake(goal1.position.x - 8, goal1.position.y)
            goal2.position = CGPointMake(goal2.position.x - 8, goal2.position.y)
        
            if(bottomPipe1.position.x < -bottomPipe1.size.width + 320)
            {
                bottomPipe1.position = CGPoint(x: bottomPipe2.position.x + bottomPipe2.size.width * 4, y: pipeHeight);
                topPipe1.position  = CGPoint(x: topPipe2.position.x + topPipe2.size.width * 4,y: pipeHeight);
                
                goal1.removeFromParent()
                goal1 = CreateGoals(topPipe1, bottom: bottomPipe1)
            }
            
            if(bottomPipe2.position.x < -bottomPipe2.size.width + 320)
            {
                bottomPipe2.position = CGPoint(x: bottomPipe1.position.x + bottomPipe1.size.width * 4, y: pipeHeight);
                topPipe2.position  = CGPoint(x: topPipe1.position.x + topPipe1.size.width * 4,y: pipeHeight);
                goal2.removeFromParent()
                goal2 = CreateGoals(topPipe2, bottom: bottomPipe2)
            }
            
            if(bottomPipe1.position.x < size.width/2)
            {
                pipeHeight = random(100,240)
                print(pipeHeight)
            }
            
        }
        
    }
    
    private func CreateBirdPhysics()
    {
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width/2)
        bird.physicsBody?.categoryBitMask = Category.bird
        bird.physicsBody?.contactTestBitMask  = Category.pipes
        bird.physicsBody?.linearDamping = 1.1
        
    }
}

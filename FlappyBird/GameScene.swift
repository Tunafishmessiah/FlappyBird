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
    static let bird : UInt32 = 1 << 0
    static let pipes : UInt32 = 1 << 1
    static let goal : UInt32 = 1 << 2
    static let Floor : UInt32 = 1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var birdAtlas : SKTextureAtlas = SKTextureAtlas(named:"player.atlas")
    var birdSprites = [SKTexture]()
    
    var background = SKSpriteNode()
    var floor1 = SKSpriteNode()
    var floor2 = SKSpriteNode()
    
    var lblPontos = SKLabelNode()
    var pontos : Int32 = 0
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
        
        /*print(Category.bird)
        print(Category.Floor)
        print(Category.pipes)
        print(Category.goal)*/
        
    }
    
    private func CreateGoals(top : SKSpriteNode, bottom : SKSpriteNode) -> SKShapeNode
    {
        let goalSize = top.position.y - top.size.height/2 - (bottom.position.y + bottom.size.height/2)
        
        let y = (top.position.y - top.size.height/2)-goalSize/2
        let sizeRec = CGSize(width: top.size.width, height: goalSize)
        let goal = SKShapeNode(rectOfSize: sizeRec)
        goal.fillColor = SKColor.redColor()
        goal.position = CGPoint(x: bottom.position.x,y: y)
        
        goal.physicsBody = SKPhysicsBody(rectangleOfSize: sizeRec)
        goal.physicsBody?.dynamic = false
        goal.physicsBody?.categoryBitMask = Category.goal
        goal.physicsBody?.contactTestBitMask = Category.bird
        goal.physicsBody?.collisionBitMask = 0
        
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
        floor1.physicsBody?.categoryBitMask = Category.Floor
        floor1.physicsBody?.collisionBitMask = Category.bird
        floor1.physicsBody?.contactTestBitMask = Category.bird
        addChild(floor1)
        
        floor2 = SKSpriteNode(imageNamed:"floor")
        floor2.anchorPoint = CGPointZero
        floor2.position = CGPoint(x: floor1.size.width-1, y:0)
        floor2.physicsBody = SKPhysicsBody(edgeLoopFromRect: floor2.frame)
        floor2.physicsBody?.categoryBitMask = Category.Floor
        floor2.physicsBody?.collisionBitMask = Category.bird
        floor2.physicsBody?.contactTestBitMask = Category.bird
        addChild(floor2)
    }
    
    private func CreatePhysicsPipe(node : SKSpriteNode)
    {
            node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
            node.physicsBody?.dynamic = false
            node.physicsBody?.categoryBitMask = Category.pipes
            node.physicsBody?.contactTestBitMask = Category.bird
            node.physicsBody?.collisionBitMask = 0
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
        
        //goal1 = CreateGoals(topPipe1, bottom: bottomPipe1)
        
        bottomPipe2 = SKSpriteNode(imageNamed: "bottomPipe")
        bottomPipe2.size = CGSize(width:bottomPipe2.size.width/2 ,height:bottomPipe2.size.height/2)
        bottomPipe2.position = CGPoint(x: 800, y: 200)
        CreatePhysicsPipe(bottomPipe2)
        
        topPipe2 = SKSpriteNode(imageNamed: "topPipe")
        topPipe2.size = CGSize(width:topPipe2.size.width/2 ,height:topPipe2.size.height/2)
        topPipe2.position = CGPoint(x: 800, y: 800)
        CreatePhysicsPipe(topPipe2)
        
        //goal2 = CreateGoals(topPipe2, bottom: bottomPipe2)
        
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
            bird.physicsBody?.applyImpulse(CGVectorMake(0,150))
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
        floor1.position = CGPoint(x:floor1.position.x - 8, y:floor1.position.y)
        floor2.position = CGPoint(x:floor2.position.x - 8, y: floor2.position.y)
        
        
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
            topPipe1.position = CGPointMake(topPipe1.position.x - 8, topPipe1.position.y)
            topPipe2.position = CGPointMake(topPipe2.position.x - 8, topPipe2.position.y)
            bottomPipe1.position = CGPointMake(bottomPipe1.position.x - 8, bottomPipe1.position.y)
            bottomPipe2.position = CGPointMake(bottomPipe2.position.x - 8, bottomPipe2.position.y)
            
            goal1.position = CGPointMake(goal1.position.x - 8, goal1.position.y)
            goal2.position = CGPointMake(goal2.position.x - 8, goal2.position.y)
            
            if(bottomPipe1.position.x < -bottomPipe1.size.width + 320)
            {
                pipeHeight = random(100,240)
                bottomPipe1.position = CGPoint(x: bottomPipe2.position.x + bottomPipe2.size.width * 4, y: pipeHeight);
                topPipe1.position  = CGPoint(x: topPipe2.position.x + topPipe2.size.width * 4,y: pipeHeight+500);
                
                goal1.removeFromParent()
                goal1 = CreateGoals(topPipe1, bottom: bottomPipe1)
            }
            
            if(bottomPipe2.position.x < -bottomPipe2.size.width + 320)
            {
                pipeHeight = random(100,240)
                bottomPipe2.position = CGPoint(x: bottomPipe1.position.x + bottomPipe1.size.width * 4, y: pipeHeight);
                topPipe2.position  = CGPoint(x: topPipe1.position.x + topPipe1.size.width * 4,y: pipeHeight+500);
                
                goal2.removeFromParent()
                goal2 = CreateGoals(topPipe2, bottom: bottomPipe2)
            }
            
            
            
        }
        
    }
    
    private func CreateBirdPhysics()
    {
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width/2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        bird.physicsBody?.categoryBitMask = Category.bird
        bird.physicsBody?.contactTestBitMask  = Category.pipes | Category.goal | Category.Floor
        bird.physicsBody?.collisionBitMask = Category.pipes
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if(((contact.bodyA.categoryBitMask == Category.bird && contact.bodyB.categoryBitMask == Category.goal) || (contact.bodyB.categoryBitMask == Category.bird && contact.bodyA.categoryBitMask == Category.goal)))
        {
            self.pontos += 1
            lblPontos.text = "Pontos: " + String(self.pontos)
        }
        
        if(((contact.bodyA.categoryBitMask == Category.bird &&
            contact.bodyB.categoryBitMask == Category.pipes) ||
            (contact.bodyB.categoryBitMask == Category.bird &&
                contact.bodyA.categoryBitMask == Category.pipes)))
        {
            //GameOver()
        }
        
        if(((contact.bodyA.categoryBitMask == Category.bird &&
            contact.bodyB.categoryBitMask == Category.Floor) ||
            (contact.bodyB.categoryBitMask == Category.bird &&
                contact.bodyA.categoryBitMask == Category.Floor	)))
        {
            //GameOver()
        }
    }
}

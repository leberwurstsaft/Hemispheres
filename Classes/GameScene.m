//
//  GameScene.m
//  Hemispheres2
//
//  Created by Pit Garbe on 28.01.11.
//  Copyright Pit Garbe 2011. All rights reserved.
//

// Import the interfaces
#import "GameScene.h"
#import "ColorSprite.h"
#import "SolutionButton.h"
#import "BrainController.h"


// GameScene implementation
@implementation GameScene

-(id) init
{
	if((self = [super init])) {
        [[CCDirector sharedDirector] setProjection:CCDirectorProjection3D];

        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"textures.plist"];
        [frameCache addSpriteFramesWithFile:@"tafel-und-palette.plist"];

		[[CCDirector sharedDirector] setAlphaBlending:YES];

        gameLayer = [GameLayer node];
        CCLOG(@"position: %f, %f", gameLayer.position.x, gameLayer.position.y);

        [self addChild: gameLayer];
        gameLayer.tag = 1;
                
        SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
        
        if (sae != nil) {
            [sae preloadEffect:@"ka.caf"];
            [sae preloadEffect:@"ow.caf"];
            [sae preloadEffect:@"pow.caf"];
            [sae preloadEffect:@"pling.caf"];
            [sae preloadEffect:@"timeout.caf"];
        }
        
		gameLayer.isTouchEnabled = NO;

	}
	return self;
}

- (void)setTouchEnabled:(BOOL)_enable {
    CCLOG(@"touch enabled: %@", _enable ? @"YES": @"NO");
    gameLayer.isTouchEnabled = _enable;
}

- (void)showDrapes:(BOOL)_show {
    [gameLayer showDrapes:_show];
}

- (void)showTextBox:(CGPoint)pos size:(CGSize)size text:(NSString*)text {
    [gameLayer showTextBox:pos size:size text:text];
}


@end

@implementation GameLayer

@synthesize lostText;

- (id)init {
    if ((self = [super init])) {
        gameController = [[GameController alloc] init];
		
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            kHitDistance = 66;
            offsetRightSide = 512;
        }
        else {
            kHitDistance = 33;
            offsetRightSide = 240;
        }
        
		CGSize screenSize = [[CCDirector sharedDirector] winSize];

        
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGB565];
        
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"background.plist"];
        
		CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"background"];
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];

		
		background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        
		[self addChild:background z:-1];
        
		
		[self addChild: [gameController view]];
    }
    return self;
}

- (void)showTextBox:(CGPoint)pos size:(CGSize)size text:(NSString*)text {
    [self removeChildByTag:101 cleanup:YES];
    
    TextBoxLayer *textLayer = [[TextBoxLayer alloc] initWithColor:ccc4(0, 0, 0, 140) width:size.width height:size.height padding:0 text:text];
    textLayer.delegate = self;
    textLayer.contentSize = size;
    textLayer.anchorPoint = ccp(0.5, 0.5);
    textLayer.position = pos;
    
    self.lostText = textLayer;
    
    [self addChild: lostText z:10 tag:101];
    [textLayer release];
    CCLOG(@"start scheduler");
    [self schedule:@selector(gameLoop:) interval:1/60.0f];

}

- (void)gameLoop:(ccTime)dT {
    [lostText update:dT];
}

-(void) textBox:(TextBoxLayer *)tbox didFinishAllTextWithPageCount:(int)pc {
    [self unschedule:@selector(gameLoop:)];
	[self removeChild:lostText cleanup:YES];
    [gameController continueTraining];
}

- (CGPoint)locationFromTouch:(UITouch *)touch {
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    BOOL gameRunning = [gameController gameRunning];
    BOOL trainingRunning = [gameController trainingRunning];
    int trainingType = [gameController trainingToRun];
    
    if ([touches count] == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [self locationFromTouch:touch];

        for (int i = 0; i < 3; i++) {
            if (ccpDistance([[gameController.leftBrainController.view getChildByTag:i] position], touchLocation) < kHitDistance) {
                if ((trainingRunning && trainingType == kNumberTrainingType) || gameRunning) {
                    [gameController.leftBrainController effect: i];
                    [gameController.leftBrainController evaluate: i];
                }
            }
            else if (ccpDistance(ccpAdd([[gameController.rightBrainController.view getChildByTag:i] position], ccp(offsetRightSide, 0)), touchLocation) < kHitDistance) {
                if ((trainingRunning && trainingType == kColorTrainingType) || gameRunning) {
                    [gameController.rightBrainController effect: i];
                    [gameController.rightBrainController evaluate: i];
                }
            }
        }
    }
    else if ([touches count] == 2) {
        CCLOG(@"2 touches!");

        BOOL firstTouchWasLeft = NO;
        BOOL firstTouchWasRight = NO;
        
        for (int i = 0; i < 2; i++) {
            UITouch *touch = [[touches allObjects] objectAtIndex:i];
            CGPoint touchLocation = [self locationFromTouch:touch];

            for (int i = 0; i < 3; i++) {
                if (ccpDistance([[gameController.leftBrainController.view getChildByTag:i] position], touchLocation) < kHitDistance && !firstTouchWasLeft) {
                    CCLOG(@"hit left: %d", i);
                    if ((trainingRunning && trainingType == kNumberTrainingType) || gameRunning) {
                        firstTouchWasLeft = YES;
                        [gameController.leftBrainController effect: i];
                        [gameController.leftBrainController evaluate: i];
                    }
                    break;
                }
                else if (ccpDistance(ccpAdd([[gameController.rightBrainController.view getChildByTag:i] position], ccp(offsetRightSide, 0)), touchLocation) < kHitDistance && !firstTouchWasRight) {
                    if ((trainingRunning && trainingType == kColorTrainingType) || gameRunning) {
                        CCLOG(@"hit right: %d", i);
                        firstTouchWasRight = YES;
                        [gameController.rightBrainController effect: i];
                        [gameController.rightBrainController evaluate: i];
                    }
                    break;
                }
            }
        }
    }
}

- (void)onEnterTransitionDidFinish {
     BOOL tutorialFinished = [[NSUserDefaults standardUserDefaults] boolForKey:@"HemispheresTutorialFinished"];
    if (!tutorialFinished) {
        [gameController runNumberTraining: 10];
    }
    else {
        [gameController animate];
    }
}

- (void)showDrapes:(BOOL)_show {
    [gameController showDrapes:_show];
}

- (void)dealloc {
    CCLOG(@"dealloc GameLayer");
    [lostText release];
    [gameController release];
    [super dealloc];
}

@end
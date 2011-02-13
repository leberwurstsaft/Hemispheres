//
//  GameScene.m
//  Hemispheres2
//
//  Created by Pit Garbe on 28.01.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "GameScene.h"
#import "ColorSprite.h"
#import "SolutionButton.h"
#import "BrainController.h"

#define kHitDistance 33

// GameScene implementation
@implementation GameScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	
	GameScene *layer = [GameScene node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self = [super init] )) {
        
        SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
        if (sae != nil) {
            [sae preloadEffect:@"ka.caf"];
            [sae preloadEffect:@"ow.caf"];
            [sae preloadEffect:@"pow.caf"];
            [sae preloadEffect:@"pling.caf"];
            [sae preloadEffect:@"timeout.caf"];
        }
        
		brightness = 205;
		
		[[CCDirector sharedDirector] setAlphaBlending:YES];
		
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"textures.plist"];
		
		gameController = [[GameController alloc] init];
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];

		CCSprite* background = [CCSprite spriteWithFile:@"background.png"]; // rect:CGRectMake(0, 0, 480, 320)];
        background.scale = 0.5;

//		ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
//		[[background texture] setTexParameters: &params];
  //      background.color = ccc3(55, 55, 055);
		
		background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
		
		
//		CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(brightness, brightness, 0, 255)];
//		[background setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
//		[self addChild:colorLayer z:-2 tag:10];

		[self addChild:background z:-1];

		
		[self addChild: [gameController view]];
		
        /*
		[CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
		[CCMenuItemFont setFontSize:16];
		
		CCMenuItemFont *item1 = [CCMenuItemFont itemFromString:@"GL_DIES" target:self selector:@selector(menuItem1Touched:)];
		item1.tag = 71;
		CCMenuItemFont *item2 = [CCMenuItemFont itemFromString:@"GL_DAS" target:self selector:@selector(menuItem2Touched:)];
		item2.tag = 72;
		CCMenuItemFont *item3 = [CCMenuItemFont itemFromString:@"heller" target:self selector:@selector(menuItem3Touched:)];
		item3.tag = 73;
		CCMenuItemFont *item4 = [CCMenuItemFont itemFromString:@"dunkler" target:self selector:@selector(menuItem4Touched:)];
		item4.tag = 74;

		CCMenu* menu = [CCMenu menuWithItems: item3, item4, nil];
		menu.tag = 70;
		
		menu.position = CGPointMake(screenSize.width / 2, 280);
		[self addChild:menu];
	//	[menuLayer setIsTouchEnabled: YES];
		[menu alignItemsVerticallyWithPadding:10];
		[menu alignItemsInColumns: [NSNumber numberWithInt: 2], nil];*/
		
		self.isTouchEnabled = YES;
		

	}
	return self;
}



/*
- (void)menuItem1Touched:(CCMenuItem *)sender {
	blendFunc++;
	blendFunc = blendFunc % 8;
	[self updateGLBlendFunction];
}

- (void)menuItem2Touched:(CCMenuItem *)sender {
	blendFunc2++;
	blendFunc2 = blendFunc2 % 8;	
	[self updateGLBlendFunction];
}

- (void)updateGLBlendFunction {
	int blendFuncOne;
	int blendFuncTwo;
	NSString *blendFuncOneString;
	NSString *blendFuncTwoString;
	
	switch (blendFunc) {
		case 0:
			blendFuncOne = GL_ZERO;
			blendFuncOneString = @"GL_ZERO";
			break;
		case 1:
			blendFuncOne = GL_ONE;
			blendFuncOneString = @"GL_ONE";
			break;
		case 2:
			blendFuncOne = GL_SRC_COLOR;
			blendFuncOneString = @"GL_SRC_COLOR";
			break;
		case 3:
			blendFuncOne = GL_ONE_MINUS_SRC_COLOR;
			blendFuncOneString = @"GL_ONE_MINUS_SRC_COLOR";
			break;
		case 4:
			blendFuncOne = GL_SRC_ALPHA;
			blendFuncOneString = @"GL_SRC_ALPHA";
			break;
		case 5:
			blendFuncOne = GL_ONE_MINUS_SRC_ALPHA;
			blendFuncOneString = @"GL_ONE_MINUS_SRC_ALPHA";
			break;
		case 6:
			blendFuncOne = GL_DST_ALPHA;
			blendFuncOneString = @"GL_DST_ALPHA";
			break;
		case 7:
			blendFuncOne = GL_ONE_MINUS_DST_ALPHA;
			blendFuncOneString = @"GL_ONE_MINUS_DST_ALPHA";
			break;
		default:
			break;
	}
	
	switch (blendFunc2) {
		case 0:
			blendFuncTwo = GL_ZERO;
			blendFuncTwoString = @"GL_ZERO";
			break;
		case 1:
			blendFuncTwo = GL_ONE;
			blendFuncTwoString = @"GL_ONE";
			break;
		case 2:
			blendFuncTwo = GL_SRC_COLOR;
			blendFuncTwoString = @"GL_SRC_COLOR";
			break;
		case 3:
			blendFuncTwo = GL_ONE_MINUS_SRC_COLOR;
			blendFuncTwoString = @"GL_ONE_MINUS_SRC_COLOR";
			break;
		case 4:
			blendFuncTwo = GL_SRC_ALPHA;
			blendFuncTwoString = @"GL_SRC_ALPHA";
			break;
		case 5:
			blendFuncTwo = GL_ONE_MINUS_SRC_ALPHA;
			blendFuncTwoString = @"GL_ONE_MINUS_SRC_ALPHA";
			break;
		case 6:
			blendFuncTwo = GL_DST_ALPHA;
			blendFuncTwoString = @"GL_DST_ALPHA";
			break;
		case 7:
			blendFuncTwo = GL_ONE_MINUS_DST_ALPHA;
			blendFuncTwoString = @"GL_ONE_MINUS_DST_ALPHA";
			break;
		default:
			break;
	}
	
	[[NSUserDefaults standardUserDefaults] setInteger:blendFuncOne forKey:@"HemiBlendFuncOne"];
	[[NSUserDefaults standardUserDefaults] setInteger:blendFuncTwo forKey:@"HemiBlendFuncTwo"];
	
	[self removeChildByTag:70 cleanup:YES];
	
	[CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
	[CCMenuItemFont setFontSize:16];
	
	CCMenuItemFont *item1 = [CCMenuItemFont itemFromString:blendFuncOneString target:self selector:@selector(menuItem1Touched:)];
	item1.tag = 71;
	CCMenuItemFont *item2 = [CCMenuItemFont itemFromString:blendFuncTwoString target:self selector:@selector(menuItem2Touched:)];
	item2.tag = 72;
	CCMenuItemFont *item3 = [CCMenuItemFont itemFromString:@"heller" target:self selector:@selector(menuItem3Touched:)];
	item3.tag = 73;
	CCMenuItemFont *item4 = [CCMenuItemFont itemFromString:@"dunkler" target:self selector:@selector(menuItem4Touched:)];
	item4.tag = 74;
	
	CCMenu* menu = [CCMenu menuWithItems:item1, item2, item3, item4, nil];
	menu.tag = 70;
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];

	menu.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
	[self addChild:menu];
	//	[menuLayer setIsTouchEnabled: YES];
	[menu alignItemsVerticallyWithPadding:10];
	[menu alignItemsInColumns:[NSNumber numberWithInt: 2], [NSNumber numberWithInt: 2], nil];
}


- (void)menuItem3Touched:(CCMenuItem *)sender {
	brightness += 20;
	if (brightness > 255)
		brightness = 255;
    CCLOG(@"brightness: %d", brightness);
	[(CCLayerColor *)[self getChildByTag:10] setColor:ccc3(brightness, brightness, brightness)];	
}

- (void)menuItem4Touched:(CCMenuItem *)sender {
	brightness -= 20;
	if (brightness < 0)
		brightness = 0;
    CCLOG(@"brightness: %d", brightness);
	[(CCLayerColor *)[self getChildByTag:10] setColor:ccc3(brightness, brightness, brightness)];
}



- (void)registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
													 priority:INT_MIN+1 
											  swallowsTouches:YES];
}*/

- (CGPoint)locationFromTouch:(UITouch *)touch {
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	CGPoint touchLocation = [self locationFromTouch:touch];

	for (int i = 0; i < 3; i++) {
		if (ccpDistance([[gameController.leftBrainController.view getChildByTag:i] position], touchLocation) < kHitDistance) {
			[gameController.leftBrainController effect: i];
			[gameController.leftBrainController evaluate: i];
		}
		else if (ccpDistance(ccpAdd([[gameController.rightBrainController.view getChildByTag:i] position], ccp(240,0)), touchLocation) < kHitDistance) {
			[gameController.rightBrainController effect: i];
			[gameController.rightBrainController evaluate: i];
		}
	}
}


@end

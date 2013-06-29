//
//  LeftBrainController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import "LeftBrainController.h"
#import "LeftBrainModel.h"
#import "NumberSprite.h"
#import "SolutionButton.h"

#define kHemiBoardRotation -8

@implementation LeftBrainController

- (id)init {
	if ((self = [super init])) {
		model = [[LeftBrainModel alloc] init];
		
        isLeftController = YES;
        
        CCSprite *tafel = [CCSprite spriteWithSpriteFrameName:@"tafel"];
        tafel.anchorPoint = ccp(0, 0.5);
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            tafel.position = ccp(12, 260);
        }
        else {
            tafel.position = ccp(6, 100);
        }
        tafel.rotation = -8.0;
        [view addChild: tafel z:0];
        
        flashingView = [CCSprite spriteWithSpriteFrameName:@"flash"];
        flashingView2 = [CCSprite spriteWithSpriteFrameName:@"flash"];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            flashingView.position = ccp(150, 150);
            flashingView2.position = ccp(150, 518);
        }
        else {
            flashingView.position = ccp(75, 75);
            flashingView2.position = ccp(75, 201);
        }

        flashingView.opacity = 0;
        flashingView.visible = NO;
        [view addChild:flashingView];

        flashingView2.rotation = 90;
        [flashingView addChild: flashingView2];

        
		left = [NumberSprite sprite];

		right = [NumberSprite sprite];
        
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
		operation = [CCLabelBMFont labelWithString:[model operation] fntFile:@"numberfont.fnt"];
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];

        left.rotation = kHemiBoardRotation;
        [left setSolution: [model left]];
		[view addChild:left z:2];
		
        right.rotation = kHemiBoardRotation;
		[right setSolution: [model right]];
		[view addChild:right z:2];
		
        operation.rotation = kHemiBoardRotation;
		[view addChild: operation z:2];
        
        timer = [TimerNode node];
        timer.controller = self;
        timer.rotation = kHemiBoardRotation;
        [view addChild: timer];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            left.position = ccp(88, 450);
            right.position = ccp(360, 500);
            operation.position = ccp (230, 475);
            timer.position = ccp(2*122, 2*140);
        }
        else {
            left.position = ccp(48, 210);
            right.position = ccp(182, 230);
            operation.position = ccp (116, 220);
            timer.position = ccp(122, 140);
        }
        
       
        NSArray *solutions = [model possibleSolutions];

		solutionButtons = [[NSMutableArray alloc] init];
		for (int i = 0; i < 3; i++) {
			SolutionButton *button = [[SolutionButton alloc] initWithNumber];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                button.representation.position = ccp(130 + i * 148, 92 + i * 22);
            }
            else {
                button.representation.position = ccp(60 + i * 74, 46 + i * 11);
            }
			[button setSolution: [[solutions objectAtIndex:i] intValue]];
            
			[button.representation setTag: i];

            button.representation.rotation = kHemiBoardRotation;
			[view addChild: button.representation z:2];
            [button initParticleSystem];
            
			[solutionButtons addObject: button];
			[button release];
		}
    }
	return self;
}
		
@end

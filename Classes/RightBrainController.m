//
//  RightBrainController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import "RightBrainController.h"
#import "RightBrainModel.h"
#import "ColorSprite.h"
#import "SolutionButton.h"

@implementation RightBrainController

- (id)init {
	if ((self = [super init])) {
		
		model = [[RightBrainModel alloc] init];
        
        isLeftController = NO;
        
        
        CCSprite *palette = [CCSprite spriteWithSpriteFrameName:@"palette"];
        palette.anchorPoint = ccp(0, 0.5);
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            palette.position = ccp(-12, 280);
        }
        else {
            palette.position = ccp(-6, 120);
        }
        [view addChild: palette z:0];
        
        flashingView = [CCSprite spriteWithSpriteFrameName:@"flash"];
        flashingView2 = [CCSprite spriteWithSpriteFrameName:@"flash"];

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            flashingView.position = ccp(362, 150);
            flashingView2.position = ccp(150, 518);
        }
        else {
            flashingView.position = ccp(165, 75);
            flashingView2.position = ccp(75, 201);
        }
        flashingView.flipX = YES;
        flashingView.opacity = 0;
        flashingView.visible = NO;
        [view addChild:flashingView];
        
        flashingView2.flipX = YES;
        flashingView2.rotation = -90;
        [flashingView addChild: flashingView2];
        
		left = [ColorSprite sprite];
		right = [ColorSprite sprite];

        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
        operation = [CCLabelBMFont labelWithString:@"+" fntFile:@"numberfont.fnt"];
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];


		[left setSolution: [model left]];
		[view addChild:left z:2];
        
        [left.texture setAliasTexParameters];
		
        operation.rotation = -10;
        operation.scale = 0.8;
        
		[view addChild: operation z:2];
		
		[right setSolution: [model right]];
		[view addChild:right z:2];
		
        timer = [TimerNode node];
        timer.controller = self;
        [view addChild: timer z:2];
        [timer setTimerImage:@"timer2.png"];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            operation.position = ccp (255, 455);
            left.position = ccp(145, 418);
            right.position = ccp(355, 492);
            timer.position = ccp(250, 270);
        }
        else {
            operation.position = ccp (135, 222);
            left.position = ccp(85, 208);
            right.position = ccp(183, 238);
            timer.position = ccp(124 , 133);
        }

        NSArray *solutions = [model possibleSolutions];
        
		solutionButtons = [[NSMutableArray alloc] init];
		for (int i = 0; i < 3; i++) {
			SolutionButton *button = [[SolutionButton alloc] initWithColor];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                switch (i) {
                    case 0:
                        button.representation.position = ccp(97, 150);
                        break;
                    case 1:
                        button.representation.position = ccp(246, 96);
                        break;
                    case 2:
                        button.representation.position = ccp(392, 132);
                        break;
                        
                    default:
                        break;
                }
            }
            else {
                switch (i) {
                    case 0:
                        button.representation.position = ccp(44, 75);
                        break;
                    case 1:
                        button.representation.position = ccp(120, 48);
                        break;
                    case 2:
                        button.representation.position = ccp(194, 66);
                        break;
                        
                    default:
                        break;
                }
            }
            
			[button setSolution: [[solutions objectAtIndex: i] intValue]];
			[button.representation setTag: i];
			[view addChild: button.representation z:2];
            [button initParticleSystem];
			[solutionButtons addObject: button];
			[button release];
		}
	}
	return self;
}

@end

//
//  RightBrainController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
        palette.position = ccp(-6, 120);
        [view addChild: palette z:0];
        
        flashingView = [CCSprite spriteWithSpriteFrameName:@"flash"];
        flashingView.position = ccp(120,160);
        flashingView.flipX = YES;
        flashingView.opacity = 0;
        flashingView.visible = NO;
        [view addChild:flashingView];
        
		left = [ColorSprite sprite];
		right = [ColorSprite sprite];
        operation = [CCLabelBMFont labelWithString:@"+" fntFile:@"numberfont.fnt"];

		left.position = ccp(85, 208);
		[left setSolution: [model left]];
		[view addChild:left z:2];
        
        [left.texture setAliasTexParameters];
		
        operation.position = ccp (135, 222);
        operation.rotation = -10;
        operation.scale = 0.8;
        
		[view addChild: operation z:2];
		
        right.position = ccp(183, 238);
		[right setSolution: [model right]];
		[view addChild:right z:2];
		
        timer = [TimerNode node];
        timer.position = ccp(124 , 133);
        timer.controller = self;
        [view addChild: timer z:2];
        [timer setTimerImage:@"timer2.png"];

        NSArray *solutions = [model possibleSolutions];
        
		solutionButtons = [[NSMutableArray alloc] init];
		for (int i = 0; i < 3; i++) {
			SolutionButton *button = [[SolutionButton alloc] initWithColor];
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

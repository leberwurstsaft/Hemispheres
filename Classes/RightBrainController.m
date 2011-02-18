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

#define		RAND_1_12	arc4random() % 12

@implementation RightBrainController

- (id)init {
	if ((self = [super init])) {
		
		model = [[RightBrainModel alloc] init];
        
        isLeftController = NO;
        
        
        CCSprite *palette = [CCSprite spriteWithFile:@"palette.png"];
        palette.anchorPoint = ccp(0, 0.5);
        palette.position = ccp(-6, 120);
        [view addChild: palette];
        
        flashingView = [CCSprite spriteWithSpriteFrameName:@"flash"];
        flashingView.position = ccp(120,160);
        flashingView.flipX = YES;
        flashingView.opacity = 0;
        [view addChild:flashingView];
        
		left = [ColorSprite sprite];
		right = [ColorSprite sprite];
        operation = [CCLabelBMFont labelWithString:@"+" fntFile:@"numberfont.fnt"];

		left.position = ccp(85, 208);
		[left setSolution: RAND_1_12];
		[view addChild:left z:2];
		
        operation.position = ccp (138, 222);
		[view addChild: operation z:2];
		
        right.position = ccp(180, 238);
		[right setSolution: RAND_1_12];
		[view addChild:right z:2];
		
		/*timerView = [[TimerView alloc] init];
        timerView.controller = self;
		timerView.view.position = ccp(122, 135);
		[timerView.view setScaleX: -1.0]; 
		[view addChild: timerView.view];*/
		
        timer = [TimerNode node];
        timer.position = ccp(124, 135);
        timer.controller = self;
        [view addChild: timer];
        [timer setTimerImage:@"timer2.png"];

        
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
			[button setSolution: RAND_1_12];
			[button.representation setTag: i];
			[view addChild: button.representation z:2];
			[solutionButtons addObject: button];
			[button release];
		}
	}
	return self;
}

@end

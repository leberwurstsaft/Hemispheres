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
        
        flashingView = [CCSprite spriteWithSpriteFrameName:@"flash"];
        flashingView.position = ccp(120,160);
        flashingView.flipX = YES;
        flashingView.opacity = 0;
        [view addChild:flashingView];
        
		left = [ColorSprite sprite];
		right = [ColorSprite sprite];
        operation = [CCLabelBMFont labelWithString:@"+" fntFile:@"numberfont.fnt"];

		left.position = ccp(50, 210);
		[left setSolution: RAND_1_12];
		[view addChild:left z:2];
		
		right.position = ccp(190, 210);
		[right setSolution: RAND_1_12];
		[view addChild:right z:2];
		
        operation.position = ccp (116, 210);
		[view addChild: operation z:2];
        
        score = [CCLabelBMFont labelWithString:@"0" fntFile:@"scorefont.fnt"];
        score.anchorPoint = ccp(1.0, 0.5);
        score.position = ccp(220, 285);
        [view addChild:score];
        
		timerView = [[TimerView alloc] init];
		timerView.view.position = ccp(100, 135);
		[timerView.view setScaleX: -1]; 
		[view addChild: timerView.view];
		[timerView countdown: [NSNumber numberWithFloat: 8.0]];
		
		solutionButtons = [[NSMutableArray alloc] init];
		for (int i = 0; i < 3; i++) {
			SolutionButton *button = [[SolutionButton alloc] initWithColor];
			button.representation.position = ccp(44 + i * 76, 60);
			[button setSolution: RAND_1_12];
			[button.representation setTag: i];
			[view addChild: button.representation z:2];
			[solutionButtons addObject: button];
			[button release];
		}
	}
	return self;
}



- (void)dealloc {
	for (SolutionButton *button in solutionButtons) {
		[button release];
	}
	[solutionButtons release];
	[model release];
	
	[super dealloc];
}

@end

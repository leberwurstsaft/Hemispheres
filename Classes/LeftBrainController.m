//
//  LeftBrainController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LeftBrainController.h"
#import "LeftBrainModel.h"
#import "NumberSprite.h"
#import "SolutionButton.h"

@implementation LeftBrainController

- (id)init {
	if ((self = [super init])) {
		model = [[LeftBrainModel alloc] init];
		
        isLeftController = YES;
        
        flashingView = [CCSprite spriteWithSpriteFrameName:@"flash"];
        flashingView.position = ccp(120,160);
        flashingView.opacity = 0;
        [view addChild:flashingView];
        
		left = [NumberSprite sprite];
		right = [NumberSprite sprite];
		operation = [CCLabelBMFont labelWithString:@"-" fntFile:@"numberfont.fnt"];

		left.position = ccp(50, 210);
		[left setSolution: 0];
		[view addChild:left z:2];
		
		right.position = ccp(190, 210);
		[right setSolution: 7];
		[view addChild:right z:2];
		
		operation.position = ccp (120, 210);
		[view addChild: operation z:2];
        
        score = [CCLabelBMFont labelWithString:@"0" fntFile:@"scorefont.fnt"];
        score.anchorPoint = ccp(0.0, 0.5);
        score.position = ccp(20, 285);
        [view addChild:score];
		
		timerView = [[TimerView alloc] init];
		timerView.view.position = ccp(100, 135);
		[view addChild: timerView.view];
		[timerView countdown: [NSNumber numberWithFloat: 8.0]];
		
		solutionButtons = [[NSMutableArray alloc] init];
		for (int i = 0; i < 3; i++) {
			SolutionButton *button = [[SolutionButton alloc] initWithNumber];
			button.representation.position = ccp(44 + i * 76, 60);
			[button setSolution: i];
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

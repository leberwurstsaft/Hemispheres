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

#define kHemiBoardRotation -8

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
        left.opacity = 220;

		right = [NumberSprite sprite];
        right.opacity = 220;
        
		operation = [CCLabelBMFont labelWithString:@"-" fntFile:@"numberfont.fnt"];
        operation.opacity = 220;

		left.position = ccp(48, 210);
        left.rotation = kHemiBoardRotation;
        
		[left setSolution: 0];
		[view addChild:left z:2];
		
		right.position = ccp(182, 230);
        right.rotation = kHemiBoardRotation;
		[right setSolution: 7];
		[view addChild:right z:2];
		
		operation.position = ccp (116, 220);
        operation.rotation = kHemiBoardRotation;
		[view addChild: operation z:2];
        
        score = [CCLabelBMFont labelWithString:@"0" fntFile:@"scorefont.fnt"];
        //score.anchorPoint = ccp(0.0, 0.5);
        score.position = ccp(123, 285);
        [view addChild:score];
		
		timerView = [[TimerView alloc] init];
		timerView.view.position = ccp(122, 135);
		[view addChild: timerView.view];
		
		solutionButtons = [[NSMutableArray alloc] init];
		for (int i = 0; i < 3; i++) {
			SolutionButton *button = [[SolutionButton alloc] initWithNumber];
			button.representation.position = ccp(50 + i * 76, 48 + i * 11);
			[button setSolution: i];
            button.representation.opacity = 220;
			[button.representation setTag: i];
            button.representation.rotation = kHemiBoardRotation;
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

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
        
        CCSprite *tafel = [CCSprite spriteWithFile:@"tafel.png"];
        tafel.anchorPoint = ccp(0, 0.5);
        tafel.position = ccp(6, 100);
        tafel.rotation = -8.0;
        [view addChild: tafel];
        
        flashingView = [CCSprite spriteWithSpriteFrameName:@"flash"];
        flashingView.position = ccp(120,160);
        flashingView.opacity = 0;
        [view addChild:flashingView];
        
		left = [NumberSprite sprite];
        //left.opacity = 220;

		right = [NumberSprite sprite];
        //right.opacity = 220;
        
		operation = [CCLabelBMFont labelWithString:@"-" fntFile:@"numberfont.fnt"];
        //operation.opacity = 220;

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
        
		/*timerView = [[TimerView alloc] init];
        timerView.controller = self;
		timerView.view.position = ccp(122, 135); */

        
        timer = [TimerNode node];
        timer.position = ccp(122, 140);
        timer.controller = self;
        timer.rotation = kHemiBoardRotation;
        [view addChild: timer];

        /* perspective !
        float x, y, z;
        [[view camera] eyeX:&x eyeY:&y eyeZ:&z];
		[[view camera] setEyeX:x-50 eyeY:y eyeZ:z];	
        */
        
		solutionButtons = [[NSMutableArray alloc] init];
		for (int i = 0; i < 3; i++) {
			SolutionButton *button = [[SolutionButton alloc] initWithNumber];
			button.representation.position = ccp(60 + i * 74, 46 + i * 11);
			[button setSolution: i];
            
			[button.representation setTag: i];

            button.representation.rotation = kHemiBoardRotation;
			[view addChild: button.representation z:2];
			[solutionButtons addObject: button];
			[button release];
		}
    }
	return self;
}
		
@end

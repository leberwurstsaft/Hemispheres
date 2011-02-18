//
//  TimerView.m
//  Hemispheres2
//
//  Created by Pit Garbe on 06.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimerView.h"
#import "BrainController.h"

@interface TimerView() 
- (void)stopActions;
- (void)resumeActions;
@end

@implementation TimerView

@synthesize view, controller;

- (id)init {
	if ((self = [super init])) {
		view = [CCNode node];
        
        
        timerBorder = [CCSprite spriteWithFile:@"timerbar.png"];
        timerBorder.position = ccp(0.0, -1.0);
        timerBorder.color = ccc3(178, 178, 178);
        [view addChild: timerBorder];
        
		middlePart = [CCSprite spriteWithFile:@"timer_middle.png"];
        
		middlePart.anchorPoint = ccp(1.0, 0.5);
		middlePart.position = ccp(67.5, 0.0);
		[middlePart setColor: ccc3(0, 255, 0)];
		
		leftPart = [CCSprite spriteWithFile:@"timer_cap.png"];
		rightPart = [CCSprite spriteWithFile:@"timer_cap.png"];
		[leftPart setColor: ccc3(0, 255, 0)];
		[rightPart setColor: ccc3(0, 255, 0)];
		
		leftPart.anchorPoint = ccp(1.0, 0.5);
		leftPart.position = ccp(-67, 0);
		
		rightPart.anchorPoint = ccp(0.0, 0.5);
		rightPart.position = ccp(67, 0);
        rightPart.flipX = YES;
		
		circle = [CCSprite spriteWithFile:@"circle.png"];
		circle.position = ccp(67, 0);
		circle.visible = NO;
		[circle setColor: ccc3(255, 0, 0)];
        
        [view addChild: leftPart];
		[view addChild: rightPart];
		[view addChild: middlePart];
		[view addChild: circle];

        
        CCSprite *timerBorderGlass = [CCSprite spriteWithFile:@"timerbar_glass.png"];
        timerBorderGlass.position = ccp(0.0, 0.0);
        timerBorderGlass.scaleX = 1.05;
        timerBorderGlass.opacity = 130;
        timerBorderGlass.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE};
        [view addChild: timerBorderGlass];
        
	//	[self setPercentage: 100.0];
	}
	return self;
}

- (void)countdown:(NSNumber *)_time {
	CCLOG(@"countdown!");

	[self reset];

	
	float time = [_time floatValue];
	float timeOne = 9.5 * time / 10;
	float timeTwo = time - timeOne;
	
	CCScaleTo *shrink = [CCScaleTo actionWithDuration: timeOne scaleX: 2.0/135.0 scaleY:1.0];
	CCMoveTo *move = [CCMoveBy actionWithDuration: timeOne position: ccp(133, 0)];
	
	CCScaleTo *scaleCircle = [CCScaleTo actionWithDuration: timeTwo scale: 0.0];
	CCFadeOut *fadeOut = [CCFadeOut actionWithDuration: timeTwo];
	CCSpawn *disappear = [CCSpawn actions: scaleCircle, fadeOut, nil]; 
	
	CCTintTo *tintYellow = [CCTintTo actionWithDuration:timeOne / 2.0 red:255 green:255 blue:0];
	CCTintTo *tintYellow2 = [CCTintTo actionWithDuration:timeOne / 2.0 red:255 green:255 blue:0];
	CCTintTo *tintYellow3 = [CCTintTo actionWithDuration:timeOne / 2.0 red:255 green:255 blue:0];

	CCTintTo *tintRed = [CCTintTo actionWithDuration:timeOne / 2.0 red:255 green:0 blue:0];
	CCTintTo *tintRed2 = [CCTintTo actionWithDuration:timeOne / 2.0 red:255 green:0 blue:0];
	CCTintTo *tintRed3 = [CCTintTo actionWithDuration:timeOne / 2.0 red:255 green:0 blue:0];
	
	CCSequence *tint1 = [CCSequence actions: tintYellow, tintRed, nil];
	CCSequence *tint2 = [CCSequence actions: tintYellow2, tintRed2, nil];
	CCSequence *tint3 = [CCSequence actions: tintYellow3, tintRed3, nil];
	
	CCSpawn *shrinkTint = [CCSpawn actions: shrink, tint1, nil];
	CCSpawn *moveTint = [CCSpawn actions: move, tint2, nil];
	
	[leftPart runAction: [CCSequence actions: moveTint, [CCCallFunc actionWithTarget:self selector:@selector(animCallBack)], nil]];
	[middlePart runAction: shrinkTint];
	[rightPart runAction: tint3];
	
	[circle runAction: [CCSequence actions: [CCDelayTime actionWithDuration: timeOne], disappear, [CCCallFunc actionWithTarget:controller selector:@selector(timeOut)], nil]];
}

- (void)pause {
    [self stopActions];
}


- (void)resume {
    [self resumeActions];
}

- (void)stopActions {
	[leftPart pauseSchedulerAndActions];
	[rightPart pauseSchedulerAndActions];
	[middlePart pauseSchedulerAndActions];
	[circle pauseSchedulerAndActions];
}

- (void)resumeActions {
	[leftPart resumeSchedulerAndActions];
	[rightPart resumeSchedulerAndActions];
	[middlePart resumeSchedulerAndActions];
	[circle resumeSchedulerAndActions];
}


- (void)reset {
	[[CCActionManager sharedManager] removeAllActionsFromTarget: leftPart];
	[[CCActionManager sharedManager] removeAllActionsFromTarget: middlePart];
	[[CCActionManager sharedManager] removeAllActionsFromTarget: rightPart];
	[[CCActionManager sharedManager] removeAllActionsFromTarget: circle];
	
	leftPart.position = ccp(-67, 0);
	leftPart.visible = YES;
	leftPart.color = ccc3(0, 255, 0);
	
	middlePart.position = ccp(67.5, 0.0);
	middlePart.scale = 1.0;
	middlePart.visible = YES;
	middlePart.color = ccc3(0, 255, 0);
	
	rightPart.position = ccp(67, 0);
	rightPart.visible = YES;
	rightPart.color = ccc3(0, 255, 0);

	circle.scale = 1.0;
	circle.visible = NO;
}

- (void)animCallBack {
	middlePart.visible = NO;
	leftPart.visible = NO;
	rightPart.visible = NO;
	circle.visible = YES;
}


@end

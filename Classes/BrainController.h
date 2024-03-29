//
//  BrainController.h
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SolutionModel.h"
#import "SolutionSprite.h"
#import "GameController.h"

#import "TimerNode.h"

#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
#import "CDAudioManager.h"
#import "cocos2d.h"


@interface BrainController : NSObject {
	CCNode *view;
	
	SolutionModel *model;
	
	SolutionSprite *left;
	SolutionSprite *right;
    CCLabelBMFont *operation;
    
    CCSprite *flashingView, *flashingView2;

    TimerNode *timer;
	
	NSMutableArray *solutionButtons;
	
	NSTimeInterval stamp;
	
	GameController *controller;
    
    float currentPitch;
    float volume;
    
    BOOL isLeftController;
}

@property (nonatomic, assign) GameController *controller;
@property (nonatomic, readonly) CCNode *view;

- (void)effect:(int)i;
- (void)flash:(BOOL)_right;

- (void)timeOut;
- (void)reset;
- (void)evaluate:(int)number;
- (void)newTask;

- (void)resume;
- (void)pause;
- (void)go;

- (int)score;

- (int)livesRemaining;
- (double)time;

@end

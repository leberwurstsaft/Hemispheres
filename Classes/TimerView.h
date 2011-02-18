//
//  TimerView.h
//  Hemispheres2
//
//  Created by Pit Garbe on 06.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BrainController;

@interface TimerView : NSObject {
    BrainController *controller;
    
	CCNode *view;
    
    CCSprite *timerBorder;
	CCSprite *middlePart;
	CCSprite *leftPart;
	CCSprite *rightPart;
	
	CCSprite *circle;
}

@property (nonatomic, assign) CCNode *view;
@property (nonatomic, assign) BrainController *controller;

- (void)pause;
- (void)resume;

- (void)countdown:(NSNumber *)_time;
- (void)reset;

@end

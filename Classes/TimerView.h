//
//  TimerView.h
//  Hemispheres2
//
//  Created by Pit Garbe on 06.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TimerView : NSObject {
	CCNode *view;
	CCSprite *middlePart;
	CCSprite *leftPart;
	CCSprite *rightPart;
	
	CCSprite *circle;
}

@property (nonatomic, assign) CCNode *view;

- (void)pause;
- (void)resume;

- (void)countdown:(NSNumber *)_time;
- (void)reset;

@end

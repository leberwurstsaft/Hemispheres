//
//  TimerNode.h
//  Hemispheres2
//
//  Created by Pit Garbe on 17.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BrainController;

@interface TimerNode : CCNode {
    BrainController *controller;
    
    CCProgressTimer *timer;
    
    double totalTime;
    BOOL done;
}


@property (nonatomic) double totalTime;
@property (nonatomic, assign) BrainController *controller;

- (void)setTimerImage:(NSString *)image;

@end

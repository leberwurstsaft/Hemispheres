//
//  TimerNode.m
//  Hemispheres2
//
//  Created by Pit Garbe on 17.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimerNode.h"
#import "BrainController.h"

@implementation TimerNode

@synthesize totalTime, controller;

- (id)init {
    if ((self = [super init])) {
        
        timer = [CCProgressTimer progressWithFile:@"timer.png"];
        timer.type = kCCProgressTimerTypeRadialCW;
        timer.percentage = 100;
        [self addChild: timer];
    }
    return self;
}

- (void)setTimerImage:(NSString *)image {
    [timer initWithFile: image];
    if ([image isEqualToString:@"timer2.png"]) {
        timer.type = kCCProgressTimerTypeRadialCCW;
        timer.percentage = 100;
    }
}

- (void)update:(ccTime)delta {
    double interval = 100 * (delta/totalTime);
    if (timer.percentage > interval) {
        timer.percentage = timer.percentage - interval;
    }
    else {
        [self unscheduleUpdate];
        timer.percentage = 0.0;
        [controller timeOut];
    }
}

- (void)setTotalTime:(double)time {
    if (timer.percentage > 0) {
        [self unscheduleUpdate];
    }
    totalTime = time;
    timer.percentage = 100;

    [self scheduleUpdate];
}


@end

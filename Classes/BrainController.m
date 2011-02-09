//
//  BrainController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrainController.h"
#import "SolutionButton.h"

@implementation BrainController

@synthesize controller, view;

- (id)init {
	if ((self = [super init])) {
		view = [CCNode node];
        currentPitch = 0.7;
	}
	return self;
}


- (void)effect:(int)i {
	[[solutionButtons objectAtIndex: i] effect];
}

- (void)flash:(BOOL)_right {
    if (_right) {
        flashingView.color = ccc3(0, 255, 0);
    }
    else {
        flashingView.color = ccc3(255, 0, 0);
    }
    
    flashingView.opacity = 1.0;
    [flashingView runAction: [CCFadeOut actionWithDuration:0.8]];
}

- (void)evaluate:(int)number {
	if ([model solution] == [[solutionButtons objectAtIndex: number] solution]) {
		CCLOG(@"Bingo!");
		[model increaseScore];
		[score setString: [NSString stringWithFormat:@"%d", [model score]]];
		[self flash: YES];
        
        currentPitch += 0.002;
        [[SimpleAudioEngine sharedEngine] playEffect:@"pling.caf" pitch:currentPitch pan:isLeftController ? -1.0 : 1.0 gain:1.0];
	}
	else {
		CCLOG(@"Zonk!!");
		[model reduceLives];
		[self flash: NO];
        
        NSString *soundFileName;
        switch ([model lives]) {
            case 0:
                soundFileName = @"ow.caf";
                break;
            case 1:
                soundFileName = @"pow.caf";
                break;
            case 2:
                soundFileName = @"ka.caf";
                break;
        }
        
        if ([model lives] >= 0) {
            [[SimpleAudioEngine sharedEngine] playEffect:soundFileName pitch:1.0 pan:isLeftController ? -1.0 : 1.0 gain:1.0];
        }

		//[livesMeter update];
	}
	
	if ([model lives] == 0) {
		[controller endGame];
	}
	else {
		[self newTask];
	}
}

- (void)newTask {
	[model nextTask];
	[left setSolution: [model left]];
	[right setSolution: [model right]];
    [operation setString: [model operation]];
	
	NSArray *solutions = [model possibleSolutions];
	int i;
	for (i = 0; i < [solutions count]; i++) {
		[[solutionButtons objectAtIndex: i] setSolution: [[solutions objectAtIndex: i] intValue]];
	}
	
	if ([controller gameRunning]) {
		CCLOG(@"roundtime: %f", [controller roundTime]);
		[model setTime: [controller roundTime]];
		[timerView countdown: [NSNumber numberWithFloat: [model time]]];
	}
}

- (void)timeOut {
	//NSLog(@"timeout links");
	[model reduceLives];
	
	/*[flashingView flashWrong];
	[[controller soundEngine] soundTimeout];
	
	[livesMeter update];*/
	
	if ([model lives] <= 0) {
		[controller endGame];
	}
	else {
		[self newTask];
	}
}

- (void)reset {
	//NSLog(@"reset left controller");
	[model reset];
	/*[livesMeter reset];
	[scoreView setText: @"0"];*/
}

- (void)pause {
	//NSLog(@"pause left");
	[timerView pause];
}

- (void)resume {
	//[timerView resumeTimer];
	
}

- (void)go {
	//[timerView reset: [model time]];
}

- (int)livesRemaining {
	return [model lives];
}

- (double)time {
	return [model time];
}

- (int)score {
	return [model score];
}


- (void) dealloc
{
	[super dealloc];
}
@end



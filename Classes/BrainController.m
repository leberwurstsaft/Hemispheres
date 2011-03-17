//
//  BrainController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrainController.h"
#import "SolutionButton.h"

#define  kHemiDefaultPitch 0.7

@implementation BrainController

@synthesize controller, view;

- (id)init {
	if ((self = [super init])) {
		view = [CCNode node];
        currentPitch = kHemiDefaultPitch;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        volume = 0.01 * [defaults floatForKey:@"HemispheresSoundVolume"];
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
    [flashingView runAction: [CCSequence actions: [CCShow action], [CCFadeOut actionWithDuration:0.8], [CCHide action], nil]];
}

- (void)evaluate:(int)number {
 
	if ([model solution] == [[solutionButtons objectAtIndex: number] solution]) {
        if (model.lives > 0) {
            CCLOG(@"Bingo!");
            [model increaseScore];
            //[self flash: YES];
            currentPitch += 0.001;
            [[SimpleAudioEngine sharedEngine] playEffect:@"pling.caf" pitch:currentPitch pan:isLeftController ? -0.7 : 0.7 gain: volume];
        }
        [(SolutionButton*)[solutionButtons objectAtIndex: number] effect: YES];
	}
	else {
		CCLOG(@"Zonk!!");
		[model reduceLives];
		//[self flash: NO];
        
        NSString *soundFileName = @"";;
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
            [[SimpleAudioEngine sharedEngine] playEffect:soundFileName pitch:1.0 pan:isLeftController ? -0.7 : 0.7 gain:volume];
        }
        [(SolutionButton*)[solutionButtons objectAtIndex: number] effect: NO];
	}
	
	if ([model lives] > 0) {
		[self newTask];
        [self go];
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
	
	// CCLOG(@"roundtime: %f", [controller roundTime]);
	[model setTime: [controller roundTime]];
}

- (void)timeOut {
	//NSLog(@"timeout links");
	[model reduceLives];
	
	[self flash: NO];

	[[SimpleAudioEngine sharedEngine] playEffect:@"timeout.caf" pitch:1.0 pan:isLeftController ? -0.7 : 0.7 gain: volume];
	
	if ([model lives] > 0) {
		[self newTask];
        [self go];
	}
}

- (void)reset {
    CCLOG(@"reset brain controller");
	[model reset];
    currentPitch = kHemiDefaultPitch;
    [timer setTotalTime: [model time]];
}

- (void)pause {
	//NSLog(@"pause left");
    [timer pauseSchedulerAndActions];
}


- (void)resume {
    [timer resumeSchedulerAndActions];
}

- (void)go {
    [timer setTotalTime: [model time]];
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
	[solutionButtons removeAllObjects];
	[solutionButtons release];
	[model release];
    
	[super dealloc];
}
@end



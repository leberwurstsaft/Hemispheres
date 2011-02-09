//
//  GameController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "LeftBrainController.h"
#import "RightBrainController.h"

@implementation GameController

@synthesize gameRunning, view, leftBrainController, rightBrainController;

- (id)init {
	if (( self = [super init])) {
		view = [CCNode node];
		rightBrainController = [[RightBrainController alloc] init];
		rightBrainController.controller = self;
		rightBrainController.view.position = ccp(240,0);
		[view addChild: rightBrainController.view];
		
		leftBrainController = [[LeftBrainController alloc] init];
		leftBrainController.controller = self;
		[view addChild: leftBrainController.view];
		
		roundTime = 0;
		gameRunning = YES;
	}
	return self;
}

- (int)totalScore {
	return [leftBrainController score] + [rightBrainController score];
}

- (double)roundTime {
	if (roundTime == 0) {
		roundTime = [leftBrainController time];
	}
	
	//NSLog(@"minus %f", cbrt((float)[self totalScore]) / 70.0);
	roundTime -= cbrt((float)[self totalScore]) / 70.0;
	if (roundTime < 1.0) {
		roundTime = 1.0;
	}
	
	if (roundTime > 1.0) {
		//[soundEngine updateBeepPitch: roundTime];
	}
	
	return roundTime;
}

- (void)pauseGame {
	NSLog(@"pause game");
	[rightBrainController pause];
	[leftBrainController pause];
	//[soundEngine stopBeep];
}

- (void)resumeGame {
	[leftBrainController resume];
	[rightBrainController resume];
	//[soundEngine makeBeep];
}

- (void)prepareGame {
	[leftBrainController reset];
	[rightBrainController reset];
	[self reset];
	[leftBrainController newTask];
	[rightBrainController newTask];
}

- (void)reset {
	roundTime = 10.0;
	//[soundEngine reset];
}

- (void)beginNewGame {
	gameRunning = YES;
	
	[leftBrainController go];
	[rightBrainController go];
	//[soundEngine performSelector:@selector(makeBeep) withObject:nil afterDelay:1.0];
}

- (void)playAgain {
	[self prepareGame];
	[self performSelector:@selector(beginNewGame) withObject: nil afterDelay:0.02];	
}

- (void)endGame {
	NSLog(@"end game");
	gameRunning = NO;
	
	[self pauseGame];

	//[lostGameController showWhatNextView];
}

- (void)exitGame {
	//[rootVC showIntro];
	[leftBrainController performSelector: @selector(reset) withObject:nil afterDelay:0.1];
	[rightBrainController performSelector: @selector(reset) withObject: nil afterDelay: 0.1];
}

/*- (void)enterScores {
	NSLog(@"enterScore()");
	
	[self reportScore:[self totalScore] forCategory:@"1"];
	[self reportScore:[leftBrainController score] forCategory:@"2"];
	[self reportScore:[rightBrainController score] forCategory:@"3"];
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
	
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		if (error != nil)
		{
			NSLog(@"error transmitting score %@", error);
            NSData *archivedScore = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
			//[self saveScoreToSendLater: archivedScore];
        }
		else {
			NSLog(@"successfully sent score: %lld", score);
		}
    }];
}
*/


- (void)dealloc {
	[rightBrainController release];
	[leftBrainController release];
//	[lostGameController release];
//	[soundEngine release];
    [super dealloc];
}


@end

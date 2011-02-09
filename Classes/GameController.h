//
//  GameController.h
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BrainController;

@interface GameController : NSObject {
	CCNode *view;
	
	BrainController *rightBrainController;
	BrainController	*leftBrainController;

	double	roundTime;
	
	BOOL	gameRunning;
	
	int		personalHighscore;
	
}

@property (nonatomic, readonly) BrainController *rightBrainController;
@property (nonatomic, readonly) BrainController *leftBrainController;

@property (nonatomic, readonly) BOOL gameRunning;
@property (nonatomic, readonly) CCNode *view;

- (void)pauseGame;
- (void)resumeGame;

- (void)prepareGame;
- (void)beginNewGame;
- (void)endGame;
- (void)enterScores;
//- (void)reportScore:(int64_t)score forCategory:(NSString*)category;
- (void)playAgain;
- (void)exitGame;

- (int)totalScore;
- (double)roundTime;
- (void)reset;

@end

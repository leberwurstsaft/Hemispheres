//
//  GameController.h
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>

typedef enum  {
    kNumberTrainingType = 1,
    kColorTrainingType = 2,
} TrainingType;

typedef enum {
    kTrainingStagePreIntroduction = 0,
    kTrainingStageIntroduction = 1,
    kTrainingStageRunning = 2,
    kTrainingStageDone = 3,
} TrainingStage;

@class BrainController, InfoBarController, LivesMeter;

@interface GameController : NSObject {
	CCNode *view;
	
	BrainController *rightBrainController;
	BrainController	*leftBrainController;
    InfoBarController *infoBarController;
    
    CCSprite *drapes;

    double	roundTime;
	
	BOOL	gameRunning;
	
	int		personalHighscore;
	
    int     trainingGoal;
    int     trainingToRun;
    BOOL    trainingRunning;
    int     trainingStage;
    
    NSMutableArray *unsentScores;
    NSMutableArray *unsentAchievements;
    
    NSDate  *startTime;
}

@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSMutableDictionary *achievementsDictionary;

@property (nonatomic, readonly) BrainController *rightBrainController;
@property (nonatomic, readonly) BrainController *leftBrainController;

@property (nonatomic, readonly) BOOL gameRunning;
@property (nonatomic, readonly) BOOL trainingRunning;
@property (nonatomic, readonly) int trainingToRun;

@property (nonatomic, readonly) CCNode *view;

- (void)animate;
- (void)registerObservers;

- (void)showDrapes:(BOOL)_show;
- (void)pauseGame;
- (void)resumeGame;

// - (void)fadeToGray;

- (void)beginNewGame;
- (void)endGame;
- (double)playingTime;
- (void)showScoreAndMenu;
- (void)removeReplayMenu;
- (void)enableReplayMenu;

// Game Center
- (void)enterScores;
- (void)reportScore:(int64_t)score forCategory:(NSString*)category;
- (void)sendUnsentScores;
- (void)saveUnsentScores;

- (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent;
- (void)loadAchievements;
- (GKAchievement*)getAchievementForIdentifier:(NSString*)identifier;
- (void)sendUnsentAchievements;
- (void)saveUnsentAchievements;
- (void)newUnseenAchievements;

// Training
- (void)runNumberTraining:(int)goal;
- (void)runColorTraining:(int)goal;
- (void)beginTraining;
- (void)repeatTraining;
- (void)continueTraining;
- (void)endTraining;

- (void)checkPossibleAchievements;
- (void)playAgain;
- (void)exitGame;

- (int)totalScore;
- (double)roundTime;
- (void)reset;


@end

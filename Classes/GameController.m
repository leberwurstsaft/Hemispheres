//
//  GameController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import "Hemispheres2AppDelegate.h"
#import "GameScene.h"
#import "GameController.h"
#import "LeftBrainController.h"
#import "RightBrainController.h"
#import "InfoBarController.h"
#import "LivesMeter.h"
#import <GameKit/GameKit.h>

@interface GameController()

/*
- (UIImage*) screenshotUIImage;
- (CCTexture2D*) screenshotTexture;
- (UIImage *)convertImageToGrayScale:(UIImage *)image;
 */

- (void)removeAllObservers;
- (void)enableTouch:(BOOL)_enable;

@end

@implementation GameController

@synthesize gameRunning, view, leftBrainController, rightBrainController, achievementsDictionary, startTime, trainingToRun, trainingRunning;

- (id)init {
	if (( self = [super init])) {
		view = [CCNode node];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            offset = 512;
            offset2 = 340;
        }
        else {
            offset = 240;
            offset2 = 170;
        }
        
        infoBarController = [[InfoBarController alloc] init];
        infoBarController.controller = self;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            infoBarController.view.position = ccp(512, 896);
        }
        else {
            infoBarController.view.position = ccp(240, 440);
        }
        [view addChild: infoBarController.view z:3];

		leftBrainController = [[LeftBrainController alloc] init];
		leftBrainController.controller = self;
        leftBrainController.view.position = ccp(-offset, 0);
		[view addChild: leftBrainController.view z:0];

		rightBrainController = [[RightBrainController alloc] init];
		rightBrainController.controller = self;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            rightBrainController.view.position = ccp(512 + offset, 0);
        }
        else {
            rightBrainController.view.position = ccp(240+offset,0);
        }
		[view addChild: rightBrainController.view z:1];
       
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            drapes = [CCSprite spriteWithFile:@"drapes.png" rect: CGRectMake(0, 0, 1024, 768)];
            drapes.position = ccp(512, 384);
        }
        else {
            drapes = [CCSprite spriteWithFile:@"drapes.png" rect: CGRectMake(0, 0, 480, 320)];
            drapes.position = ccp(240, 160);
        }
        ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        [[drapes texture] setTexParameters: &params];
        drapes.visible = NO;
        
        CCLabelBMFont *nonono = [CCLabelBMFont labelWithString:NSLocalizedString(@"NO_CHEATING", nil) fntFile:@"tutorial.fnt"];
        nonono.rotation = -20;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            nonono.position = ccp(512, 320);
        }
        else {
            nonono.position = ccp(240, 140);
        }
        [drapes addChild: nonono];
        [view addChild: drapes z:2];

        [self registerObservers];
        
		roundTime = 0;
        trainingGoal = 0;
        
        unsentScores = [[NSMutableArray alloc] init];
        CCLOG(@"init unsent scores");
      	[unsentScores setArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"HemispheresUnsentScores"]];
        CCLOG(@"loaded %d unsent scores", [unsentScores count]);

        unsentAchievements = [[NSMutableArray alloc] init];
        CCLOG(@"init unsent achievements");
      	[unsentAchievements setArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"HemispheresUnsentAchievements"]];
        CCLOG(@"loaded %d unsent achievements", [unsentAchievements count]);

        
        achievementsDictionary = [[NSMutableDictionary alloc] init];
        
        if (![[GKLocalPlayer localPlayer] isAuthenticated]) {
            [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
                if (error == nil) {
                    [self loadAchievements];
                }
            }];
        }
		else {
			 [self loadAchievements];
		}
	}
	return self;
}

- (void)animate {
    CCMoveBy *move = [CCMoveBy actionWithDuration: 0.6 position:ccp(offset, 0)];
    CCMoveBy *move_back = (CCMoveBy *)[move reverse];
    
    CCEaseIn *move_ease = [CCEaseIn actionWithAction:move rate:3.0f];
    CCEaseIn *move_ease_back = [CCEaseIn actionWithAction:move_back rate:3.0f];
    
    CCMoveBy *move_down = [CCMoveBy actionWithDuration: 0.6 position: ccp(0, -100)];
    CCEaseOut *move_down_ease = [CCEaseOut actionWithAction:move_down rate:3.0f];
    
    [leftBrainController.view runAction: move_ease];
    [rightBrainController.view runAction: move_ease_back];
    [infoBarController.view runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.5], move_down_ease, [CCCallFunc actionWithTarget:self selector:@selector(beginNewGame)],nil]];  
}

#pragma mark -
#pragma mark Training Mode

- (void)runNumberTraining:(int)goal {
    trainingGoal = goal;
    trainingStage = kTrainingStageIntroduction;
    trainingToRun = kNumberTrainingType;
    
    CCMoveBy *move = [CCMoveBy actionWithDuration: 0.6 position:ccp(offset, 0)];
    CCEaseIn *move_ease = [CCEaseIn actionWithAction:move rate:3.0f];
    
    CCMoveBy *move_down = [CCMoveBy actionWithDuration: 0.6 position: ccp(0, -100)];
    CCEaseOut *move_down_ease = [CCEaseOut actionWithAction:move_down rate:3.0f];
    
    [leftBrainController.view runAction: move_ease];
    [infoBarController.view runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.5], move_down_ease, [CCCallFunc actionWithTarget:self selector:@selector(beginTraining)],nil]];  
}

- (void)runColorTraining:(int)goal {
    trainingGoal = goal;
    trainingStage = kTrainingStageIntroduction;
    trainingToRun = kColorTrainingType;
    
    CCMoveBy *move = [CCMoveBy actionWithDuration: 0.6 position:ccp(offset, 0)];
    CCMoveBy *move_back = (CCMoveBy *)[move reverse];
    CCEaseIn *move_ease_back = [CCEaseIn actionWithAction:move_back rate:3.0f];

    [leftBrainController.view runAction: [move_ease_back copy]];
    [rightBrainController.view runAction: move_ease_back];
    [infoBarController.view runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(beginTraining)],nil]];  
}

- (void)beginTraining {
        
    if (trainingRunning) {
        
        if (trainingToRun == kNumberTrainingType) {
            [leftBrainController reset];
            [leftBrainController newTask];
        }
        else {
            [rightBrainController reset];
            [rightBrainController newTask];
        }
    }
    else if (trainingStage == kTrainingStageIntroduction) {

        numAttemptsColors = 1;
        numAttemptsNumbers = 1;
        
        if (trainingToRun == kNumberTrainingType) {
            CCScene *current = [[CCDirector sharedDirector] runningScene];
            if ([current isKindOfClass:[GameScene class]]) {
                NSString *text = NSLocalizedString(@"MATH_TASK", nil);

                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [(GameScene*)current showTextBox:ccp(542, 140) size:CGSizeMake(400, 314) text:text];
                }
                else {
                    [(GameScene*)current showTextBox:ccp(265, 70) size:CGSizeMake(200, 157) text:text];
                }
            }
        }
        else if (trainingToRun == kColorTrainingType) {
            CCScene *current = [[CCDirector sharedDirector] runningScene];
            if ([current isKindOfClass:[GameScene class]]) {
                NSString *text = NSLocalizedString(@"COLOR_TASK", nil);
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [(GameScene*)current showTextBox:ccp(40, 150) size:CGSizeMake(400, 314) text:text];
                }
                else {
                    [(GameScene*)current showTextBox:ccp(20, 75) size:CGSizeMake(200, 157) text:text];
                }
            }
        }
        
        [self pauseGame];
        [self enableTouch: NO];
    }
    
    if (trainingStage > kTrainingStageIntroduction) {

        trainingRunning = YES;

        [self enableTouch:YES];
        
        if (trainingToRun == kNumberTrainingType) {
            [leftBrainController go];
            [rightBrainController pause];
        }
        else {
            [rightBrainController go];
            [leftBrainController pause];
        }
    }
}

- (void)repeatTraining {
    
    [self pauseGame];
    [self enableTouch:NO];
    
    CCScene *current = [[CCDirector sharedDirector] runningScene];
    if ([current isKindOfClass:[GameScene class]]) {
        
        trainingStage = kTrainingStageIntroduction;
        
        NSString *text = NSLocalizedString(@"TRAINING_FAIL", nil);
        if (trainingToRun == kNumberTrainingType) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [(GameScene*)current showTextBox:ccp(542, 140) size:CGSizeMake(400, 314) text:text];
            }
            else {
                [(GameScene*)current showTextBox:ccp(265, 70) size:CGSizeMake(200, 157) text:text];
            }
            
            numAttemptsNumbers++;
        }
        else {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [(GameScene*)current showTextBox:ccp(40, 150) size:CGSizeMake(400, 314) text:text];
            }
            else {
                [(GameScene*)current showTextBox:ccp(20, 75) size:CGSizeMake(200, 157) text:text];
            }
            
            numAttemptsColors++;
        }
    }
}

- (void)continueTraining {
    if (trainingStage == kTrainingStagePreIntroduction) {
        [self runColorTraining: trainingGoal];
    }
    else {
        trainingStage++;        
        
        if (trainingStage == kTrainingStageDone) {
            [self endTraining];
        }
        else {
            [self resumeGame];
            [self beginTraining];
        }
    }
}

- (void)endTraining {
	CCLOG(@"end training");
    if (trainingRunning && trainingStage < kTrainingStageDone) {
        trainingRunning = NO;
        
        [self pauseGame];
        [self enableTouch:NO];
        
        CCScene *current = [[CCDirector sharedDirector] runningScene];
        if ([current isKindOfClass:[GameScene class]]) {
            
            if (trainingToRun == kNumberTrainingType) {
                trainingToRun = kColorTrainingType;
                trainingStage = kTrainingStagePreIntroduction;
                
                NSString *text = NSLocalizedString(@"MATH_TRAINING_WIN", nil);
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [(GameScene*)current showTextBox:ccp(542, 140) size:CGSizeMake(400, 314) text:text];
                }
                else {
                    [(GameScene*)current showTextBox:ccp(265, 70) size:CGSizeMake(200, 157) text:text];
                }
            }
            else {
                NSString *text = NSLocalizedString(@"COLOR_TRAINING_WIN", nil);
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    [(GameScene*)current showTextBox:ccp(40, 150) size:CGSizeMake(400, 314) text:text];
                }
                else {
                    [(GameScene*)current showTextBox:ccp(20, 75) size:CGSizeMake(200, 157) text:text];
                }
            }
        }
    }
    else {
        trainingRunning = NO;
        
        [self pauseGame];
        [self enableTouch:NO];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HemispheresTutorialFinished"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt: numAttemptsNumbers],
                                    @"number of attempts for number training",
                                    [NSNumber numberWithInt: numAttemptsColors],
                                    @"number of attempts for color training",
                                    nil];

        id tran = [CCTransitionCrossFade transitionWithDuration:0.3 scene:[GameScene node]];
        [[CCDirector sharedDirector] replaceScene: tran];
    }
}

#pragma mark -

- (void)registerObservers {
    [leftBrainController addObserver:infoBarController forKeyPath:@"model.score" options:NSKeyValueObservingOptionNew context:NULL];
    [leftBrainController addObserver:infoBarController forKeyPath:@"model.lives" options:NSKeyValueObservingOptionNew context:NULL];
    [leftBrainController addObserver:self forKeyPath:@"model.lives" options:NSKeyValueObservingOptionNew context:NULL];
    [leftBrainController addObserver:self forKeyPath:@"model.score" options:NSKeyValueObservingOptionNew context:NULL];

    [rightBrainController addObserver:infoBarController forKeyPath:@"model.score" options:NSKeyValueObservingOptionNew context:NULL];
    [rightBrainController addObserver:infoBarController forKeyPath:@"model.lives" options:NSKeyValueObservingOptionNew context:NULL];
    [rightBrainController addObserver:self forKeyPath:@"model.lives" options:NSKeyValueObservingOptionNew context:NULL];
    [rightBrainController addObserver:self forKeyPath:@"model.score" options:NSKeyValueObservingOptionNew context:NULL];
}

- (int)totalScore {
	return [leftBrainController score] + [rightBrainController score];
}

- (double)roundTime {
	if (roundTime == 0) {
		roundTime = [leftBrainController time];
	}
	
	roundTime -= cbrt((float)[self totalScore]) / 80.0;
	if (roundTime < 1.0) {
		roundTime = 1.0;
	}
	CCLOG(@"roundtime: %f", roundTime);
    
	return roundTime;
}

- (void)showDrapes:(BOOL)_show {
    if (gameRunning) {
        drapes.visible = _show;
        [infoBarController enableTouch: !(_show)];
    }
}

- (void)pauseGame {
	CCLOG(@"pause game");
    
    [leftBrainController pause];
    [rightBrainController pause];
}

- (void)resumeGame {
	[leftBrainController resume];
	[rightBrainController resume];
}

- (void)reset {
    CCLOG(@"game controller reset");
	roundTime = 0.0;
    
    numResets++;
    
	[leftBrainController reset];
	[rightBrainController reset];

    [leftBrainController newTask];
    [rightBrainController newTask];
    
    self.startTime = [NSDate date];
}

- (void)beginNewGame {
	gameRunning = YES;
    [self enableTouch:YES];
    
    numResets = 0;
	
	[leftBrainController go];
	[rightBrainController go];
    
    self.startTime = [NSDate date];
}

- (void)enableTouch:(BOOL)_enable {
    id current = [[CCDirector sharedDirector] runningScene];
    if ([current isKindOfClass:[GameScene class]]) {
        [(GameScene*)current setTouchEnabled: _enable];
    }
}

- (void)playAgain {
    CCLOG(@"play again");
    
    CCMoveBy *move = [CCMoveBy actionWithDuration: 0.6 position:ccp(offset2, 0)];
    CCMoveBy *move_back = (CCMoveBy *)[move reverse];
    
    CCEaseIn *move_ease = [CCEaseIn actionWithAction:move rate:3.0f];
    CCEaseIn *move_ease_back = [CCEaseIn actionWithAction:move_back rate:3.0f];
    
    [rightBrainController.view runAction: move_ease_back];
    [leftBrainController.view runAction: move_ease];
    
    id fade = [CCFadeOut actionWithDuration: 0.6];
    
    CCMenu *menu = (CCMenu*)[self.view getChildByTag: 30];
    menu.isTouchEnabled = NO;
    
    [menu runAction: [CCSequence actions:[fade copy], [CCHide action], nil]];
    [(CCLabelBMFont*)[self.view getChildByTag: 31] runAction: [CCSequence actions:[fade copy], [CCHide action], nil]];
    [(CCSprite*)[self.view getChildByTag: 32] runAction: [CCSequence actions:fade, [CCHide action], [CCCallFunc actionWithTarget:self selector:@selector(removeReplayMenu)], nil]];
    
    [self performSelector:@selector(reset) withObject:nil afterDelay:0.6];
	[self performSelector:@selector(beginNewGame) withObject: nil afterDelay:0.6];	
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CCLOG(@"observing a value @ %@", keyPath);
    if (gameRunning || trainingRunning) {
        if ([keyPath isEqual:@"model.lives"]) {
            
            int lives = [[change objectForKey: NSKeyValueChangeNewKey] intValue];
            
            if (lives == 0) {
                if (trainingRunning) {
                    [self performSelector:@selector(repeatTraining) withObject:nil afterDelay:0.1];
                }
                else {
                    [self performSelector:@selector(endGame) withObject:nil afterDelay:0.1];
                }
            }  
        }
        else if([keyPath isEqual:@"model.score"]) {
            if (trainingRunning) {
                int score = [[change objectForKey: NSKeyValueChangeNewKey] intValue];
                if (score >= trainingGoal) {
                    [self performSelector:@selector(endTraining) withObject:nil afterDelay:0.1];
                }
            }
            else if (gameRunning) {
                [self checkPossibleAchievements];
            }
        }
    }
}

- (void)checkPossibleAchievements {
    int totalScore = [self totalScore];
    
    double playingTime = [self playingTime];
    CCLOG(@"playing time: %f", playingTime);
    
    if (gameRunning) {
        if (totalScore == 50 && [achievementsDictionary objectForKey:@"first_time_50_points"] == nil) {
            [self reportAchievementIdentifier:@"first_time_50_points" percentComplete:100];
        }
        else if (totalScore == 75 && [achievementsDictionary objectForKey:@"first_time_75_points"] == nil) {
            [self reportAchievementIdentifier:@"first_time_75_points" percentComplete:100];
        }
        else if (totalScore == 100 && [achievementsDictionary objectForKey:@"first_time_100_points"] == nil) {
            [self reportAchievementIdentifier:@"first_time_100_points" percentComplete:100];
        }
        else if (totalScore == 150 && [achievementsDictionary objectForKey:@"first_time_150_points"] == nil) {
            [self reportAchievementIdentifier:@"first_time_150_points" percentComplete:100];
        }
        
        if (totalScore == 60) {
            if (playingTime <= 60 && [achievementsDictionary objectForKey:@"minuteman"] == nil) {
                [self reportAchievementIdentifier:@"minuteman" percentComplete:100];
            }
        }
    }
    else {
        if (totalScore >= 70 && ([leftBrainController score] == [rightBrainController score]) && [achievementsDictionary objectForKey:@"balanced"] == nil) {
            [self reportAchievementIdentifier:@"balanced" percentComplete:100];
        }
        if ([leftBrainController score] >= 30 && [rightBrainController score] == 0 && [achievementsDictionary objectForKey:@"scientist"] == nil) {
            [self reportAchievementIdentifier:@"scientist" percentComplete:100];
        }
        if ([rightBrainController score] >= 30 && [leftBrainController score] == 0 && [achievementsDictionary objectForKey:@"artist"] == nil) {
            [self reportAchievementIdentifier:@"artist" percentComplete:100];
        }
    }
}

- (double)playingTime {
    return [[NSDate date] timeIntervalSinceDate: self.startTime];
}

#pragma mark -
#pragma mark End Of Game

- (void)endGame {
	CCLOG(@"end game");
    if (gameRunning || trainingRunning) {
        gameRunning = NO;
        trainingRunning = NO;
        
        [self pauseGame];
        [self enableTouch:NO];

        int playingTime5 = 5 * floor([self playingTime] / 5.0);

        [self checkPossibleAchievements];
        
        // unlock all!
        /*
        [self reportAchievementIdentifier:@"first_time_50_points" percentComplete:100];
        [self reportAchievementIdentifier:@"first_time_75_points" percentComplete:100];
        [self reportAchievementIdentifier:@"first_time_100_points" percentComplete:100];
        [self reportAchievementIdentifier:@"first_time_150_points" percentComplete:100];
        [self reportAchievementIdentifier:@"minuteman" percentComplete:100];
        [self reportAchievementIdentifier:@"balanced" percentComplete:100];
        [self reportAchievementIdentifier:@"scientist" percentComplete:100];
        [self reportAchievementIdentifier:@"artist" percentComplete:100];
         */
        
        [self enterScores];
        
        [self showScoreAndMenu];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt: numResets],
                                    @"number of resets during game",
                                    [NSNumber numberWithInt: playingTime5],
                                    @"playing time during game",
                                    [NSNumber numberWithInt: [leftBrainController score]],
                                    @"numbers score",
                                    [NSNumber numberWithInt: [rightBrainController score]],
                                    @"colors score",
                                    [NSNumber numberWithInt: [self totalScore]],
                                    @"total score",
                                    nil];
    }
}

- (void)showScoreAndMenu {
    CCMoveBy *move = [CCMoveBy actionWithDuration: 0.6 position:ccp(offset2, 0)];
    CCMoveBy *move_back = (CCMoveBy *)[move reverse];
    
    CCEaseIn *move_ease = [CCEaseIn actionWithAction:move rate:3.0f];
    CCEaseIn *move_ease_back = [CCEaseIn actionWithAction:move_back rate:3.0f];
    
    [rightBrainController.view runAction: [CCSequence actions: move_ease, [CCCallFunc actionWithTarget:self selector:@selector(enableReplayMenu)], nil]];
    [leftBrainController.view runAction: move_ease_back];
    
    CCMenuItemLabel *item = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:NSLocalizedString(@"MENU", nil) fntFile:@"menu.fnt"] target:self selector:@selector(showIntro)];
    CCMenuItemLabel *item2 = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:NSLocalizedString(@"PLAY_AGAIN", nil) fntFile:@"menu.fnt"] target:self selector:@selector(playAgain)];

    [infoBarController hideReplayButton];
    
    id fade = [CCFadeIn actionWithDuration: 0.6];
    
    CCMenu *menu = [CCMenu menuWithItems:item, item2, nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [menu alignItemsVerticallyWithPadding:240];
    }
    else {
        [menu alignItemsVerticallyWithPadding:120];
    }
    
    // compensate for lousy positioning :(
    double quotient = item2.contentSizeInPixels.width / 2.0;
    double ohneRest =  floor(quotient);
    double rest = quotient - ohneRest;
    item2.position = ccpAdd(item2.position, ccp(rest, 0));
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        menu.position = ccp(512, 330);
    }
    else {
        menu.position = ccp(240, 135);
    }
    
    menu.visible = NO;
    menu.tag = 30;
    [self.view addChild:menu z:20];
    menu.isTouchEnabled = NO;
    [menu runAction: [CCSequence actions:[CCShow action], [fade copy], nil]];
    
    CCLabelBMFont *bigScore = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%d", [self totalScore]] fntFile:@"bigscore.fnt"];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        bigScore.position = ccp(512, 340);
    }
    else {
        bigScore.position = ccp(240, 140);
    }
    bigScore.opacity = 0;
    bigScore.tag = 31;
    bigScore.rotation = 10;
    [self.view addChild:bigScore z:19];
    
    id sequence = [CCSequence actions: 
                        [CCRepeat actionWithAction:
                            [CCSequence actions: 
                                [CCEaseInOut actionWithAction: [CCRotateTo actionWithDuration:0.15 angle:-10] rate:3.0],
                                [CCEaseInOut actionWithAction: [CCRotateTo actionWithDuration:0.15 angle: 10] rate:3.0], nil]
                            times:2],
                        [CCEaseInOut actionWithAction: [CCRotateTo actionWithDuration:0.2 angle: 0] rate:3.0],
                   nil];
    
    [bigScore runAction: [CCSpawn actions:[fade copy], sequence, nil]];
    
    CCSprite *blur = [CCSprite spriteWithSpriteFrameName:@"background-blurred"];
    blur.opacity = 0;
    blur.tag = 32;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        blur.position = ccp(512, 384);
    }
    else {
        blur.position = ccp(240, 160);
    }
    blur.color = ccc3(180, 180, 180);
    [self.view addChild: blur z:-1];
    [blur runAction: fade];
}

- (void)enableReplayMenu {
    [(CCMenu*)[self.view getChildByTag:30] setIsTouchEnabled:YES];
}

- (void)removeReplayMenu {
    [self.view removeChildByTag:30 cleanup:YES];
    [self.view removeChildByTag:31 cleanup:YES];
    [self.view removeChildByTag:32 cleanup:YES];
}

- (void)showIntro {
    [(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] showIntro];
}

#pragma mark -
#pragma mark Game Center Scores

- (void)enterScores {
	CCLOG(@"enterScore()");
	
	[self reportScore:[self totalScore] forCategory:@"hemispheres_total_score"];
	[self reportScore:[leftBrainController score] forCategory:@"hemispheres_left_score"];
	[self reportScore:[rightBrainController score] forCategory:@"hemispheres_right_score"];
}

- (void)reportScore:(int64_t)score forCategory:(NSString*)category {
    if ([(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] gameCenterFeaturesEnabled]) {
        GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
        scoreReporter.value = score;
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            if (error != nil)
            {
                CCLOG(@"error transmitting score %@", error);
                [unsentScores addObject:[NSDictionary dictionaryWithObjectsAndKeys:
										 [NSNumber numberWithInteger:scoreReporter.value], @"score",
										 scoreReporter.playerID, @"player",
										 scoreReporter.category, @"category",
										 scoreReporter.date, @"date",
										 nil]];
                CCLOG(@"unsent scores: %d", [unsentScores count]);
                [self saveUnsentScores];
            }
            else {
                CCLOG(@"successfully sent score: %lld", score);
                //attempt to send unsent scores
                [self sendUnsentScores];
            }
        }];
    }
}

- (void)newUnseenAchievements {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:[NSString stringWithFormat:@"HemispheresNewAchievements-%d", [GKLocalPlayer localPlayer].playerID]];
    [defaults synchronize];
}

- (void)sendUnsentScores {
    CCLOG(@"sending %d unsent scores", [unsentScores count]);

    NSArray *sendTheseScores = [unsentScores copy];
    
    for (NSDictionary *unsentScore in sendTheseScores) {
		if ([[unsentScore objectForKey:@"player"] isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
			GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:[unsentScore objectForKey:@"category"]] autorelease];
			scoreReporter.value = [[unsentScore objectForKey:@"score"] integerValue];
			[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
				if (error == nil) {
                    CCLOG(@"sent score %lld for player %@ (from %@)", scoreReporter.value, scoreReporter.playerID, scoreReporter.date);
					[unsentScores removeObject:unsentScore];
                    [self saveUnsentScores];
				}
                else {
                    CCLOG(@"error sending saved score");
                }
			}];
		}
	}
    [sendTheseScores release];
}


- (void)saveUnsentScores {
    CCLOG(@"saving %d unsent scores", [unsentScores count]);
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setObject:unsentScores forKey:@"HemispheresUnsentScores"];	
	[settings synchronize];
}

#pragma mark -
#pragma mark Game Center Achievements

- (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent {
    
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
    if (achievement) {
        CCLOG(@"unlocking achievement: %@", identifier);
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"error transmitting achievement %@", error);
                [unsentAchievements addObject:[NSDictionary dictionaryWithObjectsAndKeys:
										 achievement.identifier, @"identifier",
										 [GKLocalPlayer localPlayer].playerID, @"player",
										 [NSNumber numberWithFloat: achievement.percentComplete], @"percent",
										 achievement.lastReportedDate, @"date",
										 nil]];
                [self saveUnsentAchievements];
            }
            else {
                [achievementsDictionary setObject: achievement forKey: achievement.identifier];
                
                [self newUnseenAchievements];

                [self sendUnsentAchievements];
            }
         }];
    }
}

- (void)loadAchievements {
    CCLOG(@"loading achievements");
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error == nil) {
			CCLOG(@"loading %d achievements", [achievements count]);
			
            for (GKAchievement* achievement in achievements) {
                CCLOG(@"achievement %@ loaded", achievement.identifier);
                [achievementsDictionary setObject: achievement forKey: achievement.identifier];
            }
        }
     }];
}

- (GKAchievement*)getAchievementForIdentifier:(NSString*)identifier {
    
    GKAchievement *achievement = [achievementsDictionary objectForKey:identifier];
    if (achievement == nil) {
        achievement = [[[GKAchievement alloc] initWithIdentifier:identifier] autorelease];
        [achievementsDictionary setObject:achievement forKey:achievement.identifier];
    }
    return [[achievement retain] autorelease];
}

- (void)sendUnsentAchievements {
    CCLOG(@"sending %d unsent achievements", [unsentAchievements count]);
    
    NSArray *sendTheseAchievements = [unsentAchievements copy];
    
    for (NSDictionary *unsentAchievement in sendTheseAchievements) {
		if ([[unsentAchievement objectForKey:@"player"] isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            
            NSString *identifier = [unsentAchievement objectForKey:@"identifier"];
            
            GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
            if (achievement) {
                CCLOG(@"sending unsent achievement: %@", identifier);
                achievement.percentComplete = [[unsentAchievement objectForKey:@"percent"] floatValue];
                [achievement reportAchievementWithCompletionHandler:^(NSError *error) {
                    if (error == nil) {
                        [unsentAchievements removeObject:unsentAchievement];
                        [self saveUnsentAchievements];
                        
                        [self newUnseenAchievements];
                    }
                }];
            }
		}
	}
    
    [sendTheseAchievements release];
    
}


- (void)saveUnsentAchievements {
    CCLOG(@"saving %d unsent scores", [unsentAchievements count]);
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
	[settings setObject:unsentAchievements forKey:@"HemispheresUnsentAchievements"];	
	[settings synchronize];
}

#pragma mark -

/*
- (void)fadeToGray {
    [[CCDirector sharedDirector] setDisplayFPS:NO];
	UIImage *img = [self convertImageToGrayScale: [self screenshotUIImage]];
    [[CCDirector sharedDirector] setDisplayFPS:YES];
    
	CCTexture2D *mTex = [[CCTexture2D alloc] initWithImage:img];
	CCSprite *sprite = [CCSprite spriteWithTexture: mTex];
	sprite.position = ccp(240, 160);
	sprite.opacity = 0;
    [view addChild: sprite z:10];
    [sprite runAction: [CCFadeIn actionWithDuration:0.5]];
    [mTex release];
}
     
- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object  
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

- (UIImage*) screenshotUIImage
{
	CGSize displaySize	= [[CCDirector sharedDirector] displaySizeInPixels];
	CGSize winSize		= [[CCDirector sharedDirector] winSizeInPixels];
	
	//Create buffer for pixels
	GLuint bufferLength = displaySize.width * displaySize.height * 4;
	GLubyte* buffer = (GLubyte*)malloc(bufferLength);
	
	//Read Pixels from OpenGL
	glReadPixels(0, 0, displaySize.width, displaySize.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	//Make data provider with data.
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
	
	//Configure image
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * displaySize.width;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	CGImageRef iref = CGImageCreate(displaySize.width, displaySize.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
	
	uint32_t* pixels = (uint32_t*)malloc(bufferLength);
	CGContextRef context = CGBitmapContextCreate(pixels, winSize.width, winSize.height, 8, winSize.width * 4, CGImageGetColorSpace(iref), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	
	CGContextTranslateCTM(context, 0, displaySize.height);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	switch ([CCDirector sharedDirector].deviceOrientation)
	{
		case CCDeviceOrientationPortrait: break;
		case CCDeviceOrientationPortraitUpsideDown:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(180));
			CGContextTranslateCTM(context, -displaySize.width, -displaySize.height);
			break;
		case CCDeviceOrientationLandscapeLeft:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(-90));
			CGContextTranslateCTM(context, -displaySize.height, 0);
			break;
		case CCDeviceOrientationLandscapeRight:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(90));
			CGContextTranslateCTM(context, displaySize.height-displaySize.width, -displaySize.height);
			break;
	}
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, displaySize.width, displaySize.height), iref);
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage *outputImage = [[[UIImage alloc] initWithCGImage:imageRef] autorelease];
	
	//Dealloc
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGImageRelease(iref);
	CGColorSpaceRelease(colorSpaceRef);
	CGContextRelease(context);
	free(buffer);
	free(pixels);
	
	return outputImage;
}

- (CCTexture2D*) screenshotTexture
{
	return [[[CCTexture2D alloc] initWithImage:[self screenshotUIImage]] autorelease];
}
*/
- (void)exitGame {
	//[rootVC showIntro];
	[leftBrainController performSelector: @selector(reset) withObject:nil afterDelay:0.1];
	[rightBrainController performSelector: @selector(reset) withObject: nil afterDelay: 0.1];
}


- (void)removeAllObservers {
    [leftBrainController removeObserver:self forKeyPath:@"model.lives"];
    [rightBrainController removeObserver:self forKeyPath:@"model.lives"];
    [leftBrainController removeObserver:self forKeyPath:@"model.score"];
    [rightBrainController removeObserver:self forKeyPath:@"model.score"];

    [leftBrainController removeObserver:infoBarController forKeyPath:@"model.score"];
    [rightBrainController removeObserver:infoBarController forKeyPath:@"model.score"];
    [leftBrainController removeObserver:infoBarController forKeyPath:@"model.lives"];
    [rightBrainController removeObserver:infoBarController forKeyPath:@"model.lives"];
}

- (void)dealloc {
    CCLOG(@"dealloc GameController");
    
    [self removeAllObservers];
    
	[rightBrainController release];
	[leftBrainController release];

    [infoBarController release];
	[unsentScores release];
    [achievementsDictionary release];
    [unsentAchievements release];
    
    [startTime release];
    
    [super dealloc];
}


@end

//
//  ScoreController.h
//  Hemispheres2
//
//  Created by Pit Garbe on 15.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LivesMeter, GameController;

@interface InfoBarController : NSObject {
    CCNode *view;
    GameController *controller;
    
    CCLabelBMFont *scoreLeft;
    CCLabelBMFont *scoreRight;
    
    LivesMeter *livesLeft;
    LivesMeter *livesRight;
    
    CCMenu *restartButton;
    
    CCSprite *border;
}

@property (nonatomic, assign) CCNode *view;
@property (nonatomic, assign) GameController *controller;

- (void)enableTouch:(BOOL)_enable;
- (void)hideReplayButton;
- (void)reset;

@end

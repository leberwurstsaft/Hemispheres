//
//  ScoreController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 15.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfoBarController.h"
#import "LeftBrainController.h"
#import "RightBrainController.h"
#import "LivesMeter.h"
#import "GameController.h"

@interface InfoBarController()

- (void)hitRestartButton;

@end

@implementation InfoBarController

@synthesize view, controller;

- (id)init {
	if ((self = [super init])) {
		view = [CCNode node];
        
        border = [CCSprite spriteWithFile:@"border.png" rect: CGRectMake(0, 0, 480, 64)];
        ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        [[border texture] setTexParameters: &params];
        border.anchorPoint = ccp(0.5, 1.0);
        border.position = ccp(0, 0);
        [view addChild: border];
        
        scoreLeft = [CCLabelBMFont labelWithString:@"0" fntFile:@"scorefont.fnt"];
        scoreLeft.anchorPoint = ccp(0.0, 0.5);
        scoreLeft.position = ccp(5, 25);
        [border addChild:scoreLeft];
        
        scoreRight = [CCLabelBMFont labelWithString:@"0" fntFile:@"scorefont.fnt"];
        scoreRight.anchorPoint = ccp(1.0, 0.5);
        scoreRight.position = ccp(467, 25);
        [border addChild:scoreRight];
        
        
        livesLeft = [[LivesMeter alloc] initWithLives: 3];
        livesLeft.view.position = ccp(170, 24);
        livesLeft.view.scaleX = -1.0;
        [border addChild: livesLeft.view];
        
        livesRight = [[LivesMeter alloc] initWithLives: 3];
        livesRight.view.position = ccp(310, 24);
        [border addChild: livesRight.view];

        CCMenuItemSprite *buttonItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"restart_up"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"restart_down"]  target:self selector:@selector(hitRestartButton)];
        [buttonItem setIsEnabled: NO];
        buttonItem.tag = 1;
                
        restartButton = [CCMenu menuWithItems: buttonItem, nil]; 
        restartButton.position = ccp (240, 27);
        [restartButton runAction: [CCFadeOut actionWithDuration:0.01]];
        
        [border addChild: restartButton];
    }
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //if (controller.gameRunning) {
        if ([keyPath isEqual:@"model.score"]) {
            if ([object isKindOfClass:[LeftBrainController class]]) {
                CCLOG(@"left scores 1 point");
                [scoreLeft setString: [NSString stringWithFormat:@"%@", [change objectForKey: NSKeyValueChangeNewKey]]];
            }
            else {
                CCLOG(@"right scores 1 point");
                [scoreRight setString: [NSString stringWithFormat:@"%@", [change objectForKey: NSKeyValueChangeNewKey]]];
            }
        }
        else if ([keyPath isEqual:@"model.lives"]) {
            
            int lives = [[change objectForKey: NSKeyValueChangeNewKey] intValue];
            
            if ([object isKindOfClass: [LeftBrainController class]]) {
                CCLOG(@"left loses 1 up");
                [livesLeft update: lives];
            }
            else {
                CCLOG(@"right loses 1 up");
                [livesRight update: lives];
            }
            
            if (lives < 3 && restartButton.opacity == 0 && controller.gameRunning) {
                [restartButton runAction: [CCFadeIn actionWithDuration:0.5]];
                [(CCMenuItem*)[restartButton getChildByTag: 1] setIsEnabled: YES];
            }
        }
  //  }
}

- (void)enableTouch:(BOOL)_enable {
    CCLOG(@"enable restart button: %@", _enable? @"YES":@"NO");
    restartButton.isTouchEnabled = _enable;
}

- (void)reset{
    [livesLeft reset];
    [livesRight reset];
    [scoreLeft setString:@"0"];
    [scoreRight setString:@"0"];
}

- (void)hitRestartButton {
    [livesLeft reset];
    [livesRight reset];
    [(CCMenuItem*)[restartButton getChildByTag: 1] setIsEnabled: NO];
    [restartButton runAction: [CCFadeOut actionWithDuration:0.3]];
    [controller reset];
}

- (void)hideReplayButton {
    [(CCMenuItem*)[restartButton getChildByTag: 1] setIsEnabled: NO];
    [restartButton runAction: [CCFadeOut actionWithDuration:0.3]];
}

- (void)dealloc {
    [livesLeft release];
    [livesRight release];
    
    [super dealloc];
}

@end

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

@implementation InfoBarController

@synthesize view, controller;

- (id)init {
	if ((self = [super init])) {
		view = [CCNode node];
        
        border = [CCSprite spriteWithFile:@"border.png" rect: CGRectMake(0, 0, 480, 127)];
        ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        [[border texture] setTexParameters: &params];
        border.position = ccp(0, 0);
        [view addChild: border];
        
        scoreLeft = [CCLabelBMFont labelWithString:@"68" fntFile:@"scorefont.fnt"];
        scoreLeft.anchorPoint = ccp(0.0, 0.5);
        scoreLeft.position = ccp(5, 26);
        [border addChild:scoreLeft];
        
        scoreRight = [CCLabelBMFont labelWithString:@"107" fntFile:@"scorefont.fnt"];
        scoreRight.anchorPoint = ccp(1.0, 0.5);
        scoreRight.position = ccp(465, 26);
        [border addChild:scoreRight];
        
        
        livesLeft = [[LivesMeter alloc] initWithLives: 3];
        livesLeft.view.position = ccp(170, 22);
        livesLeft.view.scaleX = -1.0;
        [border addChild: livesLeft.view];
        
        livesRight = [[LivesMeter alloc] initWithLives: 3];
        livesRight.view.position = ccp(310, 22);
        [border addChild: livesRight.view];

        restartButton = [CCSprite spriteWithFile:@"restart.png"];
        restartButton.position = ccp (240, 26);
        [border addChild: restartButton];
    }
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (controller.gameRunning) {
        CCLOG(@"observing a value @ %@", keyPath);
        if ([keyPath isEqual:@"model.score"]) {
            if ([object isKindOfClass:[LeftBrainController class]]) {
                [scoreLeft setString: [NSString stringWithFormat:@"%@", [change objectForKey: NSKeyValueChangeNewKey]]];
            }
            else {
                [scoreRight setString: [NSString stringWithFormat:@"%@", [change objectForKey: NSKeyValueChangeNewKey]]];
            }
        }
        else if ([keyPath isEqual:@"model.lives"]) {
            
            int lives = [[change objectForKey: NSKeyValueChangeNewKey] intValue];
            
            if ([object isKindOfClass: [LeftBrainController class]]) {
                CCLOG(@"update left lives");
                [livesLeft update: lives];
            }
            else {
                CCLOG(@"update right lives");
                [livesRight update: lives];
            }
        }
    }
}

- (void)dealloc {
    [livesLeft release];
    [livesRight release];
    
    [super dealloc];
}

@end

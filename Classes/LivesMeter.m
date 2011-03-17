//
//  LivesMeter.m
//  Hemispheres2
//
//  Created by Pit Garbe on 16.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LivesMeter.h"


@implementation LivesMeter

@synthesize view;

- (id)initWithLives:(int)amount {
    if ((self = [super init])) {
        view = [CCNode node];
        
        lives = [[NSMutableArray alloc] initWithCapacity: amount];
        lives2 = [[NSMutableArray alloc] initWithCapacity: amount];
        
        for (int i = 0; i < amount; i++) {
            CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"live"];
            [lives addObject: sprite];
//            sprite.blendFunc = (ccBlendFunc){GL_DST_COLOR, GL_ONE};
            sprite.position = ccp(i * 30, 0);
            [view addChild: sprite];
            
            CCSprite *sprite2 = [CCSprite spriteWithSpriteFrameName:@"live_off"];
            [lives2 addObject: sprite2];
            sprite2.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE};
            sprite2.position = ccp(i * 30, 0);
            sprite2.opacity = 0;
            sprite2.visible = NO;
            [view addChild: sprite2];

        }
        
        [self reset];
    }
    return self;
}

- (void)update:(int)remainingLives {
    CCLOG(@"updating livesmeter, remaining: %d", remainingLives);
    int totalLives = [lives count];
    
    if (remainingLives >= 0 && remainingLives < totalLives) {
        [(CCSprite*)[lives2 objectAtIndex: remainingLives] runAction:[CCSequence actions:[CCShow action], [CCFadeIn actionWithDuration:0.2], nil]];
        [(CCSprite*)[lives objectAtIndex: remainingLives] runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.2], [CCHide action], nil]];
    }
    else if (remainingLives == totalLives) {
        [self reset];
    }
}

- (void)reset {
    for (CCSprite *sprite in lives2) {
        [sprite stopAllActions];
        sprite.opacity = 0;
        sprite.visible = NO;
    }
    
    for (CCSprite *sprite in lives) {
        [sprite stopAllActions];
        sprite.opacity = 255;
        sprite.visible = YES;
    }
}

- (void)dealloc {
    [lives release];
    [lives2 release];
    [super dealloc];
}

@end

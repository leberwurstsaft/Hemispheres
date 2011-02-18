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
        
        for (int i = 0; i < amount; i++) {
            CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"live"];
            [lives addObject: sprite];
            //sprite.blendFunc = (ccBlendFunc){GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA};
            sprite.position = ccp(i * 30, 0);
            [view addChild: sprite];
        }
        
        [self reset];
    }
    return self;
}

- (void)update:(int)remainingLives {
    CCLOG(@"updating livesmeter, remaining: %d", remainingLives);
    int totalLives = [lives count];
    
    if (remainingLives < 0) {
        remainingLives = 0;
    }
    for (int i = remainingLives; i < totalLives; i++) {
        CCLOG(@"changing sprite for live # %d", i);
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"live_off"];
        [(CCSprite*)[lives objectAtIndex:i] setDisplayFrame:frame];
    }
}

- (void)reset {
    for (CCSprite *sprite in lives) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"live"];
        [sprite setDisplayFrame:frame];
    }
}

- (void)dealloc {
    [lives release];
    [view removeAllChildrenWithCleanup:YES];
    [super dealloc];
}

@end

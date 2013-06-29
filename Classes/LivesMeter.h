//
//  LivesMeter.h
//  Hemispheres2
//
//  Created by Pit Garbe on 16.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LivesMeter : NSObject {
    CCNode *view;
    
    NSMutableArray *lives;
    NSMutableArray *lives2;
    
}

@property (nonatomic, assign) CCNode *view;

- (id)initWithLives:(int)amount;
- (void)update:(int)remainingLives;
- (void)reset;

@end

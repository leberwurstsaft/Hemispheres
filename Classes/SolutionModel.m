//
//  SolutionModel.m
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import "SolutionModel.h"


@implementation SolutionModel

@synthesize left, right, operation, solution, possibleSolutions;
@synthesize time;
@synthesize score;
@synthesize lives;

- (id)init {
    self = [super init];
	lives = 3;
	time = 8.0;
	solution = 0;
	left = 0;
	right = 0;
	score = 0;
	
	nextTask = 0;
	
	[self generateTasks: 200];
    [self nextTask];
	
	return self;
}

- (void)generateTasks:(int)amount {}

- (void)nextTask {}

- (void)reset {
    CCLOG(@"resetting model");
	time	= 8.0;
	[self setScore: 0];
	[self setLives: 3];
    
    [tasks release];
    [self generateTasks: 200];
    nextTask = 0;
    
    [self nextTask];
}

- (void)increaseScore {
    if (lives > 0) {
        [self setScore: [self score]+1];
    }
}

- (void)reduceLives {
	[self setLives: [self lives]-1];
}

- (BOOL)solutionEquals:(int)_solution {
    return (solution == _solution);
}

- (void)dealloc {
    [tasks release];
    [super dealloc];
}

@end

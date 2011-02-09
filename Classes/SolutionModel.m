//
//  SolutionModel.m
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SolutionModel.h"


@implementation SolutionModel

@synthesize left, right, operation, solution, possibleSolutions;
@synthesize time;
@synthesize score;
@synthesize lives;

- (id)init {
    self = [super init];
	[self setLives: 3];
	time = 8.0;
	solution = 0;
	left = 0;
	right = 0;
	[self setScore: 0];
	
	nextTask = 0;
	
	[self generateTasks: 200];
	
	return self;
}

- (void)generateTasks:(int)amount {}

- (void)nextTask {}

- (void)reset {
	time	= 10.0;
	score	= 0;
	lives	= 3;
}

- (void)increaseScore {
	score++;
}

- (void)reduceLives {
	lives--;
}

- (BOOL)solutionEquals:(int)_solution {
    return (solution == _solution);
}

- (void)dealloc {
    [tasks release];
    [super dealloc];
}

@end

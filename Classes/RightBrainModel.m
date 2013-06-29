//
//  RightBrainModel.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import "RightBrainModel.h"


@implementation RightBrainModel

- (void)generateTasks:(int)amount {
	int i, j;
	int randomColor;
	int wrongColor;
	
	tasks = [[NSMutableArray alloc] init];
	
	int taskLeftColor = 0, taskRightColor = 0, taskSolution = 0, solution1 = 0, solution2 = 0, solution3 = 0;
	
	NSMutableArray *allColors = [[NSMutableArray alloc] init];
	for (j = 0; j < 12; j++) {
		[allColors addObject: [NSNumber numberWithInt: j]];
	}
	
	for (i=0; i<amount; i++) {
		
        // first color is primary color
		randomColor = 4 * (arc4random()%3);
		taskLeftColor = randomColor;
		
		switch (arc4random()%4) {
			case 0:
				taskSolution
                = (randomColor + 1);
				randomColor += 2;
				break;
			case 1:
				taskSolution = (randomColor + 2);
				randomColor += 4;
				break;
			case 2:
				taskSolution = (randomColor - 1);
				randomColor -= 2;
				break;
			case 3:
				taskSolution = (randomColor - 2);
				randomColor -= 4;
				break;
			default:
				break;
		}
		
		taskRightColor = (randomColor + 12) % 12;
		taskSolution = (taskSolution + 12) % 12;
		
		if (arc4random()%2) {
			int temp = taskLeftColor;
			taskLeftColor = taskRightColor;
			taskRightColor = temp;
		}
		
		int correctButton = arc4random()%3;
		switch (correctButton) {
			case 0:
				solution1 = taskSolution;
				break;
			case 1:
				solution2 = taskSolution;
				break;
			case 2:
				solution3 = taskSolution;
				break;
			default:
				break;
		}
		
		// color the wrong buttons	
		
		
		NSMutableIndexSet *indexes = [NSMutableIndexSet indexSetWithIndex: taskSolution];
		[indexes addIndex: taskLeftColor];
		[indexes addIndex: taskRightColor];
		
		NSMutableArray *availableColors = [NSMutableArray arrayWithArray: allColors];
		[availableColors removeObjectsAtIndexes: indexes];
		
		for (j = 0; j < 3; j++) {
			if (j != correctButton) {
				randomColor = arc4random()%[availableColors count];
				wrongColor = [[availableColors objectAtIndex: randomColor] intValue];
				[availableColors removeObjectAtIndex: randomColor];
				
				switch (j) {
					case 0:
						solution1 = wrongColor;
						break;
					case 1:
						solution2 = wrongColor;
						break;
					case 2:
						solution3 = wrongColor;
						break;
					default:
						break;
				}
			}
		}
		
		//NSLog(@"left: %d, right: %d, sol: %d, sol1: %d, sol2: %d, sol3: %d", taskLeftColor, taskRightColor, taskSolution, solution1, solution2, solution3);
		
		[tasks addObject: [NSArray arrayWithObjects: [NSNumber numberWithInt: taskLeftColor],
						   [NSNumber numberWithInt: taskRightColor],
						   [NSNumber numberWithInt: taskSolution],
						   [NSArray arrayWithObjects:	[NSNumber numberWithInt: solution1],
                            [NSNumber numberWithInt: solution2],
                            [NSNumber numberWithInt: solution3],
                            nil],
						   nil]
		 ];
	}
	[allColors release];
}

- (void)nextTask { 
	NSArray *task       = [tasks objectAtIndex: nextTask];
	left                = [[task objectAtIndex: 0] integerValue];
	right               = [[task objectAtIndex: 1] integerValue];
	solution            = [[task objectAtIndex: 2] integerValue];
	possibleSolutions   = [task objectAtIndex: 3];
    operation           = @"+";
	
	nextTask++;
}

@end

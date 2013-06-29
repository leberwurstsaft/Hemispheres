//
//  LeftBrainModel.m
//  Hemispheres
//
//  Created by Pit Garbe on 30.08.09.
//  Copyright 2009 Pit Garbe. All rights reserved.
//

#import "LeftBrainModel.h"


@implementation LeftBrainModel

- (void)generateTasks:(int)amount {
   
    int i;
    int randomNumber;
    
    tasks = [[NSMutableArray alloc] init];
    
    NSString *taskOperation = @"";
    
    int taskLeftNumber = 0, taskRightNumber = 0, taskSolution = 0, solution1 = 0, solution2 = 0, solution3 = 0;
    for (i=0; i<amount; i++) {
        // generate task
        
        switch (arc4random()%4) {
            case 0:
                // addition
                randomNumber = 1 + arc4random()%8;
                taskLeftNumber = randomNumber;
                randomNumber = 1 + arc4random()%(9-taskLeftNumber);
                taskRightNumber = randomNumber;
                taskSolution = taskRightNumber + taskLeftNumber;
                taskOperation = @"+";
                break;
            case 1:
                // subtraction
                randomNumber = 2 + arc4random()%8;
                taskLeftNumber = randomNumber;
                randomNumber = 1 + arc4random()%(taskLeftNumber - 1);
                taskRightNumber = randomNumber;
                taskSolution = taskLeftNumber - taskRightNumber;
                taskOperation = @"-";
                break;
            case 2:
                // mulitplication
                randomNumber = 1 + arc4random()%9;
                taskLeftNumber = randomNumber;
                randomNumber = 1 + arc4random()%((int)floor(9 / taskLeftNumber));
                taskRightNumber = randomNumber;
                taskSolution = taskLeftNumber * taskRightNumber;
                taskOperation = @"x"; //@"×";
                break;
            case 3:
                // division
                randomNumber = 1 + arc4random()%9;
                taskLeftNumber = randomNumber;
                switch (taskLeftNumber) {
                    case 1:
                        randomNumber = 1;
                        break;
                    case 2:
                        randomNumber = 1 + arc4random()%2;
                        break;
                    case 3:
                        switch(arc4random()%2) {
                            case 0:
                                randomNumber = 1;
                                break;
                            case 1:
                                randomNumber = 3;
                                break;
                            default:
                                break;
                        }
                        break;
                    case 4:
                        switch(arc4random()%3) {
                            case 0:
                                randomNumber = 1;
                                break;
                            case 1:
                                randomNumber = 2;
                                break;
                            case 2:
                                randomNumber = 4;
                                break;
                            default:
                                break;
                        }
                        break;
                    case 5:
                        switch(arc4random()%2) {
                            case 0:
                                randomNumber = 1;
                                break;
                            case 1:
                                randomNumber = 5;
                                break;
                            default:
                                break;
                        }
                        break;
                    case 6:
                        switch(arc4random()%4) {
                            case 0:
                                randomNumber = 1;
                                break;
                            case 1:
                                randomNumber = 2;
                                break;
                            case 2:
                                randomNumber = 3;
                                break;
                            case 3:
                                randomNumber = 6;
                                break;
                            default:
                                break;
                        }
                        break;
                    case 7:
                        switch(arc4random()%2) {
                            case 0:
                                randomNumber = 1;
                                break;
                            case 1:
                                randomNumber = 7;
                                break;
                            default:
                                break;
                        }
                        break;
                    case 8:
                        switch(arc4random()%4) {
                            case 0:
                                randomNumber = 1;
                                break;
                            case 1:
                                randomNumber = 2;
                                break;
                            case 2:
                                randomNumber = 4;
                                break;
                            case 3:
                                randomNumber = 8;
                                break;
                            default:
                                break;
                        }
                        break;
                    case 9:
                        switch(arc4random()%3) {
                            case 0:
                                randomNumber = 1;
                                break;
                            case 1:
                                randomNumber = 3;
                                break;
                            case 2:
                                randomNumber = 9;
                                break;
                            default:
                                break;
                        }
                        break;
                        
                    default:
                        break;
                }
                taskRightNumber = randomNumber;
                taskSolution = taskLeftNumber / taskRightNumber;
                taskOperation = @"÷";
            default:
                break;
        }
        
        // generate three solutions
        int correctButton = arc4random()%3;
        
        BOOL foundFreeNumber = NO;
        int firstWrongNumber;
        
        switch (correctButton) {
            case 0:
                //	NSLog(@"korrekt: Links");
                solution1 = taskSolution;
                
                while (!foundFreeNumber) {
                    randomNumber = 1 + arc4random()%9;
                    if (randomNumber !=  taskSolution) {
                        foundFreeNumber = YES;
                        firstWrongNumber = randomNumber;
                        solution2 = randomNumber;
                    }
                }
                
                foundFreeNumber = NO;
                while (!foundFreeNumber) {
                    randomNumber = 1 + arc4random()%9;
                    if (randomNumber != taskSolution && randomNumber != firstWrongNumber) {
                        foundFreeNumber = YES;
                        solution3 = randomNumber;
                    }
                }
                
                break;
            case 1:
                //	NSLog(@"korrekt: Mitte");
                solution2 = taskSolution;
                
                while (!foundFreeNumber) {
                    randomNumber = 1 + arc4random()%9;
                    if (randomNumber != taskSolution) {
                        foundFreeNumber = YES;
                        firstWrongNumber = randomNumber;
                        solution1 = randomNumber;
                    }
                }
                
                foundFreeNumber = NO;
                while (!foundFreeNumber) {
                    randomNumber = 1 + arc4random()%9;
                    if (randomNumber != taskSolution && randomNumber != firstWrongNumber) {
                        foundFreeNumber = YES;
                        solution3 = randomNumber;
                    }
                }
                
                break;
            case 2:
                //	NSLog(@"korrekt: Rechts");
                solution3 = taskSolution;
                
                while (!foundFreeNumber) {
                    randomNumber = 1 + arc4random()%9;
                    if (randomNumber != taskSolution) {
                        foundFreeNumber = YES;
                        firstWrongNumber = randomNumber;
                        solution1 = randomNumber;
                    }
                }
                
                foundFreeNumber = NO;
                while (!foundFreeNumber) {
                    randomNumber = 1 + arc4random()%9;
                    if (randomNumber != taskSolution && randomNumber != firstWrongNumber) {
                        foundFreeNumber = YES;
                        solution2 = randomNumber;
                    }
                }
                
                break;
            default:
                break;
        }
        
        [tasks addObject: [NSArray arrayWithObjects:
                           [NSNumber numberWithInt: taskLeftNumber],
                           [NSNumber numberWithInt: taskRightNumber],
                           taskOperation,
                           [NSNumber numberWithInt: taskSolution],
                           [NSArray arrayWithObjects:
                            [NSNumber numberWithInt: solution1],
                            [NSNumber numberWithInt: solution2],
                            [NSNumber numberWithInt: solution3],
                            nil],
                           nil]
         ];
        
    }
}

- (void)nextTask {
    if (nextTask >= [tasks count]) {
        nextTask = 0;
    }
    CCLOG(@"loading task # %i", nextTask);
    
	NSArray *task       = [tasks objectAtIndex: nextTask];
	left                = [[task objectAtIndex: 0] integerValue];
	right               = [[task objectAtIndex: 1] integerValue];
	operation           = [task objectAtIndex: 2];
	solution            = [[task objectAtIndex: 3] integerValue];
	possibleSolutions	= [task objectAtIndex: 4];
	
	nextTask++;
}


@end

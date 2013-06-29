//
//  SolutionModel.h
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SolutionModel : NSObject {
	int solution;
    
    int left;
    int right;
    NSString *operation;
    
    NSArray *possibleSolutions;
    
    NSMutableArray *tasks;
    
    double time;
    int score;
    int lives;
    
    int nextTask;
}

@property (nonatomic) int left;
@property (nonatomic) int right;
@property (nonatomic, assign) NSString *operation;
@property (nonatomic) int solution;
@property (nonatomic, assign) NSArray *possibleSolutions;
@property (nonatomic) double time;
@property (nonatomic) int score;
@property (nonatomic) int lives;

- (BOOL)solutionEquals:(int)_solution;
- (void)generateTasks:(int)amount;
- (void)nextTask;

- (void)reduceLives;
- (void)increaseScore;
- (void)reset;


@end

//
//  SolutionButton.h
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SolutionSprite;

@interface SolutionButton : NSObject {
	SolutionSprite *representation;
	
	int solution;
}

- (id)initWithColor;
- (id)initWithNumber;
- (void)effect;

@property (nonatomic, assign) SolutionSprite *representation;
@property (nonatomic, assign) int solution;

@end
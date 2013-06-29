//
//  SolutionButton.h
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SolutionSprite;

@interface SolutionButton : NSObject {
	SolutionSprite *representation;
	
	int solution;
    int buttonType;
    
    CCParticleSystem *particleSystem;
}

- (id)initWithColor;
- (id)initWithNumber;
- (void)effect;
- (void)effect:(BOOL)right;
- (void)initParticleSystem;

@property (nonatomic, assign) SolutionSprite *representation;
@property (nonatomic, assign) int solution;

@end

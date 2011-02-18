//
//  SolutionButton.m
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SolutionButton.h"
#import "SolutionSprite.h"
#import "ColorSprite.h"
#import "NumberSprite.h"
#import "cocos2d.h"

typedef enum
{
	kButtonTypeColor = 0,
	kButtonTypeNumber = 1,
} ButtonTypes;

@interface SolutionButton()

- (void)initParticleSystem;

@end


@implementation SolutionButton

@synthesize representation;

@dynamic solution;


- (id)initWithColor {
	if ( ( self = [super init])) {

		representation = [ColorSprite sprite];
        
        [self initParticleSystem];
        particleSystem.blendFunc = (ccBlendFunc){GL_DST_ALPHA, GL_ONE_MINUS_SRC_ALPHA};

        buttonType = kButtonTypeColor;
	}
	return self;
}

- (id)initWithNumber {
	if ( ( self = [super init])) {

		representation = [NumberSprite sprite];
        
        [self initParticleSystem];
        particleSystem.startColor = (ccColor4F){1.0, 1.0, 1.0, 0.6};
		particleSystem.endColor = (ccColor4F){1.0, 1.0, 1.0, 0.3};
        particleSystem.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE};

        buttonType = kButtonTypeNumber;
	}
	return self;
}

- (void)initParticleSystem {
    particleSystem = [CCParticleSystemQuad particleWithFile:@"explosion.plist"];

    particleSystem.positionType = kCCPositionTypeFree;
    particleSystem.position = ccp(representation.contentSize.width/2.0, representation.contentSize.height/2.0);
    
    [representation addChild: particleSystem z:-1];
}

- (int)solution {
	return solution;
}

- (void)setSolution:(int)_s {
	solution = _s;
	
	[representation setSolution: solution];
}

- (void)effect {

	ccColor4F startColor;
	ccColor4F endColor;
	
	if (buttonType == kButtonTypeColor) {
		CCLOG(@"color class");
		switch (solution) {
			case 0:
				startColor = (ccColor4F){1.0, 0.0, 0.0, 1.0};
				break;
			case 1:
				startColor = (ccColor4F){1.0, 0.4, 0.0, 1.0};
				break;
			case 2:
				startColor = (ccColor4F){1.0, 0.58, 0.0, 1.0};
				break;
			case 3:
				startColor = (ccColor4F){1.0, 0.77, 0.0, 1.0};
				break;
			case 4:
				startColor = (ccColor4F){1.0, 0.99, 0.0, 1.0};
				break;
			case 5:
				startColor = (ccColor4F){0.55, 0.78, 0.0, 1.0};
				break;
			case 6:
				startColor = (ccColor4F){0.06, 0.67, 0.0, 1.0};
				break;
			case 7:
				startColor = (ccColor4F){0.0, 0.64, 0.78, 1.0};
				break;
			case 8:
				startColor = (ccColor4F){0.0, 0.39, 0.71, 1.0};
				break;
			case 9:
				startColor = (ccColor4F){0.0, 0.07, 0.65, 1.0};
				break;
			case 10:
				startColor = (ccColor4F){0.39, 0.0, 0.64, 1.0};
				break;
			case 11:
				startColor = (ccColor4F){0.77, 0.0, 0.49, 1.0};
				break;
			default:
				startColor = (ccColor4F){0.06, 0.67, 0.0, 1.0};
				break;
		}
		endColor = startColor;
		endColor.a = 0.5;
        
        particleSystem.startColor = startColor;
        particleSystem.endColor = endColor;	
	}

    [particleSystem resetSystem];
}

@end

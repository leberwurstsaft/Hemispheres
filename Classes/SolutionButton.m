//
//  SolutionButton.m
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SolutionButton.h"
#import "ColorSprite.h"
#import "NumberSprite.h"
#import "cocos2d.h"

typedef enum
{
	kButtonTypeColor = 0,
	kButtonTypeNumber = 1,
} ButtonTypes;

@implementation SolutionButton

@synthesize representation;

@dynamic solution;


- (id)initWithColor {
	if ( ( self = [super init])) {
		representation = [ColorSprite sprite];
	}
	return self;
}

- (id)initWithNumber {
	if ( ( self = [super init])) {
		representation = [NumberSprite sprite];
	}
	return self;
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
	
	if ([representation isKindOfClass: [ColorSprite class]]) {
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
		endColor.a = 0.7;
	}
	else {
		startColor = (ccColor4F){1.0, 0.77, 0.5, 0.6};
		endColor = (ccColor4F){1.0, 1.0, 1.0, 0.3};
	}

	// remove any previous particle FX 
	//[[representation parent] removeChildByTag:99 cleanup:YES];
	CCParticleSystem* system;
	system = [CCParticleSystemQuad particleWithFile:@"explosion.plist"];
	system.positionType = kCCPositionTypeFree;
	system.position = representation.position;
	system.startColor = startColor;
	system.endColor = endColor;
	
	//system.blendFunc = (ccBlendFunc){GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA};  // bright background
	// DST_ALPHA  ONE_MINUS_SRC_ALPHA  ist auch gut, bei beiden helligkeiten
	
/*
    int b1 = [[NSUserDefaults standardUserDefaults] integerForKey:@"HemiBlendFuncOne"];
	int b2 = [[NSUserDefaults standardUserDefaults] integerForKey:@"HemiBlendFuncTwo"];
*/
    if ([representation isKindOfClass:[ColorSprite class]]) {
        system.blendFunc = (ccBlendFunc){GL_DST_ALPHA, GL_ONE_MINUS_SRC_ALPHA};
    }
    else {
        system.blendFunc = (ccBlendFunc){GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA};
    }
    system.autoRemoveOnFinish = YES;
	
	[[representation parent] addChild: system z:1 tag:99];
}




@end

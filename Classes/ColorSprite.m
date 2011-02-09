//
//  ColorSprite.m
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ColorSprite.h"

@interface ColorSprite (PrivateMethods)
	- (id) initWithColor;
@end

@implementation ColorSprite

+(id) sprite
{
	return [[[self alloc] initWithColor] autorelease];
}

-(id) initWithColor
{
	if ((self = [super initWithSpriteFrameName:@"color1"]))
	{

	}
	return self;
}

- (void) setSolution:(int)_solution	{
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"color%d", _solution + 1]];
	[self setDisplayFrame:frame];
}

-(void) dealloc
{
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end

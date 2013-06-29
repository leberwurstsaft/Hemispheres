//
//  NumberSprite.m
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import "NumberSprite.h"




@interface NumberSprite (PrivateMethods)
- (id) initWithNumber;
@end

@implementation NumberSprite

+(id) sprite
{
	return [[[self alloc] initWithNumber] autorelease];
}

-(id) initWithNumber
{
	if ((self = [super init]))
	{
		label = [CCLabelBMFont labelWithString:@"0" fntFile:@"numberfont.fnt"];
		[self addChild: label];
	}
	return self;
}

- (void)setOpacity:(GLubyte)_opacity {
	label.opacity = _opacity;
}

- (void) setSolution:(int)_solution {
	[label setString: [NSString stringWithFormat:@"%d", _solution]];
}

-(void) dealloc
{
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end

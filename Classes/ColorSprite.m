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
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
    
    int splashNumber = arc4random()%5;
    
	if ((self = [super initWithSpriteFrameName:[NSString stringWithFormat:@"splash%d", splashNumber]]))
	{

	}
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_Default];
	return self;
}

- (void) setSolution:(int)_solution	{
    int splashNumber = arc4random()%5;
    
	CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"splash%d", splashNumber]];
	[self setDisplayFrame:frame];
    
    ccColor3B _color;
    
    switch (_solution) {
        case 0:
            _color = (ccColor3B){255, 0, 0};
            break;
        case 1:
            _color = (ccColor3B){255, 102, 0};
            break;
        case 2:
            _color = (ccColor3B){255, 148, 0};
            break;
        case 3:
            _color = (ccColor3B){255, 198, 0};
            break;
        case 4:
            _color = (ccColor3B){255, 252, 0};
            break;
        case 5:
            _color = (ccColor3B){141, 199, 0};
            break;
        case 6:
            _color = (ccColor3B){16, 172, 0};
            break;
        case 7:
            _color = (ccColor3B){0, 190, 164};
            break;
        case 8:
            _color = (ccColor3B){0, 99, 182};
            break;
        case 9:
            _color = (ccColor3B){0, 18, 166};
            break;
        case 10:
            _color = (ccColor3B){99, 0, 164};
            break;
        case 11:
            _color = (ccColor3B){178, 0, 111};
            break;
        default:
            _color = (ccColor3B){255, 148, 0};
            break;
    }
    
    self.color = _color;
}

-(void) dealloc
{
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end

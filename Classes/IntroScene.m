//
//  IntroScene.m
//  Hemispheres2
//
//  Created by Pit Garbe on 11.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IntroScene.h"

@implementation IntroScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	
	IntroScene *layer = [IntroScene node];
	
	[scene addChild: layer];
	
	return scene;
}

-(id) init
{
	if( (self = [super init] )) {
        
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(120, 0, 0, 255)];
		[self addChild:colorLayer z:-2 tag:10];
    }
    return self;
}

@end

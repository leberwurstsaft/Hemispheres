//
//  LostScene.m
//  Hemispheres2
//
//  Created by Pit Garbe on 11.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LostScene.h"
#import "GameScene.h"

@implementation LostScene

+(id) scene
{
	CCScene *scene = [CCScene node];
	
	LostScene *layer = [LostScene node];
	
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

- (void)onEnterTransitionDidFinish {
    CCLOG(@"entered");
    //[[CCDirector sharedDirector] purgeCachedData];

    funFactBubble = [CCSprite spriteWithFile:@"bubble.png"];
    funFactBubble.position = ccp(240, 160);
    [self addChild: funFactBubble];
    
    funFactText = [CCLabelTTF labelWithString:@"Did you know?\nAll Kinds of stuff\nAll Kinds of stuff\nAll Kinds of stuff goes here." dimensions:CGSizeMake(400, 300) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:40.0];
    funFactText.color = ccBLACK;
    funFactText.scale = 0.6;
    funFactText.scaleY = 0.4;
    funFactText.position = ccp(200, 150);
    [funFactBubble addChild: funFactText];
    
    float x, y, z;
    [[funFactText camera] eyeX:&x eyeY:&y eyeZ:&z];
    [[funFactText camera] setEyeX:x+30 eyeY:y+13 eyeZ:z+100];
    
    [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
	[CCMenuItemFont setFontSize:16];
        	
	CCMenuItemFont *item1 = [CCMenuItemFont itemFromString:@"DUDE!" target:self selector:@selector(touched:)];
	item1.tag = 71;
    [(CCMenuItemFont*)item1 setColor: ccBLACK];
    
	CCMenu* menu = [CCMenu menuWithItems:item1, nil];
	menu.tag = 70;
	
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
	menu.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
	[self addChild:menu];
    
}

- (void)touched:(CCMenuItem *)sender {
    
    [[CCDirector sharedDirector] performSelector:@selector(replaceScene:) withObject:[GameScene node] afterDelay:0.0];

}

@end

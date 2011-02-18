//
//  LostScene.h
//  Hemispheres2
//
//  Created by Pit Garbe on 11.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LostScene : CCLayer {
    CCLabelTTF *funFactText;
    CCSprite *funFactBubble;
}

+(id) scene;

@end

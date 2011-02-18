//
//  GameScene.h
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ColorSprite.h"
#import "NumberSprite.h"
#import "GameController.h"

#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
#import "CDAudioManager.h"

@interface GameLayer : CCLayer {
    GameController *gameController;
}

- (void)showDrapes:(BOOL)_show;

@end

@interface GameScene : CCScene {
    GameLayer *gameLayer;
    
	int blendFunc, blendFunc2;
}

- (void)setTouchEnabled:(BOOL)_enable;
- (void)showDrapes:(BOOL)_show;

/*
- (void)menuItem1Touched:(CCMenuItem *)sender;
- (void)menuItem2Touched:(CCMenuItem *)sender;
 
- (void)menuItem3Touched:(CCMenuItem *)sender;
- (void)menuItem4Touched:(CCMenuItem *)sender;
 */

@end


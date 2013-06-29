//
//  GameScene.h
//  Hemispheres2
//
//  Created by Pit Garbe on 01.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ColorSprite.h"
#import "NumberSprite.h"
#import "GameController.h"

#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
#import "CDAudioManager.h"
#import "TextBoxLayer.h"

@interface GameLayer : CCLayer <TextBoxDelegate> {
    GameController *gameController;
    TextBoxLayer *lostText;
    
    float kHitDistance;
    float offsetRightSide;
}

@property (nonatomic, retain) TextBoxLayer *lostText;

- (void)showDrapes:(BOOL)_show;
- (void)gameLoop:(ccTime) dT;
- (void)showTextBox:(CGPoint)pos size:(CGSize)size text:(NSString*)text;

@end

@interface GameScene : CCScene {
    GameLayer *gameLayer;
}

- (void)setTouchEnabled:(BOOL)_enable;
- (void)showDrapes:(BOOL)_show;
- (void)showTextBox:(CGPoint)pos size:(CGSize)size text:(NSString*)text;



@end


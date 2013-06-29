//
//  IntroScene.h
//  Hemispheres2
//
//  Created by Pit Garbe on 11.02.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface IntroLayer : CCLayer {
    NSMutableArray *textures;
    NSMutableArray *sounds;
    
    int numberOfLoadedTextures;
    int numberOfLoadedSounds;
}

@property (nonatomic, retain) NSMutableArray *textures;
@property (nonatomic, retain) NSMutableArray *sounds;

- (void)changeVolume:(CCMenuItem*)sender;

- (void)hitAchievementsButton:(CCMenuItem*)sender;
- (void)hitScoreButton:(CCMenuItem*)sender;
- (void)hitPlayButton:(CCMenuItem*)sender;

- (void)play;

- (void)imageDidLoad:(CCTexture2D*)tex;
- (void)preloadSoundEffect:(NSString *)effect;

- (void)animate;

- (void)showAnalyticsConfirmDialog;
- (void)hideAchievementsBadge;

@end

@interface IntroScene: CCScene {
    IntroLayer *layer;
}

- (void)hideAchievementsBadge;

@end
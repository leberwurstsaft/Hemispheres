//
//  IntroScene.m
//  Hemispheres2
//
//  Created by Pit Garbe on 11.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IntroScene.h"
#import "GameScene.h"
#import "Hemispheres2AppDelegate.h"
#import "RootViewController.h"
#import "CCLayerDialog.h"
#import "LocalyticsSession.h"
#import <GameKit/GameKit.h>

@implementation IntroScene

- (id)init {
	if((self = [super init])) {
        [[CCDirector sharedDirector] setProjection:CCDirectorProjection2D];
        
       
        layer = [IntroLayer node];
        
        [self addChild: layer];
        layer.tag = 1;

		layer.isTouchEnabled = NO;
        
	}
	return self;
}

- (void)hideAchievementsBadge {
    CCLOG(@"hiding achievement badge");
    [layer hideAchievementsBadge];
}

@end


@implementation IntroLayer

@synthesize textures, sounds;

-(id) init
{
	if( (self = [super init] )) {
        [[CCDirector sharedDirector] setProjection:kCCDirectorProjection2D];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:@"HemispheresRanOnce"]) {
            [defaults setBool:YES forKey:@"HemispheresRanOnce"];
            [defaults setFloat:100 forKey:@"HemispheresSoundVolume"];
            [defaults synchronize];
        }

        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"textures.plist"];
        [frameCache addSpriteFramesWithFile:@"background-blurred.plist"];
        [frameCache addSpriteFramesWithFile:@"brain.plist"];
        [frameCache addSpriteFramesWithFile:@"title.plist"];
        [frameCache addSpriteFramesWithFile:@"menu.plist"];

        
        CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"background-blurred"];
        background.position = ccp(240, 160);
		[self addChild:background z:-2 tag:10];
        
        CCSprite* title = [CCSprite spriteWithSpriteFrameName:@"title"];
        title.anchorPoint = ccp(0, 0);
        title.position = ccp(5, 200);
        CCLOG(@"content size: %f, %f", title.contentSizeInPixels.width, title.contentSizeInPixels.height);
        title.tag = 21;
		[self addChild:title];

        
        CCMenuItem *item1 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"brainiacs"] selectedSprite:nil target:self selector:@selector(hitScoreButton:)];
        item1.anchorPoint = ccp(1.0, 1.0);
        
        CCMenuItem *item2 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"play"] selectedSprite:nil target:self selector:@selector(hitPlayButton:)];
        
        CCMenuItem *item3 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"trophies"] selectedSprite:nil target:self selector:@selector(hitAchievementsButton:)];
        item3.anchorPoint = ccp(0, 1.0);
        
        CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, nil];
        
        double delta = floor(item2.contentSize.width / 2.0 - 12.0);
        item1.position = ccp(-delta, 5);
        
        delta = floor(item2.contentSize.width / 2.0 - 12.0);
        item3.position = ccp(delta, 5);
        
//        delta = round(item1.position.x + item3.position.x) ;
        delta = round((item1.contentSize.width - item2.contentSize.width) / 2.0);
        CCLOG(@"delta: %f", delta);
        
        CCLOG(@"item1 position: %f, %f", item1.position.x, item1.position.y);
        CCLOG(@"item3 position: %f, %f", item3.position.x, item3.position.y);

        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        
        // hmmmmmm ! 
        CCLOG(@"position: %f, %f", windowSize.width/2.0, windowSize.height/2.0);
        menu.position = ccp(240 + delta, 170);
        CCLOG(@"menu position: %f, %f", menu.position.x, menu.position.y);
        menu.anchorPoint = ccp(0.5, 0.5);
        menu.tag = 20;
        menu.visible = NO;
        menu.isTouchEnabled = YES;
        [self addChild: menu z:2];
        
        CCSprite *badge = [CCSprite spriteWithFile:@"badge.png"];
        badge.tag = 26;
        badge.opacity = 0;
        badge.visible = NO;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey: [NSString stringWithFormat:@"HemispheresNewAchievements-%d", [GKLocalPlayer localPlayer].playerID]]) {
            CCLOG(@"badge should be visible");
            badge.visible = YES;
        }
        else {
            CCLOG(@"badge should not be visible");
        }
        
        badge.position = ccp(menu.position.x + item3.position.x + item3.contentSize.width - badge.contentSize.width/2.0, menu.position.y + item3.position.y - item3.contentSize.height - 2);
        [self addChild:badge z:0];
        
        float volume = [[NSUserDefaults standardUserDefaults] floatForKey:@"HemispheresSoundVolume"];
        
        CCMenuItem *speaker = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"speaker%d", (int)volume]] selectedSprite:nil target:self selector:@selector(changeVolume:)];
        CCMenu *speakerMenu = [CCMenu menuWithItems:speaker, nil];
        speaker.anchorPoint = ccp(0, 0);
        speakerMenu.position = ccp(5, 5);
        speakerMenu.tag = 25;
        speakerMenu.visible = NO;
        [self addChild:speakerMenu];
        
        CCSprite *brain = [CCSprite spriteWithSpriteFrameName:@"brain"];
        brain.tag = 22;
        brain.scale = 0.6;
        brain.anchorPoint = ccp(0.5, 0.0);
        brain.position = ccp(240, -1.0);
        
        [self addChild: brain];
        
        CCLabelBMFont *loadingText = [CCLabelBMFont labelWithString:@" " fntFile:@"tutorial.fnt"];
        loadingText.position = ccp(240, 30);
        loadingText.opacity = 0;
        [self addChild:loadingText z:2 tag:2];
        [loadingText runAction:[CCFadeIn actionWithDuration:0.3]];
    }
    return self;
}

- (void)hideAchievementsBadge {
    [(CCSprite*)[self getChildByTag: 26] setVisible: NO];
}

- (void)hitAchievementsButton:(CCMenuItem*)sender {
    CCLOG(@"show achievements");
    
    if  ([[(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] viewController] isGameCenterAvailable]) {
        [(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] performSelector:@selector(showAchievements) withObject:nil afterDelay:0.2];
    }
    else {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@"NO_GAMECENTER_TITLE", nil) message: NSLocalizedString(@"NO_GAMECENTER_MESSAGE", nil)
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:@"OK", nil];
        [myAlert show];
    }
}

- (void)changeVolume:(CCMenuItem *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    float volume = [defaults floatForKey:@"HemispheresSoundVolume"];
    
    if (volume == 100) {
        volume = 50;
    }
    else if (volume == 50) {
        volume = 0;
    }
    else if (volume == 0) {
        volume = 100;
    }
    
    [defaults setFloat:volume forKey:@"HemispheresSoundVolume"];
    [defaults synchronize];
    
    [(CCMenuItemSprite*)sender setNormalImage:[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"speaker%d", (int)volume]]];
}

- (void)play {
    id tran = [CCTransitionCrossFade transitionWithDuration:0.5 scene:[GameScene node]];
    [[CCDirector sharedDirector] replaceScene: tran];
}

- (void)hitPlayButton:(CCMenuItem*)sender {

    CCMenu* menu = (CCMenu*)[self getChildByTag:20];
    [menu runAction:[CCSequence actions: [CCDelayTime actionWithDuration:0.2], [CCSpawn actions: [CCFadeOut actionWithDuration:0.2], [CCMoveBy actionWithDuration:0.2 position:ccp(0, 100)],  nil], nil]];
    
   
    [(CCSprite*)[self getChildByTag:21] runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.2], [CCSpawn actions: [CCFadeOut actionWithDuration:0.2], [CCMoveBy actionWithDuration:0.2 position:ccp(0, 150)], nil], nil]];
    
    [(CCSprite*)[self getChildByTag:22] runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.2], [CCSpawn actions: [CCFadeOut actionWithDuration:0.2], [CCMoveBy actionWithDuration:0.2 position:ccp(0, -150)], nil], nil]];

    [(CCSprite*)[self getChildByTag:26] runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.2], [CCSpawn actions: [CCFadeOut actionWithDuration:0.2], [CCMoveBy actionWithDuration:0.2 position:ccp(0, 150)], nil], nil]];

    [(CCMenu*)[self getChildByTag:25] runAction:[CCSequence actions: [CCDelayTime actionWithDuration:0.2], [CCMoveBy actionWithDuration:0.2 position:ccp(0, -150)], nil]];
    
    [self performSelector:@selector(play) withObject:nil afterDelay:0.5];
}

- (void)hitScoreButton:(CCMenuItem *)sender {
    CCLOG(@"show leaderboards");
    
    if  ([[(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] viewController] isGameCenterAvailable]) {
        [(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] performSelector:@selector(showLeaderBoard) withObject:nil afterDelay:0.2];
    }
    else {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:NSLocalizedString(@"NO_GAMECENTER_TITLE", nil) message: NSLocalizedString(@"NO_GAMECENTER_MESSAGE", nil)
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:@"OK", nil];
        [myAlert show];
        [myAlert release];
    }
}

- (void) onEnter {
	[super onEnter];
    
	
    NSError *error;
	NSArray *bundleContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[NSBundle mainBundle] bundlePath] error:&error];
    
	self.textures = [NSMutableArray arrayWithCapacity:[bundleContents count]];
    self.sounds = [NSMutableArray arrayWithCapacity:[bundleContents count]];
    
    NSSet *filesToIgnore = [NSSet setWithObjects: @"Icon-72.png",
                            @"Icon-Small-50.png",
                            @"Icon-Small.png",
                            @"Icon-Small@2x.png",
                            @"Icon.png",
                            @"Icon@2x.png",
                            @"Default.png",
                            @"Default@2x.png",
                            nil];
    
	for(NSString *file in bundleContents) {
		if([[file pathExtension] compare:@"png"] == NSOrderedSame) {

            NSRange range = [[file lastPathComponent] rangeOfString:@"-hd"];
            BOOL loadThisImage = NO;
            if ((range.location > 0 && range.location < 100000000) && CC_CONTENT_SCALE_FACTOR() > 1.0) {
                loadThisImage = YES;
            }
            
            if (!(range.location > 0 && range.location < 100000000) && CC_CONTENT_SCALE_FACTOR() == 1.0) {
                loadThisImage = YES;
            }
            
            if (![filesToIgnore containsObject:[file lastPathComponent]] && loadThisImage) {
                [textures addObject:[file lastPathComponent]];
                CCLOG(@"preloading %@",file);
            }
		}
        else if([[file pathExtension] compare:@"caf"] == NSOrderedSame) {
            [sounds addObject: [file lastPathComponent]];
		}
	}
    
	numberOfLoadedTextures = 0;
	[(CCLabelBMFont*)[self getChildByTag:2] setString:NSLocalizedString(@"LOADING", nil)];
    
	[[CCTextureCache sharedTextureCache] addImageAsync:[textures objectAtIndex:numberOfLoadedTextures] target:self selector:@selector(imageDidLoad:)];
     
}

- (void)showAnalyticsConfirmDialog {
    CCLOG(@"confirm analytics");
    
    BOOL decided = [[NSUserDefaults standardUserDefaults] boolForKey:@"HemispheresDecidedOnAnalytics"];
    
    if (!decided) {
        // run Analytics once, to get info on device, and tag event in case of disallowance. Then never again.
        [[LocalyticsSession sharedLocalyticsSession] startSession:@"6207366bda1eb4b40a855bb-b42ab02c-442d-11e0-c452-007af5bd88a0"];
        
        CCLayerDialog *dialog = [CCLayerDialog
                                 initWithTitle: NSLocalizedString(@"ANALYTICS_TITLE", @"")
                                 message: NSLocalizedString(@"ANALYTICS_TEXT", @"")
                                 target: self
                                 selector: @selector(onDialogButton:)];
        [dialog addButtonWithTitle:NSLocalizedString(@"BUTTON_YES", @"")];
        [dialog addButtonWithTitle:NSLocalizedString(@"BUTTON_NO", @"")];
        [dialog show:self];
    }
}

- (void)onDialogButton:(NSInteger) buttonIndex
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HemispheresDecidedOnAnalytics"];
    
	if(buttonIndex==0){
        CCLOG(@"YES BUTTON");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HemispheresWantAnalytics"];
        
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Opt-in to Localytics"];

	} else {
        CCLOG(@"NO BUTTON");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HemispheresWantAnalytics"];
        
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Opt-out of Localytics"];
        [[LocalyticsSession sharedLocalyticsSession] close];
        [[LocalyticsSession sharedLocalyticsSession] upload];
	}
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) imageDidLoad:(CCTexture2D*)tex {
	NSString *plistFile =
    [[(NSString*)[textures objectAtIndex:numberOfLoadedTextures] stringByDeletingPathExtension] stringByAppendingString:@".plist"];
    
	if([[NSFileManager defaultManager] fileExistsAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:plistFile]]) {
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistFile];
		CCLOG(@"loading %@", plistFile);
	}
    
	numberOfLoadedTextures++;
	    
	if(numberOfLoadedTextures == [textures count]) {
        [self performSelector:@selector(preloadSoundEffect:) withObject:[sounds objectAtIndex: 0]];
	} else {
		[[CCTextureCache sharedTextureCache] addImageAsync:[textures objectAtIndex:numberOfLoadedTextures] target:self selector:@selector(imageDidLoad:)];
	}
}

- (void)preloadSoundEffect:(NSString *)effect {

    [[SimpleAudioEngine sharedEngine] preloadEffect: [sounds objectAtIndex:numberOfLoadedSounds]];
    numberOfLoadedSounds++;

    if(numberOfLoadedSounds == [sounds count]) {
        [self performSelector:@selector(animate) withObject:nil afterDelay:1.0];
	} else {
        [self performSelector:@selector(preloadSoundEffect:) withObject:[sounds objectAtIndex: numberOfLoadedSounds]];
	}
}

- (void)animate {
    CCLOG(@"animate intro");
    
    id scale = [CCScaleTo actionWithDuration:1.0 scale:1.0];
    id scale_ease = [CCEaseOut actionWithAction:scale rate:3.0];
    
    id move = [CCMoveBy actionWithDuration:1.0 position:ccp(0, -300.5)];
    id move_ease = [CCEaseOut actionWithAction:move rate:3.0];
    
    [(CCLabelBMFont*)[self getChildByTag:2] runAction:[CCFadeOut actionWithDuration:0.3]];
    [(CCSprite*)[self getChildByTag:22] runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.3], [CCSpawn actions:move_ease, scale_ease, nil], nil]];
    [(CCSprite*)[self getChildByTag:26] runAction: [CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCFadeIn actionWithDuration:0.3], nil]];
    
    
    [(CCMenu*)[self getChildByTag:25] runAction: [CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCShow action], [CCFadeIn actionWithDuration:0.3], nil]];
    [(CCMenu*)[self getChildByTag:20] runAction: [CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCShow action], [CCFadeIn actionWithDuration:0.3], [CCCallFunc actionWithTarget:self selector:@selector(showAnalyticsConfirmDialog)], nil]];
}

- (void) dealloc {
	[textures release];
    [sounds release];
    [super dealloc];
}

                             
@end

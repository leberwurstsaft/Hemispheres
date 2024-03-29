//
//  Hemispheres2AppDelegate.h
//  Hemispheres2
//
//  Created by Pit Garbe on 28.01.11.
//  Copyright Pit Garbe 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface Hemispheres2AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    BOOL                gameCenterFeaturesEnabled;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, readonly) RootViewController *viewController;
@property (nonatomic) BOOL gameCenterFeaturesEnabled;

- (void)showLeaderBoard;
- (void)showAchievements;

- (void)showIntro;

@end

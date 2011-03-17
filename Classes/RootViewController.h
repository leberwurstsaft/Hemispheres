//
//  RootViewController.h
//  Hemispheres2
//
//  Created by Pit Garbe on 28.01.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface RootViewController : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate> {
    BOOL gameCenterFeaturesEnabled;
}

@property (nonatomic) BOOL gameCenterFeaturesEnabled;

- (void)authenticateGKPlayer;
- (void)showLeaderBoard;
- (BOOL)isGameCenterAvailable;
- (void)registerForAuthenticationNotification;
- (void)showAchievements;

@end

//
//  RootViewController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 28.01.11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import "Hemispheres2AppDelegate.h"
#import "Reachability.h"
#import "IntroScene.h"


@implementation RootViewController

@synthesize gameCenterFeaturesEnabled;

- (void)viewDidAppear:(BOOL)animated {
    if ([self isGameCenterAvailable]) {
        CCLOG(@"going to authenticate player");
        [self authenticateGKPlayer];
    }
    else {
        CCLOG(@"no gamecenter!");
        [(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] setGameCenterFeaturesEnabled: NO];
    }
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect;
	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
    glView.multipleTouchEnabled = YES;
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Game Center

- (BOOL)isGameCenterAvailable {
    // This is taken straight from Apple's documentation
    // Check for presence of GKLocalPlayer API.
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // The device must be running running iOS 4.1 or later.
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice]
                            systemVersion];
    
    BOOL osVersionSupported = ([currSysVer
                                compare:reqSysVer options:NSNumericSearch]
                               != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}


-(void)authenticateGKPlayer {
	GKLocalPlayer *localPlayer	= [GKLocalPlayer localPlayer];
	
    if (![[GKLocalPlayer localPlayer] isAuthenticated]) {
        CCLOG(@"authenticating player");

        [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
            if (!error) {
                CCLOG(@"no game center error :)");

                [(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] setGameCenterFeaturesEnabled: YES];
                [self registerForAuthenticationNotification];
                
//                [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
//                    if (error == nil) {
//                        CCLOG(@"deleted all achievements!! HAHAHAHAHA!");
//                    }
//                }];
                
            }
            else {
                CCLOG(@"game center error: %@", error);
                [(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] setGameCenterFeaturesEnabled: NO];
            }
        }];
    }
}

- (void)registerForAuthenticationNotification {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver: self
           selector:@selector(authenticationChanged)
               name:GKPlayerAuthenticationDidChangeNotificationName
             object:nil];
}

- (void) authenticationChanged {
    if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
        [(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] setGameCenterFeaturesEnabled: YES];
    }
    else {
        [(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] setGameCenterFeaturesEnabled: NO];
    }
}

- (void)showLeaderBoard {
    CCLOG(@"showing leaderboard if gamecenter enabled");
    Reachability *r = [Reachability reachabilityForInternetConnection];
    
    if (![[GKLocalPlayer localPlayer] isAuthenticated] || ![r isReachable]) {
        if ([(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] gameCenterFeaturesEnabled]) {
            if (![r isReachable]) {
                UIAlertView *myAlert = [[UIAlertView alloc]
                                        initWithTitle:NSLocalizedString(@"OFFLINE_TITLE", nil) message: NSLocalizedString(@"OFFLINE_MESSAGE", nil)
                                        delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"OK", nil];
                [myAlert show];
                [myAlert release];
            }
        }
    }
    else {
        if ([(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] gameCenterFeaturesEnabled]) {
            GKLeaderboardViewController *lbVC = [[GKLeaderboardViewController alloc] init];
            lbVC.timeScope = GKLeaderboardTimeScopeWeek;
            
            if (lbVC != nil) {
                [lbVC setLeaderboardDelegate: self];
                [self presentModalViewController: lbVC animated:YES];
            }
        }
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
	[self dismissModalViewControllerAnimated: YES];
}

- (void)showAchievements {
    CCLOG(@"showing achievements if gamecenter enabled");
    Reachability *r = [Reachability reachabilityForInternetConnection];
    
    if (![[GKLocalPlayer localPlayer] isAuthenticated] || ![r isReachable]) {
        if ([(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] gameCenterFeaturesEnabled]) {
            if (![r isReachable]) {
                UIAlertView *myAlert = [[UIAlertView alloc]
                                        initWithTitle:NSLocalizedString(@"OFFLINE_TITLE", nil) message: NSLocalizedString(@"OFFLINE_MESSAGE", nil)
                                        delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"OK", nil];
                [myAlert show];
                [myAlert release];
            }
        }
    }
    else {
        if ([(Hemispheres2AppDelegate*)[[UIApplication sharedApplication] delegate] gameCenterFeaturesEnabled]) {
            
            GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
            if (achievements != nil) {
                CCLOG(@"showing achievements for player %@", [GKLocalPlayer localPlayer]);
                
                achievements.achievementDelegate = self;
                [self presentModalViewController: achievements animated: YES];
            }
        }
    }
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
    [self dismissModalViewControllerAnimated:YES];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"HemispheresNewAchievements-%d", [GKLocalPlayer localPlayer].playerID]];
    
    CCScene *current = [[CCDirector sharedDirector] runningScene];
    if ([current isKindOfClass: [IntroScene class]]) {
        [(IntroScene*)current hideAchievementsBadge];
    }
    else {
        CCLOG(@"current scene is not Intro!");
    }
    
}

#pragma mark -

- (void)dealloc {
    [super dealloc];
}


@end


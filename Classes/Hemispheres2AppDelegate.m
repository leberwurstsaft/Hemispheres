//
//  Hemispheres2AppDelegate.m
//  Hemispheres2
//
//  Created by Pit Garbe on 28.01.11.
//  Copyright Pit Garbe 2011. All rights reserved.
//

#import "cocos2d.h"

#import "Hemispheres2AppDelegate.h"
#import "GameConfig.h"
#import "GameScene.h"
#import "IntroScene.h"
#import "RootViewController.h"
#import "LocalyticsSession.h"
#import "Appirater.h"

#import "TestScene.h"

@implementation Hemispheres2AppDelegate

@synthesize window, viewController, gameCenterFeaturesEnabled;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
    CCLOG(@"removing startup flicker");
	CC_ENABLE_DEFAULT_GL_STATES();
	CCDirector *director = [CCDirector sharedDirector];
	CGSize size = [director winSize];
    CCSprite *sprite;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        sprite = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
    }
    else {
        if (CC_CONTENT_SCALE_FACTOR() == 2.0) {
            sprite = [CCSprite spriteWithFile:@"Default@2x.png"];
        }
        else {
            sprite = [CCSprite spriteWithFile:@"Default.png"];
        }
        sprite.rotation = +90;
    }
	sprite.position = ccp(size.width/2, size.height/2);
	[sprite visit];
	[[director openGLView] swapBuffers];
	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	[director setAlphaBlending: YES];
	
	if( ![director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGBA8	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
    glView.multipleTouchEnabled = YES;
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
//	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
	// Run the intro Scene
    //id scene = [GameScene node];
	[[CCDirector sharedDirector] runWithScene: [IntroScene node]];
    
#if !defined(DEBUG)
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HemispheresWantAnalytics"]) {
        [[LocalyticsSession sharedLocalyticsSession] startSession:@"6207366bda1eb4b40a855bb-b42ab02c-442d-11e0-c452-007af5bd88a0"];
    }
#endif
    
    // 403106600 --> Hemispheres
    [Appirater appLaunchedWithID:403106600];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    CCScene * current = [[CCDirector sharedDirector] runningScene];

    if ([current isKindOfClass:[GameScene class]]) {
        [(GameScene*)current showDrapes:YES];
    }
    [[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    CCScene * current = [[CCDirector sharedDirector] runningScene];
    
    if ([current  isKindOfClass:[GameScene class]]) {
        [(GameScene*)current showDrapes:NO];
    }
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
    
#if !defined(DEBUG)
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HemispheresWantAnalytics"]) {
        [[LocalyticsSession sharedLocalyticsSession] close];
        [[LocalyticsSession sharedLocalyticsSession] upload];
    }
#endif
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
    [Appirater applicationWillEnterForeground];
    
#if !defined(DEBUG)
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HemispheresWantAnalytics"]) {
        [[LocalyticsSession sharedLocalyticsSession] resume];
        [[LocalyticsSession sharedLocalyticsSession] upload];
    }
#endif
}

- (void)applicationWillTerminate:(UIApplication *)application {
#if !defined(DEBUG)
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HemispheresWantAnalytics"]) {
        [[LocalyticsSession sharedLocalyticsSession] close];
        [[LocalyticsSession sharedLocalyticsSession] upload];
    }
#endif
    
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];

	[director end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

#pragma mark Game Center

- (void)showLeaderBoard {
    [viewController showLeaderBoard];
}

- (void)showAchievements {
    [viewController showAchievements];
}

- (void)showIntro {
    id tran = [CCTransitionCrossFade transitionWithDuration:0.5 scene:[IntroScene node]]; 
    [[CCDirector sharedDirector] replaceScene: tran];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end

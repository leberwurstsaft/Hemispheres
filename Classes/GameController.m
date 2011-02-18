//
//  GameController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "GameController.h"
#import "LeftBrainController.h"
#import "RightBrainController.h"
#import "InfoBarController.h"
#import "LivesMeter.h"
#import "LostScene.h"

@interface GameController()

- (UIImage*) screenshotUIImage;
- (CCTexture2D*) screenshotTexture;
- (UIImage *)convertImageToGrayScale:(UIImage *)image;
- (void)removeAllObservers;
- (void)enableTouch:(BOOL)_enable;

@end

@implementation GameController

@synthesize gameRunning, view, leftBrainController, rightBrainController;

- (id)init {
	if (( self = [super init])) {
		view = [CCNode node];
        
        int offset = 240.0;
        
        infoBarController = [[InfoBarController alloc] init];
        infoBarController.controller = self;
        infoBarController.view.position = ccp(240, 440);
        [view addChild: infoBarController.view z:3];

		leftBrainController = [[LeftBrainController alloc] init];
        [leftBrainController addObserver:infoBarController forKeyPath:@"model.score" options:NSKeyValueObservingOptionNew context:NULL];
        [leftBrainController addObserver:infoBarController forKeyPath:@"model.lives" options:NSKeyValueObservingOptionNew context:NULL];
        [leftBrainController addObserver:self forKeyPath:@"model.lives" options:NSKeyValueObservingOptionNew context:NULL];
  
		leftBrainController.controller = self;
        leftBrainController.view.position = ccp(-offset, 0);
		[view addChild: leftBrainController.view z:0];

		rightBrainController = [[RightBrainController alloc] init];
        [rightBrainController addObserver:infoBarController forKeyPath:@"model.score" options:NSKeyValueObservingOptionNew context:NULL];
        [rightBrainController addObserver:infoBarController forKeyPath:@"model.lives" options:NSKeyValueObservingOptionNew context:NULL];
        [rightBrainController addObserver:self forKeyPath:@"model.lives" options:NSKeyValueObservingOptionNew context:NULL];
        
		rightBrainController.controller = self;
		rightBrainController.view.position = ccp(240+offset,0);
		[view addChild: rightBrainController.view z:1];
        
        [self reset];
       
        CCMoveBy *move = [CCMoveBy actionWithDuration: 0.6 position:ccp(offset, 0)];
        CCMoveBy *move_back = (CCMoveBy *)[move reverse];
        
        CCEaseIn *move_ease = [CCEaseIn actionWithAction:move rate:3.0f];
        CCEaseIn *move_ease_back = [CCEaseIn actionWithAction:move_back rate:3.0f];
        
        CCMoveBy *move_down = [CCMoveBy actionWithDuration: 0.6 position: ccp(0, -100)];
        CCEaseOut *move_down_ease = [CCEaseOut actionWithAction:move_down rate:3.0f];
        
        [leftBrainController.view runAction: move_ease];
        [rightBrainController.view runAction: move_ease_back];
        [infoBarController.view runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.5], move_down_ease, [CCCallFunc actionWithTarget:self selector:@selector(beginNewGame)],nil]];  
        
        drapes = [CCSprite spriteWithFile:@"drapes.png" rect: CGRectMake(0, 0, 480, 320)];
        drapes.position = ccp(240, 160);
        ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
        [[drapes texture] setTexParameters: &params];
        drapes.visible = NO;
        [view addChild: drapes z:2];

        
		roundTime = 0;
	}
	return self;
}


- (int)totalScore {
	return [leftBrainController score] + [rightBrainController score];
}

- (double)roundTime {
	if (roundTime == 0) {
		roundTime = [leftBrainController time];
	}
	
	roundTime -= cbrt((float)[self totalScore]) / 70.0;
	if (roundTime < 1.0) {
		roundTime = 1.0;
	}
	
	return roundTime;
}

- (void)showDrapes:(BOOL)_show {
    if (gameRunning) {
        drapes.visible = _show;
    }
}

- (void)pauseGame {
	CCLOG(@"pause game");
    
    [leftBrainController pause];
    [rightBrainController pause];
}

- (void)resumeGame {
	[leftBrainController resume];
	[rightBrainController resume];
}

- (void)reset {
	roundTime = 0.0;
	[leftBrainController reset];
	[rightBrainController reset];
    [leftBrainController newTask];
    [rightBrainController newTask];
}

- (void)beginNewGame {
	gameRunning = YES;
    [self enableTouch:YES];
	
	[leftBrainController go];
	[rightBrainController go];
}

- (void)enableTouch:(BOOL)_enable {
    id current = [[CCDirector sharedDirector] runningScene];
    if ([current isKindOfClass:[GameScene class]]) {
        [(GameScene*)current setTouchEnabled: _enable];
    }
}

- (void)playAgain {
    [self reset];
	[self performSelector:@selector(beginNewGame) withObject: nil afterDelay:0.02];	
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CCLOG(@"observing a value @ %@", keyPath);
    if (gameRunning) {
        if ([keyPath isEqual:@"model.lives"]) {
            
            int lives = [[change objectForKey: NSKeyValueChangeNewKey] intValue];
            
            if (lives == 0) {
                [self performSelector:@selector(endGame) withObject:nil afterDelay:0.1];
            }  
        }
    }
}

- (void)endGame {
	CCLOG(@"end game");
    if (gameRunning) {
        gameRunning = NO;
        [self removeAllObservers];
        
        [self pauseGame];
        [self enableTouch:NO];
        
        [self fadeToGray];
        
        id tran = [CCTransitionFadeBL transitionWithDuration:1.0 scene:[LostScene scene]];
        
        [[CCDirector sharedDirector] replaceScene: tran];
    }
}

- (void)fadeToGray {
    [[CCDirector sharedDirector] setDisplayFPS:NO];
	UIImage *img = [self convertImageToGrayScale: [self screenshotUIImage]];
    [[CCDirector sharedDirector] setDisplayFPS:YES];
    
	CCTexture2D *mTex = [[CCTexture2D alloc] initWithImage:img];
	CCSprite *sprite = [CCSprite spriteWithTexture: mTex];
	sprite.position = ccp(240, 160);
	sprite.opacity = 0;
    [view addChild: sprite z:10];
    [sprite runAction: [CCFadeIn actionWithDuration:0.5]];
    [mTex release];
}
     
- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object  
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

- (UIImage*) screenshotUIImage
{
	CGSize displaySize	= [[CCDirector sharedDirector] displaySizeInPixels];
	CGSize winSize		= [[CCDirector sharedDirector] winSizeInPixels];
	
	//Create buffer for pixels
	GLuint bufferLength = displaySize.width * displaySize.height * 4;
	GLubyte* buffer = (GLubyte*)malloc(bufferLength);
	
	//Read Pixels from OpenGL
	glReadPixels(0, 0, displaySize.width, displaySize.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	//Make data provider with data.
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);
	
	//Configure image
	int bitsPerComponent = 8;
	int bitsPerPixel = 32;
	int bytesPerRow = 4 * displaySize.width;
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
	CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
	CGImageRef iref = CGImageCreate(displaySize.width, displaySize.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
	
	uint32_t* pixels = (uint32_t*)malloc(bufferLength);
	CGContextRef context = CGBitmapContextCreate(pixels, winSize.width, winSize.height, 8, winSize.width * 4, CGImageGetColorSpace(iref), kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	
	CGContextTranslateCTM(context, 0, displaySize.height);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	switch ([CCDirector sharedDirector].deviceOrientation)
	{
		case CCDeviceOrientationPortrait: break;
		case CCDeviceOrientationPortraitUpsideDown:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(180));
			CGContextTranslateCTM(context, -displaySize.width, -displaySize.height);
			break;
		case CCDeviceOrientationLandscapeLeft:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(-90));
			CGContextTranslateCTM(context, -displaySize.height, 0);
			break;
		case CCDeviceOrientationLandscapeRight:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(90));
			CGContextTranslateCTM(context, displaySize.height-displaySize.width, -displaySize.height);
			break;
	}
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, displaySize.width, displaySize.height), iref);
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	UIImage *outputImage = [[[UIImage alloc] initWithCGImage:imageRef] autorelease];
	
	//Dealloc
	CGImageRelease(imageRef);
	CGDataProviderRelease(provider);
	CGImageRelease(iref);
	CGColorSpaceRelease(colorSpaceRef);
	CGContextRelease(context);
	free(buffer);
	free(pixels);
	
	return outputImage;
}

- (CCTexture2D*) screenshotTexture
{
	return [[[CCTexture2D alloc] initWithImage:[self screenshotUIImage]] autorelease];
}

- (void)exitGame {
	//[rootVC showIntro];
	[leftBrainController performSelector: @selector(reset) withObject:nil afterDelay:0.1];
	[rightBrainController performSelector: @selector(reset) withObject: nil afterDelay: 0.1];
}

/*- (void)enterScores {
	NSLog(@"enterScore()");
	
	[self reportScore:[self totalScore] forCategory:@"1"];
	[self reportScore:[leftBrainController score] forCategory:@"2"];
	[self reportScore:[rightBrainController score] forCategory:@"3"];
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
	
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		if (error != nil)
		{
			NSLog(@"error transmitting score %@", error);
            NSData *archivedScore = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
			//[self saveScoreToSendLater: archivedScore];
        }
		else {
			NSLog(@"successfully sent score: %lld", score);
		}
    }];
}
*/

- (void)removeAllObservers {
    [leftBrainController removeObserver:self forKeyPath:@"model.lives"];
    [rightBrainController removeObserver:self forKeyPath:@"model.lives"];
    [leftBrainController removeObserver:infoBarController forKeyPath:@"model.score"];
    [rightBrainController removeObserver:infoBarController forKeyPath:@"model.score"];
    [leftBrainController removeObserver:infoBarController forKeyPath:@"model.lives"];
    [rightBrainController removeObserver:infoBarController forKeyPath:@"model.lives"];
}

- (void)dealloc {
    CCLOG(@"dealloc GameController");
	[rightBrainController release];
	[leftBrainController release];

    [infoBarController release];

    [super dealloc];
}


@end

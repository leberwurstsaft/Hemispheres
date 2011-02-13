//
//  GameController.m
//  Hemispheres2
//
//  Created by Pit Garbe on 05.02.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "LeftBrainController.h"
#import "RightBrainController.h"
#import "AWTextureFilter.h"
#import "LostScene.h"

@interface GameController()

- (UIImage*) screenshotUIImage;
- (CCTexture2D*) screenshotTexture;
- (UIImage *)convertImageToGrayScale:(UIImage *)image;

@end

@implementation GameController

@synthesize gameRunning, view, leftBrainController, rightBrainController;

- (id)init {
	if (( self = [super init])) {
		view = [CCNode node];
        
        int offset = 240.0;
        int gap = 2.0;
        
        CCSprite *bg_left_shadow = [CCSprite spriteWithSpriteFrameName:@"bg_left_shadow"];
        bg_left_shadow.position = ccp(239-offset+gap, 160);
       // [view addChild: bg_left_shadow];

        CCSprite *bg_right_shadow = [CCSprite spriteWithSpriteFrameName:@"bg_right_shadow"];
        bg_right_shadow.position = ccp(240.5+offset-gap, 160);
       // [view addChild: bg_right_shadow];
        
        CCSprite *bg_left = [CCSprite spriteWithSpriteFrameName:@"bg_left"];
        bg_left.anchorPoint = ccp(0, 0.5);
        bg_left.position = ccp(0-offset-gap, 160);
       // [view addChild: bg_left];
        
        CCSprite *bg_right = [CCSprite spriteWithSpriteFrameName:@"bg_right"];
        bg_right.anchorPoint = ccp(1, 0.5);
        bg_right.position = ccp(480+offset+gap, 160);
       // [view addChild: bg_right];
        

		leftBrainController = [[LeftBrainController alloc] init];
		leftBrainController.controller = self;
        leftBrainController.view.position = ccp(-offset, 0);
		[view addChild: leftBrainController.view];

		rightBrainController = [[RightBrainController alloc] init];
		rightBrainController.controller = self;
		rightBrainController.view.position = ccp(240+offset,0);
		[view addChild: rightBrainController.view];
  
        CCMoveBy *move = [CCMoveBy actionWithDuration: 0.6 position:ccp(offset, 0)];
        CCMoveBy *move_back = (CCMoveBy *)[move reverse];
        
        CCEaseIn *move_ease = [CCEaseIn actionWithAction:[move copy] rate:3.0f];
        CCEaseIn *move_ease_back = [CCEaseIn actionWithAction:[move_back copy] rate:3.0f];;
        
        [leftBrainController.view runAction: [move_ease copy]];
        [bg_left_shadow runAction: [move_ease copy]];
        [bg_left runAction: [move_ease copy]];
        
        [rightBrainController.view runAction: [move_ease_back copy]];
        [bg_right_shadow runAction: [move_ease_back copy]];
        [bg_right runAction: [move_ease_back copy]];
        
        
        whatNextLayer = [[CCNode node] retain];
        CCSprite *playAgainButton = [CCSprite spriteWithFile:@"again_button.png"];
        playAgainButton.anchorPoint = ccp(1.0, 0.5);
        playAgainButton.position = ccp(480, 160);
        [whatNextLayer addChild: playAgainButton];
		
		roundTime = 0;

        [self prepareGame];
        [self beginNewGame];
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
	
	//NSLog(@"minus %f", cbrt((float)[self totalScore]) / 70.0);
	roundTime -= cbrt((float)[self totalScore]) / 70.0;
	if (roundTime < 1.0) {
		roundTime = 1.0;
	}
	
	if (roundTime > 1.0) {
		//[soundEngine updateBeepPitch: roundTime];
	}
	
	return roundTime;
}

- (void)pauseGame {
	NSLog(@"pause game");
	[rightBrainController pause];
	[leftBrainController pause];
	//[soundEngine stopBeep];
}

- (void)resumeGame {
	[leftBrainController resume];
	[rightBrainController resume];
	//[soundEngine makeBeep];
}

- (void)prepareGame {
	[leftBrainController reset];
	[rightBrainController reset];
	[self reset];
	[leftBrainController newTask];
	[rightBrainController newTask];
}

- (void)reset {
	roundTime = 0.0;
}

- (void)beginNewGame {
	gameRunning = YES;
	
	[leftBrainController go];
	[rightBrainController go];
	//[soundEngine performSelector:@selector(makeBeep) withObject:nil afterDelay:1.0];
}

- (void)playAgain {
	[self prepareGame];
	[self performSelector:@selector(beginNewGame) withObject: nil afterDelay:0.02];	
}

- (void)endGame {
	NSLog(@"end game");
	gameRunning = NO;
	
	[self pauseGame];

	[self showWhatNextLayer];
    
    id tran = [CCTransitionFadeBL transitionWithDuration:1.0 scene:[LostScene scene]];
    
    [[CCDirector sharedDirector] replaceScene: tran];
}

- (void)showWhatNextLayer {
    CCLOG(@"blur");
	UIImage *img = [self convertImageToGrayScale: [self screenshotUIImage]];
    
	CCTexture2DMutable *mTex = [[CCTexture2DMutable alloc] initWithImage:img];
	CCSprite *sprite = [CCSprite spriteWithTexture: mTex];
	sprite.position = ccp(240, 160);
	
    [view addChild: sprite];

    CCLOG(@"blur done");
    
  //  [desk release];
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


- (void)dealloc {
    [whatNextLayer release];
	[rightBrainController release];
	[leftBrainController release];
//	[lostGameController release];
//	[soundEngine release];
    [super dealloc];
}


@end

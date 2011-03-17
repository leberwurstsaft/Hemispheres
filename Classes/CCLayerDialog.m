//
//  CCDialogLayer.m
//  Hemispheres2
//
//  Created by Pit Garbe on 02.03.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import "CCLayerDialog.h"

@implementation CCLayerDialog

@synthesize menu = _menu;

+(id) initWithTitle:(NSString *)title
		    message:(NSString *)message
			 target:(id)target
		   selector:(SEL)selector
{
	return [[[super alloc] initWithTitle:title message:message target:target selector:selector] autorelease];
}

-(id) initWithTitle:(NSString *)title
		    message:(NSString *)message
			 target:(id)target
		   selector:(SEL)selector
{
	if((self=[super init])) {
        [self setIsTouchEnabled:YES];

		NSMethodSignature *sig = [[target class] instanceMethodSignatureForSelector:selector];
		callback = [NSInvocation invocationWithMethodSignature:sig];
		[callback setTarget:target];
		[callback setSelector:selector];
		[callback retain];
        
        
        CCLayerColor *bg = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 0)];
        [self addChild: bg z:0 tag:1];

		CCLabelBMFont *headerLabel = [CCLabelBMFont labelWithString:title fntFile:@"tutorial.fnt"];
		[headerLabel setAnchorPoint:ccp(0.5, 1.0)];
		[headerLabel setPosition:ccp(self.contentSize.width/2, self.contentSize.height - 10)];
        headerLabel.opacity = 0;
		[self addChild:headerLabel z:1 tag:2];
        

        CCLabelTTF *messageLabel = [CCLabelTTF labelWithString:NSLocalizedString(@"ANALYTICS_TEXT", nil) dimensions:CGSizeMake(400, 200) alignment:UITextAlignmentLeft fontName:@"ArialRoundedMTBold" fontSize:16];
        messageLabel.color = ccc3(255, 255, 200);

		[messageLabel setAnchorPoint:ccp(0.5, 0.5)];
		[messageLabel setPosition:ccp(self.contentSize.width/2, self.contentSize.height/2)];
        messageLabel.opacity = 0;
		[self addChild:messageLabel z:1 tag:3];
        
		self.menu = [CCMenu menuWithItems: nil];
		[self.menu setAnchorPoint:ccp(0.5,0)];
		[self.menu setPosition:ccp(self.contentSize.width/2, 20.5)];
		[self addChild:self.menu z:1 tag:4];
	}
	return self;
}

-(void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

-(void) onButtonPressed:(id) sender
{
	NSInteger buttonIndex = [sender tag];
	[callback setArgument:&buttonIndex atIndex:2];
	[callback invoke];
	[self removeFromParentAndCleanup:YES];
}

-(id) addButtonWithTitle:(NSString *)title
{
	CCMenuItemFont *button = [CCMenuItemFont itemWithLabel:[CCLabelBMFont labelWithString:title fntFile:@"tutorial.fnt"] target:self selector:@selector(onButtonPressed:)];
	[button setTag: [[self.menu children] count]];
	[self.menu addChild: button];
    
	[self.menu alignItemsHorizontallyWithPadding:40];
	return button;
}

-(void) show:(CCNode*) parent
{
    CCLOG(@"showing dialog layer");
    [self.menu setOpacity: 0];
    
	[parent addChild: self z:50 tag:200];
    
    id fade = [CCFadeTo actionWithDuration:0.3 opacity: 200];
    
    [(CCLayerColor*)[self getChildByTag:1] runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.3], fade, nil]];
    
    id fade2 = [CCFadeIn actionWithDuration:0.3];
    
    [(CCLabelTTF*)[self getChildByTag:2] runAction:[CCSequence actions: [CCDelayTime actionWithDuration:0.3], [fade2 copy], nil]];
    [(CCLabelBMFont*)[self getChildByTag:3] runAction:[CCSequence actions: [CCDelayTime actionWithDuration:0.3], [fade2 copy], nil]];
    [(CCMenu*)[self getChildByTag:4] runAction:[CCSequence actions: [CCDelayTime actionWithDuration:0.3], fade2, nil]];
}

-(void) dealloc
{
	[callback release];
	[super dealloc];
}

BOOL buttonTouched;
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	buttonTouched = [self.menu ccTouchBegan:touch withEvent:event];
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(buttonTouched) [self.menu ccTouchEnded:touch withEvent:event];
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(buttonTouched) [self.menu ccTouchCancelled:touch withEvent:event];
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(buttonTouched) [self.menu ccTouchMoved:touch withEvent:event];
}

@end
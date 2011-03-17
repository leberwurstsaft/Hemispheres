//
//  CCDialogLayer.h
//  Hemispheres2
//
//  Created by Pit Garbe on 02.03.11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCLayerDialog : CCLayer {
	NSInvocation *callback;
	CCMenu *_menu;
}

@property (nonatomic, retain) CCMenu *menu;

+(id) initWithTitle:(NSString *)title
		    message:(NSString *)message
			 target:(id)callbackObj
		   selector:(SEL)selector;

-(id) initWithTitle:(NSString *)title
		    message:(NSString *)message
             target:(id)callbackObj
           selector:(SEL)selector;
-(id) addButtonWithTitle:(NSString *) title;

-(void) show:(CCNode*) parent;
-(void) registerWithTouchDispatcher;
@end
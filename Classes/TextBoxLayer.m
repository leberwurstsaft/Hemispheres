//
//  TextBoxLayer.m
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 1/19/11.
//  Copyright 2011 Pit Garbe. All rights reserved.
//

#import "TextBoxLayer.h"

@implementation TextBoxLayer

@synthesize delegate;

- (id) initWithColor:(ccColor4B)color width:(GLfloat)w height:(GLfloat)h padding:(GLfloat)padding text:(NSString *)txt {
	if ((self = [super initWithColor:color width:w + (padding * 2) height:h + (padding * 2)])) {
		
		self.isTouchEnabled = YES;
		
		ended = NO;
		currentPageIndex = 0;
		
		CCBMFontConfiguration *conf = FNTConfigLoadFile(TEXT_FONT_FILE);
		linesPerPage = h*CC_CONTENT_SCALE_FACTOR() / conf->commonHeight_;
		
		NSArray *words = [txt componentsSeparatedByString:@" "];
		
		NSMutableString *wrappedText = [NSMutableString string];
		
		lines = [[NSMutableArray alloc] init];
        CCLOG(@"w = %f", w);
		for (NSString *word in words) {
            if ([word isEqual:@"\n"]) {
                [lines addObject:[NSString stringWithString:wrappedText]];
				[wrappedText setString:@""];
            }
            else {
                NSString *eval = [wrappedText stringByAppendingFormat:@" %@", word];
                int size = [self calculateStringSize:eval];
                
                // See if the text so far plus the new word fits the rect
                if (size > w * CC_CONTENT_SCALE_FACTOR()) {
                    
                    // If not, closes this line and starts a new one
                    [lines addObject:[NSString stringWithString:wrappedText]];
                    [wrappedText setString:word];
                } else {
                    [wrappedText appendFormat:@" %@", word];
                }
            }
		}
		[lines addObject:[NSString stringWithString:wrappedText]];
		
		totalPages = ceil((float)[lines count] / linesPerPage);
		
		text = [txt retain];
		
		textLabel = [CCLabelBMFont labelWithString:[self nextPage] fntFile:TEXT_FONT_FILE];
		textLabel.anchorPoint = ccp(0,1);
		textLabel.position = ccp(padding, h + padding);
		
		// Hides all characters in the label
		for (CCNode *node in textLabel.children) {
			CCSprite *charSpr = (CCSprite *)node;
			charSpr.visible = NO;
		}
		
		[self addChild:textLabel];
	}
	return self;
}

- (void)dealloc {
	[text release];
	[lines release];
	[currentPage release];
	[super dealloc];
}

- (void)update:(float)dt {
	
	progress += (dt * TEXT_SPEED);
	
	int visible = progress;
	
	if (visible > currentPageCharCount) {
		progress = visible = currentPageCharCount;
	}
	
	// Each character sprite is assigned a tag corresponding to its index in the string,
	// and even though line-breaks are skipped, they are still counted for tag purposes.
	// Therefore, we use an offset so that the tag is correct.
	int offset = 0;
	
	for (int i = 0; i < visible; i++) {
		
		if ([currentPage characterAtIndex:i + offset] == '\n') {
			offset++;
		}
		
		CCSprite *charSpr = (CCSprite *) [textLabel getChildByTag:i + offset];
		charSpr.visible = YES;
	}
}

- (NSString *)nextPage {
	progress = 0;
	
	[currentPage release];
	currentPage = [[NSMutableString string] retain];
	
	currentPageCharCount = 0;
	
	int line = currentPageIndex * linesPerPage;
	
	int i = 0;
	while (i < linesPerPage && line < [lines count]) {
		[currentPage appendFormat:@"%@\n", [lines objectAtIndex:line]];
		currentPageCharCount += [[lines objectAtIndex:line] length];
		i++;
		line++;
	}
	currentPageIndex++;
	return currentPage;
}

- (int)calculateStringSize:(NSString *)txt {
	CCBMFontConfiguration *conf = FNTConfigLoadFile(TEXT_FONT_FILE);
	
	int totalSize = 0;
	
	for (int i = 0; i < [txt length]; i++) {
		
		int c = [txt characterAtIndex:i];
		ccBMFontDef def = conf->BMFontArray_[c];
		totalSize += def.xAdvance;
	}
	CCLOG(@"calculate text size for: %@ ---> %d", txt, totalSize);
	return totalSize;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (progress < currentPageCharCount) {
        progress = currentPageCharCount;

		for (CCNode *node in textLabel.children) {
			CCSprite *charSpr = (CCSprite *)node;
			charSpr.visible = YES;
		}
		
	} else {
		if (currentPageIndex < totalPages) {
            [textLabel removeAllChildrenWithCleanup:YES];
			[textLabel setString:[self nextPage]];
			
			for (CCNode *node in textLabel.children) {
				CCSprite *charSpr = (CCSprite *)node;
				charSpr.visible = NO;
			}
			
			if ([delegate respondsToSelector:@selector(textBox:didMoveToPage:)]) {
				[delegate textBox:self didMoveToPage:currentPageIndex];
			}
			
		} else {
			
			if (!ended) {
				ended = YES;
				
				if ([delegate respondsToSelector:@selector(textBox:didFinishAllTextWithPageCount:)]) {
					[delegate textBox:self didFinishAllTextWithPageCount:totalPages];
				}
			}
		}
	}
}

@end

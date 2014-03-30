//
//  AutosizingTextView.m
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "AutoSizingTextView.h"
#import "CustomDelegateScrollView.h"

@implementation AutoSizingTextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
    NSScrollView *scrollView = [self enclosingScrollView];
    scrollView.frame = scrollView.superview.frame;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CustomDelegateScrollView *scrollView = (CustomDelegateScrollView*)[self enclosingScrollView];
    DDLogVerbose(@"scrollView.magnification: %.0f", scrollView.magnification);
    
}

- (NSRange)selectionRangeForProposedRange:(NSRange)proposedSelRange granularity:(NSSelectionGranularity)granularity
{
    if (granularity == NSSelectByCharacter || granularity == NSSelectByWord) {
        
        if (proposedSelRange.length > 0) {
            
            NSRange doubleRange = [[self textStorage] doubleClickAtIndex:proposedSelRange.location];
            
            if (doubleRange.location != NSNotFound)
            {
                NSInteger nextWordIndex = [[self textStorage] nextWordFromIndex:(proposedSelRange.location + proposedSelRange.length) forward:NO];
                NSRange lastWordRange = [[self textStorage] doubleClickAtIndex:nextWordIndex];
                if (lastWordRange.location != NSNotFound) {
                    return NSMakeRange(doubleRange.location, lastWordRange.location + lastWordRange.length - doubleRange.location);
                } else {
                    return NSMakeRange(doubleRange.location, nextWordIndex - doubleRange.location);
                }
            }
            
            return proposedSelRange;
        } else {
            return [[self textStorage] doubleClickAtIndex:proposedSelRange.location];
        }
        
    } else {
        return [super selectionRangeForProposedRange:proposedSelRange granularity:granularity];
    }
}


#pragma mark - Validation menus

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    
    SEL theAction = [menuItem action];
    
    if (theAction == @selector(cut:)) {
        
        return NO;
    }
    
    if (theAction == @selector(paste:)) {
        
        return NO;
    }
    
    if (theAction == @selector(delete:)) {
        
        return NO;
    }
    
    
    return YES;
}

@end

//
//  AutosizingTextView.m
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "AutoSizingTextView.h"

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


#pragma mark - Validation menus

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    SEL theAction = [menuItem action];
    
    if (theAction == @selector(paste:)) {
        
        return NO;
    }
    
    if (theAction == @selector(delete:)) {
        
        return NO;
    }
    
    if (theAction == @selector(cut:)) {
        
        return NO;
    }
    
    return YES;
}

@end

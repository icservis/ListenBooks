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

- (void)awakeFromNib
{
    [super awakeFromNib];
}


#pragma mark - Validation menus

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    /*
    SEL theAction = [menuItem action];
    
    if (theAction == @selector(export:)) {
        
        return NO;
    }
     */
    
    return YES;
}

@end

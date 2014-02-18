//
//  BookmarkView.m
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "BookmarksView.h"
#import "BookmarksController.h"

@implementation BookmarksView

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
}

- (IBAction)information:(id)sender
{
    //[self.bookmarksController information];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    SEL theAction = [menuItem action];
    
    if (theAction == @selector(information:)) {
        
        if ([[self selectedRowIndexes] count]  == 1) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)delete:(id)sender
{
    [self.bookmarksController remove];
}

@end

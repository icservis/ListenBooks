//
//  BookBookmarksView.m
//  ListenBooks
//
//  Created by Libor Kučera on 17/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "BookBookmarksView.h"
#import "BookViewController.h"

@implementation BookBookmarksView

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

- (IBAction)delete:(id)sender
{
    BookViewController* bookViewController = (BookViewController*)self.dataSource;
    [bookViewController remove:sender];
}

@end
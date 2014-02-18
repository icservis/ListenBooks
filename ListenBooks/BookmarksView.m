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

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setDoubleAction:@selector(open:)];
    [self setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]]];
}

- (IBAction)open:(id)sender
{
    [self.bookmarksController open];
}

- (IBAction)delete:(id)sender
{
    [self.bookmarksController remove];
}

@end

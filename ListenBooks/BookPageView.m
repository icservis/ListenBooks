//
//  BookPageView.m
//  ListenBooks
//
//  Created by Libor Kučera on 18/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "BookPageView.h"

@implementation BookPageView

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

#pragma mark - FirstResponder

- (IBAction)new:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    [self.delegate add:sender];
}

@end

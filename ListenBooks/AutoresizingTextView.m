//
//  AutosizingTextView.m
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AutoresizingTextView.h"

@implementation AutoresizingTextView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        NSLog(@"initWithFrame: %@", NSStringFromRect(frame));
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    NSLog(@"drawRect: %@", NSStringFromRect(dirtyRect));
	
    // Drawing code here.
}

- (void)setFrameSize:(NSSize)newSize {
    NSScrollView *scrollView = [self enclosingScrollView];
    NSLog(@"setFrameSize: %@", NSStringFromSize(newSize));
    if (scrollView) {
        [super setFrameSize:scrollView.frame.size];
    } else {
        [super setFrameSize:newSize];
    }
}

@end

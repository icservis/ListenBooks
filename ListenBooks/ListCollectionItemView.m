//
//  ListCollectionItemView.m
//  ListenBooks
//
//  Created by Libor Kučera on 27/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "ListCollectionView.h"
#import "ListCollectionItemView.h"
#import "ListCollectionViewItem.h"


@implementation ListCollectionItemView

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

-(void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    
    NSUInteger indexOfItem = [self.superview.subviews indexOfObject:self];
    DDLogVerbose(@"theEvent: %@, index: %lu", [theEvent description], (unsigned long)indexOfItem);
    
    if (theEvent.clickCount == 2) {
        
    } else if (theEvent.clickCount == 1) {
        
    }
}

@end

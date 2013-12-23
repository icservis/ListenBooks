//
//  ListCollectionItemView.m
//  ListenBooks
//
//  Created by Libor Kučera on 27/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "BooksTreeController.h"
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
    DDLogVerbose(@"theEvent: %@, index: %lu, title: %@", [theEvent description], (unsigned long)indexOfItem, self.book.title);
    
    ListCollectionView* listCollectionView = (ListCollectionView*)self.superview;
    
    if (theEvent.clickCount == 2) {
        [listCollectionView itemDoubleClicked:self];
    } else if (theEvent.clickCount == 1) {
        [listCollectionView itemSelected:self];
    }
}

- (void)keyDown:(NSEvent *)theEvent
{
    [super keyDown:theEvent];
    
    NSUInteger indexOfItem = [self.superview.subviews indexOfObject:self];
    DDLogVerbose(@"theEvent: %@, index: %lu, title: %@", [theEvent description], (unsigned long)indexOfItem, self.book.title);
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
    [super rightMouseUp:theEvent];
    
    NSUInteger indexOfItem = [self.superview.subviews indexOfObject:self];
    DDLogVerbose(@"theEvent: %@, index: %lu, title: %@", [theEvent description], (unsigned long)indexOfItem, self.book.title);
}

@end

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
    
    //NSUInteger indexOfItem = [self.superview.subviews indexOfObject:self];
    ListCollectionView* listCollectionView = (ListCollectionView*)self.superview;
    
    if (theEvent.clickCount == 2) {
        [listCollectionView itemDoubleClicked:self];
    } else if (theEvent.clickCount == 1) {
        [listCollectionView itemSelected:self];
    }
}

- (void)keyDown:(NSEvent *)theEvent
{
    if(theEvent) {
		switch([[theEvent characters] characterAtIndex:0])
		{
			case NSDeleteCharacter:
                [self alertSheet];
				break;
                
			default:
				[super keyDown:theEvent];
				break;
		}
	}
    
    //NSUInteger indexOfItem = [self.superview.subviews indexOfObject:self];
    //DDLogVerbose(@"theEvent: %@, index: %lu, title: %@", [theEvent description], (unsigned long)indexOfItem, self.book.title);
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
    [super rightMouseUp:theEvent];
    
    //NSUInteger indexOfItem = [self.superview.subviews indexOfObject:self];
    //DDLogVerbose(@"theEvent: %@, index: %lu, title: %@", [theEvent description], (unsigned long)indexOfItem, self.book.title);
}

#pragma mark - NSAlertViewDelegate

- (void)alertSheet
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:NSLocalizedString(@"Delete", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [alert setMessageText:NSLocalizedString(@"Do you really want to delete this item(s)?", nil)];
    [alert setInformativeText:NSLocalizedString(@"Deleting an item cannot be undone.", nil)];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert setDelegate:self];
    [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

-(void)alertDidEnd:(NSAlert*)alert returnCode:(NSInteger)returnCode contextInfo:(void*)contextInfo
{
    if (returnCode ==  NSAlertFirstButtonReturn)
    {
        ListCollectionView* listCollectionView = (ListCollectionView*)self.superview;
        [listCollectionView itemDeleted:self];
    }
}

@end

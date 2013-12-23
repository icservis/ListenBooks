//
//  ListCollectionView.m
//  ListenBooks
//
//  Created by Libor Kučera on 19.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "Book.h"
#import "BooksArrayController.h"
#import "BooksTreeController.h"
#import "ListCollectionView.h"
#import "ListCollectionViewItem.h"
#import "ListCollectionItemView.h"

@implementation ListCollectionView

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


- (NSCollectionViewItem*)newItemForRepresentedObject:(id)object
{
    ListCollectionViewItem* listItem = (ListCollectionViewItem*)[super newItemForRepresentedObject:object];
    ListCollectionItemView* listItemView = (ListCollectionItemView*)listItem.view;
    listItemView.book = (Book*)listItem.representedObject;
    
    return listItem;
}

- (void)setSelectionIndexes:(NSIndexSet *)indexes
{
    [super setSelectionIndexes:indexes];
    //DDLogVerbose(@"indexes: %@", [indexes description]);
}

- (void)itemSelected:(ListCollectionItemView*)item
{
    //DDLogVerbose(@"item: %@, selection: %@", [item description], [self.selectionIndexes description]);
}

- (void)itemDoubleClicked:(ListCollectionItemView*)item
{
    //DDLogVerbose(@"item: %@, indexes: %@", [item description], [self.selectionIndexes description]);
    
    if ([self.selectionIndexes count] == 1) {
        AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        Book* selectedObject = [[self.booksArrayController selectedObjects] firstObject];
        
        for (NSTreeNode *node in [appDelegate.booksTreeController flattenedNodes]) {
            Book* object = [node representedObject];
            if ([object.fileUrl isEqualTo:selectedObject.fileUrl]) {
                [appDelegate.booksTreeController setSelectedObject:object];
                [appDelegate selectBookViewController:nil];
                break;
            }
        }
    }
}

@end

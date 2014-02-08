//
//  ListCollectionView.m
//  ListenBooks
//
//  Created by Libor Kučera on 19.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "Book.h"
#import "ListArrayController.h"
#import "BooksTreeController.h"
#import "ListController.h"
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

}

- (void)itemDoubleClicked:(ListCollectionItemView*)item
{
    if ([self.selectionIndexes count] == 1) {
        [self.listController open];
    }
}

- (void)itemDeleted:(ListCollectionItemView*)item
{
    [self.listController deleteItems];
}

@end

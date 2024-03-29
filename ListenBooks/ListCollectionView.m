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


- (void)mouseDown:(NSEvent *)theEvent
{
    [super mouseDown:theEvent];
    [self.listController setCrossSelection];
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
    [self.listController delete];
}

- (IBAction)copy:(id)sender;
{
    [self.listController copy];
}

- (IBAction)paste:(id)sender
{
    [self.listController paste];
}

- (IBAction)cut:(id)sender
{
    [self.listController cut];
}

- (IBAction)edit:(id)sender
{
    [self.listController edit];
}

- (IBAction)delete:(id)sender
{
    [self.listController delete];
}

- (IBAction)selectAll:(id)sender
{
    [super selectAll:sender];
}

- (IBAction)open:(id)sender
{
    [self.listController open];
}

- (IBAction)information:(id)sender
{
    [self.listController information];
}

- (IBAction)export:(id)sender
{
    [self.listController export];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    SEL theAction = [menuItem action];
    
    if (theAction == @selector(information:)) {
        
        if ([[self selectionIndexes] count] == 1) {
            return YES;
        } else {
            return NO;
        }
    }
    
    if (theAction == @selector(open:)) {
        
        if ([[self selectionIndexes] count] > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    
    if (theAction == @selector(export:)) {
        
        if ([[self selectionIndexes] count] == 1) {
            return YES;
        } else {
            return NO;
        }
    }
    
    if (theAction == @selector(delete:)) {
        
        if ([[self selectionIndexes] count] > 0) {
            return YES;
        } else {
            return NO;
        }
    }
    
    if (theAction == @selector(cut:)) {
        
        return NO;
    }
    
    if (theAction == @selector(copy:)) {
        
        return NO;
    }
    
    if (theAction == @selector(paste:)) {
        
        return NO;
    }
    
    return YES;
}

@end

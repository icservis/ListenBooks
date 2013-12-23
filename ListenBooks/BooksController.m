//
//  SourceController.m
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "Book.h"
#import "Bookmark.h"
#import "BooksController.h"
#import "BooksView.h"
#import "BooksTreeController.h"
#import "BookmarksArrayController.h"
#import "BookViewController.h"

@implementation BooksController

- (void)copy
{
    
}

- (void)paste
{
    
}

- (void)cut
{
    
}

- (void)delete
{
    NSLog(@"delete");
    [self deleteItems];
}

- (void)edit{
    
}

- (void)deleteItems
{
    NSLog(@"deleteItems");
    [self.booksTreeController deleteItems];
}

- (void)cutItems
{
    
}


#pragma mark -
#pragma mark Other NSOutlineView Delegate Methods

- (NSView*)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if ([[(Book *)[item representedObject] isLeaf] boolValue]) {
        return [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
    } else {
        return [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    }
}

// Returns a Boolean that indicates whether a given row should be drawn in the “group row” style. Off by default.
- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item;
{
	if ([[(Book *)[item representedObject] isLeaf] boolValue] || [(NSTreeNode *)item isLeaf])
		return NO;
    return [[[item representedObject] isSpecialGroup] boolValue];
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item;
{
    if ([[(Book *)[item representedObject] isLeaf] boolValue] || [(NSTreeNode *)item isLeaf])
		return NO;
	return [[[item representedObject] canCollapse] boolValue];
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item;
{
	if ([[(Book *)[item representedObject] isLeaf] boolValue] || [(NSTreeNode *)item isLeaf])
		return NO;
	return [[[item representedObject] canExpand] boolValue];
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item;
{
	return [[(Book *)[item representedObject] isSelectable] boolValue];
}


- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return [[(Book *)[item representedObject] isEditable] boolValue];
}


- (void)outlineViewItemWillCollapse:(NSNotification *)notification
{
    /*  The following ensures that if a ancestor node is collapsed the descendent group nodes
     don't also collapse. It seems that this method is called for every descendent in a
     collapse of an ancestor
     */
    
    Book *itemToCollapse = [[[notification userInfo] valueForKey:@"NSObject"] representedObject];;
    BOOL visible = YES;
    Book *parent = [itemToCollapse valueForKey:@"parent"];
    
    /*  Walk up the tree from the node to see if it is expanded. If an ancestor node is collapsed
     then preserve the expanded state of the node
     */
    while (parent) {
        if (![[parent valueForKey:@"isExpanded"] boolValue]) {
            visible = NO;
            break;
        }
        parent = [parent valueForKey:@"parent"];
    }
    
    if(visible) {
        itemToCollapse.isExpanded = [NSNumber numberWithBool:NO];
    }
}


- (void)outlineViewItemDidCollapse:(NSNotification *)notification;
{
    Book *expandedItem = [[[notification userInfo] valueForKey:@"NSObject"] representedObject];
	expandedItem.isExpanded = [NSNumber numberWithBool:NO];
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification;
{
	Book *expandedItem = [[[notification userInfo] valueForKey:@"NSObject"] representedObject];
	expandedItem.isExpanded = [NSNumber numberWithBool:YES];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSLog(@"notification");
    [self.bookmarksArrayController rearrangeObjects];
    
    NSUInteger currentIndex = [self.booksView selectedRow];
    NSTreeNode* currentNode = [self.booksView itemAtRow:currentIndex];
    Book* currentBook = [currentNode representedObject];
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    appDelegate.bookViewController.book = currentBook;
}


@end
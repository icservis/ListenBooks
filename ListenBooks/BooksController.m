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
#import "ListArrayController.h"
#import "NSArrayController_Extensions.h"
#import "InformationWindowController.h"
#import "BlockAlert.h"

@implementation BooksController

- (void)copy
{
    DDLogVerbose(@"copy");
}

- (void)paste
{
    DDLogVerbose(@"paste");
}

- (void)cut
{
    DDLogVerbose(@"cut");
}

- (void)delete
{
    DDLogVerbose(@"delete");

    BlockAlert* alert = [[BlockAlert alloc] initWithStyle:NSWarningAlertStyle buttonTitles:@[NSLocalizedString(@"Delete", nil), NSLocalizedString(@"Cancel", nil)] messageText:NSLocalizedString(@"Do you really want to delete this item(s)?", nil) alternativeText:NSLocalizedString(@"Deleting an item cannot be undone.", nil)];
    __weak BlockAlert* weakAlert = alert;
    weakAlert.completionBlock = ^(NSInteger returnCode) {
        if (returnCode ==  NSAlertFirstButtonReturn) {
            [self deleteItems];
        };
    };
}

- (void)edit
{
    DDLogVerbose(@"edit");
}

- (void)selectAll
{
    DDLogVerbose(@"selectAll");
}

- (void)open
{
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    
    [[self.booksTreeController selectedObjects] enumerateObjectsUsingBlock:^(Book* book, NSUInteger idx, BOOL *stop) {
        if (book.fileUrl != nil) {
            [appDelegate addNewTabWithBook:book];
        }
        
    }];
    [appDelegate.listArrayController setSelectedObjects:[self.booksTreeController selectedObjects]];
}

- (void)information
{
    DDLogVerbose(@"information");
    
    InformationWindowController* infoWindowController = [[InformationWindowController alloc] initWithWindowNibName:@"InformationWindowController"];
    __weak InformationWindowController* weakInfoWindowController = infoWindowController;
    Book* selectedBook = (Book*)[[[self.booksTreeController selectedNodes] firstObject] representedObject];
    if (selectedBook == nil) return;
    
    weakInfoWindowController.book = selectedBook;
    weakInfoWindowController.completionBlock = ^(BOOL success) {
        [infoWindowController.window close];
    };
    [weakInfoWindowController.window makeKeyAndOrderFront:self];
}

- (void)deleteItems
{
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [[self.booksTreeController selectedNodes] enumerateObjectsUsingBlock:^(NSTreeNode* node, NSUInteger idx, BOOL *stop) {
        
        Book* book = [node representedObject];
        [appDelegate unlinkBookWithUrl:book.fileUrl];
        
        [[appDelegate tabViewControllers] enumerateObjectsUsingBlock:^(NSViewController* controller, NSUInteger idx, BOOL *stop) {
            if ([controller isKindOfClass:[BookViewController class]]) {
                BookViewController* bookViewController = (BookViewController*)controller;
                if ([bookViewController.book isEqualTo:book]) {
                    [appDelegate closeTabWithItem:bookViewController.tabViewItem];
                }
            }
        }];
        
        NSArray* childIndexPaths = [node childIndexPaths];
        [self.booksTreeController removeObjectsAtArrangedObjectIndexPaths:childIndexPaths];
        
    }];
    
    [self.booksTreeController remove:self];
    DDLogVerbose(@"count: %ld", (long)[[self.booksTreeController arrangedObjects] count]);
    [appDelegate saveAction:nil];
}

#pragma mark - NSOutlineView Delegate Methods

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
    [self.bookmarksArrayController rearrangeObjects];
    /*
    NSUInteger currentIndex = [self.booksView selectedRow];
    NSTreeNode* currentNode = [self.booksView itemAtRow:currentIndex];
    Book* currentBook = [currentNode representedObject];
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
   */
}


@end

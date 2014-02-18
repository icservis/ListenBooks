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
#import "ProgressWindowController.h"

@interface BooksController ()

@property (nonatomic, strong) ProgressWindowController* progressWindowController;

@end

@implementation BooksController

- (void)dealloc
{
    self.progressWindowController = nil;
}

- (ProgressWindowController*)progressWindowController
{
    if (_progressWindowController == nil) {
        _progressWindowController = [ProgressWindowController sharedController];
    };
    return _progressWindowController;
}

#pragma  mark - FirstResponder

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
    DDLogVerbose(@"open");
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [[self.booksTreeController selectedObjects] enumerateObjectsUsingBlock:^(Book* book, NSUInteger idx, BOOL *stop) {
        
        __block BOOL bookFound = NO;
        [[appDelegate tabViewControllers] enumerateObjectsUsingBlock:^(NSViewController* controller, NSUInteger idx, BOOL *stop) {
            if ([controller isKindOfClass:[BookViewController class]]) {
                BookViewController* bookViewController = (BookViewController*)controller;
                if ([bookViewController.book isEqualTo:book]) {
                    [appDelegate.tabBar selectTabViewItem:bookViewController.tabViewItem];
                    bookFound = YES;
                    *stop = YES;
                }
            }
        }];
        if (bookFound == NO) {
            [appDelegate addNewTabWithBook:book];
        }
    }];
}

- (void)information
{
    DDLogVerbose(@"information");
    
    InformationWindowController* infoWindowController = [[InformationWindowController alloc] initWithWindowNibName:@"InformationWindowController"];
    __weak InformationWindowController* weakInfoWindowController = infoWindowController;
    weakInfoWindowController.completionBlock = ^(BOOL success) {
        [infoWindowController.window close];
    };
    [infoWindowController.window makeKeyAndOrderFront:self];
}

- (void)export
{
    DDLogVerbose(@"export");
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    Book* selectedBook = (Book*)[[[self.booksTreeController selectedNodes] firstObject] representedObject];
    [appDelegate exportBook:selectedBook];
}

- (void)deleteItems
{
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    
    [self.progressWindowController openProgressWindowWithTitle:NSLocalizedString(@"Deleting Books(s)", nil) info:NSLocalizedString(@"Processing…", nil) indicatorMinValue:0 indicatorMaxValue:0 doubleValue:0 indeterminate:YES animating:YES];
    __weak ProgressWindowController* weakProgressWindowController = self.progressWindowController;
    weakProgressWindowController.completionBlock = ^() {
        self.progressWindowController = nil;
        DDLogVerbose(@"ProgressWindowController closed");
    };
    
    [appDelegate.managedObjectContext processPendingChanges];
    [[appDelegate.managedObjectContext undoManager] disableUndoRegistration];
    
    [[self.booksTreeController selectedNodes] enumerateObjectsUsingBlock:^(NSTreeNode* node, NSUInteger idx, BOOL *stop) {
        
        Book* book = [node representedObject];
        [appDelegate unlinkBookWithUrl:book.fileUrl];
        
        [[appDelegate tabViewControllers] enumerateObjectsUsingBlock:^(NSViewController* controller, NSUInteger idx, BOOL *stop) {
            if ([controller isKindOfClass:[BookViewController class]]) {
                BookViewController* bookViewController = (BookViewController*)controller;
                if ([bookViewController.book isEqualTo:book]) {
                    [appDelegate closeTabWithItem:bookViewController.tabViewItem];
                    [self.progressWindowController updateProgressWindowWithInfo:bookViewController.book.title];
                }
            }
        }];
        
        [appDelegate.managedObjectContext deleteObject:book];
    }];
    
    [appDelegate saveAction:nil];
    [appDelegate.managedObjectContext processPendingChanges];
    [[appDelegate.managedObjectContext undoManager] enableUndoRegistration];
    
    [self.progressWindowController updateProgressWindowWithInfo:NSLocalizedString(@"Completed", nil)];
    [self.progressWindowController updateProgressWindowWithIndeterminate:YES animating:NO];
    [self.progressWindowController closeProgressWindow];
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
    //DDLogVerbose(@"notification: %@", notification.object);
}

- (void)setCrossSelection
{
    [self.listArrayController setSelectedObjects:[self.booksTreeController selectedObjects]];
}


@end

//
//  ListController.m
//  ListenBooks
//
//  Created by Libor Kučera on 07/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "ListController.h"
#import "Book.h"
#import "BookViewController.h"
#import "BooksTreeController.h"
#import "ListArrayController.h"
#import "InformationWindowController.h"
#import "BlockAlert.h"
#import "ProgressWindowController.h"

@interface ListController ()

@property (nonatomic, strong) ProgressWindowController* progressWindowController;

@end

@implementation ListController

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
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [[self.listArrayController selectedObjects] enumerateObjectsUsingBlock:^(Book* book, NSUInteger idx, BOOL *stop) {
        
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
    Book* selectedBook = (Book*)[[self.listArrayController selectedObjects] firstObject];
    if (selectedBook == nil) return;
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [[appDelegate.managedObjectContext undoManager] beginUndoGrouping];
    
    weakInfoWindowController.book = selectedBook;
    weakInfoWindowController.completionBlock = ^(BOOL success) {
        [infoWindowController.window close];
        
        [[appDelegate.managedObjectContext undoManager] endUndoGrouping];
        if (success) {
            [[appDelegate.managedObjectContext undoManager] setActionName:NSLocalizedString(@"Edit Information", nil)];
        } else {
            [[appDelegate.managedObjectContext undoManager] undo];
        }
    };
    [weakInfoWindowController.window makeKeyAndOrderFront:self];
}

- (void)export
{
    DDLogVerbose(@"export");
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    Book* selectedBook = (Book*)[[self.listArrayController selectedObjects] firstObject];
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

    [[self.listArrayController selectedObjects] enumerateObjectsUsingBlock:^(Book* book, NSUInteger idx, BOOL *stop) {
        
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

@end

//
//  BookmarksController.m
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "Book.h"
#import "Bookmark.h"
#import "BookmarksController.h"
#import "BookViewController.h"
#import "AdobePDFViewController.h"
#import "BookmarksView.h"
#import "BooksView.h"
#import "BooksTreeController.h"
#import "BookmarksArrayController.h"

@implementation BookmarksController

- (AppDelegate*)appDelegate
{
    return (AppDelegate*)[[NSApplication sharedApplication] delegate];
}

- (void)open
{
    AppDelegate* appDelegate = [self appDelegate];
    [[self.bookmarksArrayController selectedObjects] enumerateObjectsUsingBlock:^(Bookmark* bookmark, NSUInteger idx, BOOL *stop) {
        
        __block BOOL bookFound = NO;
        [[appDelegate tabViewControllers] enumerateObjectsUsingBlock:^(NSViewController* controller, NSUInteger idx, BOOL *stop) {
            if ([controller isKindOfClass:[BookViewController class]]) {
                BookViewController* bookViewController = (BookViewController*)controller;
                if ([bookViewController.book isEqualTo:bookmark.book]) {
                    [appDelegate.tabBar selectTabViewItem:bookViewController.tabViewItem];
                    bookViewController.bookmark = bookmark;
                    bookFound = YES;
                    *stop = YES;
                }
            }
            if ([controller isKindOfClass:[AdobePDFViewController class]]) {
                AdobePDFViewController* bookPdfViewController = (AdobePDFViewController*)controller;
                if ([bookPdfViewController.book isEqualTo:bookmark.book]) {
                    [appDelegate.tabBar selectTabViewItem:bookPdfViewController.tabViewItem];
                    bookPdfViewController.bookmark = bookmark;
                    bookFound = YES;
                    *stop = YES;
                }
            }
        }];
        if (bookFound == NO) {
            id<TabBarControllerProtocol> controller = [appDelegate addNewTabWithBook:bookmark.book];
            controller.bookmark = bookmark;
        }
    }];
}

- (void)remove
{
    DDLogVerbose(@"remove");
    [[[self appDelegate] undoManager] beginUndoGrouping];
    [[[self appDelegate] undoManager] setActionName:NSLocalizedString(@"Delete Bookmark", nil)];
    
    [self.bookmarksArrayController remove:nil];
    
    [[[self appDelegate] undoManager] endUndoGrouping];
}

@end

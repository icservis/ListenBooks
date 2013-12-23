//
//  BooksTreeController.m
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "Book.h"
#import "BooksTreeController.h"
#import "BookViewController.h"
#import "NSTreeController_Extensions.h"

@implementation BooksTreeController

- (void)deleteItems
{
    DDLogVerbose(@"deleteItems");
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    
    [[self selectedNodes] enumerateObjectsUsingBlock:^(NSTreeNode* node, NSUInteger idx, BOOL *stop) {
        
        Book* book = [node representedObject];
        [appDelegate unlinkBookWithUrl:book.fileUrl];
        
        NSArray* childIndexPaths = [node childIndexPaths];
        [self removeObjectsAtArrangedObjectIndexPaths:childIndexPaths];
        
    }];
    
    [super remove:self];
    
    DDLogVerbose(@"count: %ld", (long)[[self arrangedObjects] count]);
    if ([[self arrangedObjects] count] == 0) {
        [self.bookViewController resetPageView];
    }
}

@end

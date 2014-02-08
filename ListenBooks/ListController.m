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
#import "BooksTreeController.h"
#import "ListArrayController.h"

@implementation ListController

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
    [self deleteItems];
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
    Book* selectedObject = [[self.listArrayController selectedObjects] firstObject];
    [self.booksTreeController setSelectedObject:selectedObject];
    [appDelegate selectBookViewController:nil];
}

- (void)deleteItems
{
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    
    [[self.listArrayController selectedObjects] enumerateObjectsUsingBlock:^(Book* book, NSUInteger idx, BOOL *stop) {
        
        [appDelegate unlinkBookWithUrl:book.fileUrl];
        
    }];
    
    [self.listArrayController remove:self];
    
    DDLogVerbose(@"count: %ld", (long)[[self.listArrayController arrangedObjects] count]);
}

@end

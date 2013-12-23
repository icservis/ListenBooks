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
#import "BooksArrayController.h"

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

- (void)deleteItems
{
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    
    [[self.booksArrayController selectedObjects] enumerateObjectsUsingBlock:^(Book* book, NSUInteger idx, BOOL *stop) {
        
        [appDelegate unlinkBookWithUrl:book.fileUrl];
        
    }];
    
    [self.booksArrayController remove:self];
    
    DDLogVerbose(@"count: %ld", (long)[[self.booksArrayController arrangedObjects] count]);
}

@end

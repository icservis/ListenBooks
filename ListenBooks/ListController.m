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
#import "InformationWindowController.h"

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
    [self deleteAlert];
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

- (void)information
{
    DDLogVerbose(@"information");
    
    InformationWindowController* infoWindowController = [[InformationWindowController alloc] initWithWindowNibName:@"InformationWindowController"];
    __weak InformationWindowController* weakInfoWindowController = infoWindowController;
    Book* selectedBook = (Book*)[[self.listArrayController selectedObjects] firstObject];
    weakInfoWindowController.book = selectedBook;
    weakInfoWindowController.completionBlock = ^(BOOL success) {
        [infoWindowController.window close];
    };
    [weakInfoWindowController.window makeKeyAndOrderFront:self];
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

#pragma mark - NSAlertViewDelegate

- (void)deleteAlert
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:NSLocalizedString(@"Delete", nil)];
    [alert addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    [alert setMessageText:NSLocalizedString(@"Do you really want to delete this item(s)?", nil)];
    [alert setInformativeText:NSLocalizedString(@"Deleting an item cannot be undone.", nil)];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert setDelegate:self];
    [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

-(void)alertDidEnd:(NSAlert*)alert returnCode:(NSInteger)returnCode contextInfo:(void*)contextInfo
{
    if (returnCode ==  NSAlertFirstButtonReturn)
    {
        [self deleteItems];
    }
}

@end

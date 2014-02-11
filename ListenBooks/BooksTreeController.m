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
#import "ListViewController.h"
#import "NSTreeController_Extensions.h"

@implementation BooksTreeController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:appDelegate.managedObjectContext];
}

- (void)dealloc
{
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:appDelegate.managedObjectContext];
}

- (void)contextDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"count: %lu", (unsigned long)[[self arrangedObjects] count]);
}

@end

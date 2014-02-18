//
//  BookmarksArrayController.m
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "BookmarksArrayController.h"
#import "NSArrayController_Extensions.h"

@implementation BookmarksArrayController

- (void)awakeFromNib
{
    [super awakeFromNib];
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:appDelegate.managedObjectContext];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)contextDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"count: %lu", (unsigned long)[[self arrangedObjects] count]);
}


@end

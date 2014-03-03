//
//  BooksArrayController.m
//  ListenBooks
//
//  Created by Libor Kučera on 23/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "ListArrayController.h"
#import "Book.h"
#import "BookViewController.h"
#import "ListController.h"
#import "NSArrayController_Extensions.h"

@implementation ListArrayController

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

}


@end

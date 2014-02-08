//
//  ListViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"
#import "ListArrayController.h"
#import "BooksTreeController.h"
#import "ListCollectionView.h"

@interface ListViewController ()

@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    
    [self.listCollectionView bind:NSContentBinding toObject:appDelegate.listArrayController withKeyPath:@"arrangedObjects" options:nil];
    [self.listCollectionView bind:NSSelectionIndexesBinding toObject:appDelegate.listArrayController withKeyPath:@"selectionIndexes" options:nil];
    //NSDictionary* filterOptions = [[NSDictionary alloc] initWithObjectsAndKeys:@"self.title contains[cd] $value", NSPredicateFormatBindingOption, @"predicate", NSDisplayNameBindingOption, nil];
    //[self.searchField bind:NSFilterPredicateBinding toObject:appDelegate.booksArrayController withKeyPath:@"selection" options:filterOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:appDelegate.managedObjectContext];
}


- (void)contextDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"notification: %@", notification.object);
}

@end

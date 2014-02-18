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
#import "BookmarksView.h"
#import "BooksView.h"
#import "BooksTreeController.h"
#import "BookmarksArrayController.h"

@implementation BookmarksController

- (void)remove
{
    [self.bookmarksArrayController remove:nil];
}

@end

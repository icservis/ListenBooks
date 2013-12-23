//
//  BookmarksController.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BookmarksView;
@class BooksView;
@class BooksTreeController;
@class BookmarksArrayController;

@interface BookmarksController : NSObject

@property (weak) IBOutlet BookmarksView *bookmarksView;
@property (weak) IBOutlet BooksView *booksView;
@property (unsafe_unretained) IBOutlet BooksTreeController *booksTreeController;
@property (unsafe_unretained) IBOutlet BookmarksArrayController *bookmarksArrayController;

@end

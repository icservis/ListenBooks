//
//  SourceController.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BooksView;
@class BookViewController;
@class BooksTreeController;
@class BookmarksArrayController;

@interface BooksController : NSObject <NSOutlineViewDelegate, NSAlertDelegate>

@property (weak) IBOutlet BooksView *booksView;
@property (unsafe_unretained) IBOutlet BookViewController* bookViewController;
@property (unsafe_unretained) IBOutlet BooksTreeController *booksTreeController;
@property (unsafe_unretained) IBOutlet BookmarksArrayController *bookmarksArrayController;

- (void)copy;
- (void)paste;
- (void)cut;
- (void)delete;
- (void)edit;
- (void)selectAll;
- (void)deleteItems;
- (void)open;
- (void)information;

@end

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
@class ListArrayController;

@interface BooksController : NSObject <NSOutlineViewDelegate>

@property (weak) IBOutlet BooksView *booksView;
@property (weak) IBOutlet BookViewController* bookViewController;
@property (weak) IBOutlet BooksTreeController *booksTreeController;
@property (weak) IBOutlet BookmarksArrayController *bookmarksArrayController;
@property (weak) IBOutlet ListArrayController *listArrayController;

- (void)copy;
- (void)paste;
- (void)cut;
- (void)delete;
- (void)edit;
- (void)selectAll;
- (void)deleteItems;
- (void)open;
- (void)information;
- (void)export;
- (void)setCrossSelection;

@end

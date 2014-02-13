//
//  ListController.h
//  ListenBooks
//
//  Created by Libor Kučera on 07/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ListCollectionView;
@class BookViewController;
@class BooksTreeController;
@class BookmarksArrayController;
@class ListArrayController;

@interface ListController : NSObject <NSCollectionViewDelegate, NSMenuDelegate>

@property (weak) IBOutlet ListCollectionView *listControllerView;
@property (weak) IBOutlet BookViewController* bookViewController;
@property (weak) IBOutlet BooksTreeController* booksTreeController;
@property (weak) IBOutlet BookmarksArrayController *bookmarksArrayController;
@property (weak) IBOutlet ListArrayController* listArrayController;

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

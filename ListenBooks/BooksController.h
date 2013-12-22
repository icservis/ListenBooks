//
//  SourceController.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BooksView;
@class BooksTreeController;
@class BookmarksArrayController;

@interface BooksController : NSObject
@property (weak) IBOutlet BooksView *booksView;
@property (weak) IBOutlet BooksTreeController *booksTreeController;
@property (weak) IBOutlet BookmarksArrayController *bookmarksArrayController;

- (void)copy;
- (void)paste;
- (void)cut;
- (void)delete;
- (void)edit;
- (void)deleteItems;
- (void)cutItems;

@end

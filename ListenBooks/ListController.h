//
//  ListController.h
//  ListenBooks
//
//  Created by Libor Kučera on 07/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BookViewController;
@class BooksTreeController;
@class ListArrayController;

@interface ListController : NSObject <NSCollectionViewDelegate, NSMenuDelegate>

@property (unsafe_unretained) IBOutlet BookViewController* bookViewController;
@property (unsafe_unretained) IBOutlet BooksTreeController* booksTreeController;
@property (unsafe_unretained) IBOutlet ListArrayController* listArrayController;

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

@end

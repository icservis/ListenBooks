//
//  BookmarkView.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BookmarksController;
@class BooksController;

@interface BookmarksView : NSTableView

@property (unsafe_unretained) IBOutlet BookmarksController* bookmarksController;
@property (unsafe_unretained) IBOutlet BooksController* booksController;

- (IBAction)open:(id)sender;
- (IBAction)delete:(id)sender;

@end

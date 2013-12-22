//
//  SourceView.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BooksController;
@class BookmarksView;

@interface BooksView : NSOutlineView <NSAlertDelegate>

@property (assign) IBOutlet BooksController* booksController;
@property (weak) IBOutlet BookmarksView* bookmarksView;

- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;
- (IBAction)cut:(id)sender;
- (IBAction)delete:(id)sender;

@end

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

@interface BooksView : NSOutlineView

@property (unsafe_unretained) IBOutlet BooksController* booksController;
@property (weak) IBOutlet BookmarksView* bookmarksView;

- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;
- (IBAction)cut:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)open:(id)sender;
//- (IBAction)selectAll:(id)sender;
- (IBAction)information:(id)sender;
- (IBAction)export:(id)sender;

@end

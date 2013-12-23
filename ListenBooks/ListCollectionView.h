//
//  ListCollectionView.h
//  ListenBooks
//
//  Created by Libor Kučera on 19.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BooksArrayController;
@class ListCollectionItemView;

@interface ListCollectionView : NSCollectionView

@property (strong) IBOutlet BooksArrayController* booksArrayController;

- (void)itemSelected:(ListCollectionItemView*)item;
- (void)itemDoubleClicked:(ListCollectionItemView*)item;

@end

//
//  ListViewController.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ListCollectionView;
@class ListCollectionController;
@class BooksArrayController;

@interface ListViewController : NSViewController

@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet ListCollectionView *listCollectionView;

@property (strong) IBOutlet ListCollectionController *listCollectionController;
@property (strong) IBOutlet BooksArrayController *booksArrayController;



@end

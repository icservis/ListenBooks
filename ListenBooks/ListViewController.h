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

@interface ListViewController : NSViewController

@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet ListCollectionView *listCollectionView;
@property (weak) IBOutlet NSSearchField *searchField;

@property (unsafe_unretained) IBOutlet ListCollectionController *listCollectionController;



@end

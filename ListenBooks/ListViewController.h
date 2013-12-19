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
@class ListCollectionViewItem;
@class SourceTreeController;

@interface ListViewController : NSViewController

@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet ListCollectionView *listCollectionView;

@property (strong) IBOutlet ListCollectionController *listCollectionController;
@property (strong) IBOutlet ListCollectionViewItem *listCollectionViewItem;
@property (strong) IBOutlet SourceTreeController *sourceTreeController;



@end

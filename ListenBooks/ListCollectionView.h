//
//  ListCollectionView.h
//  ListenBooks
//
//  Created by Libor Kučera on 19.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ListController;
@class ListCollectionItemView;

@interface ListCollectionView : NSCollectionView

@property (unsafe_unretained) IBOutlet ListController* listController;

- (void)itemSelected:(ListCollectionItemView*)item;
- (void)itemDoubleClicked:(ListCollectionItemView*)item;
- (void)itemDeleted:(ListCollectionItemView*)item;

- (IBAction)copy:(id)sender;
- (IBAction)paste:(id)sender;
- (IBAction)cut:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)delete:(id)sender;
//- (IBAction)selectAll:(id)sender;
- (IBAction)open:(id)sender;
- (IBAction)information:(id)sender;

@end

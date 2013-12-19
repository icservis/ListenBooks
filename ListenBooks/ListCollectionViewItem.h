//
//  ListCollectionViewItem.h
//  ListenBooks
//
//  Created by Libor Kučera on 19.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ListCollectionViewItem : NSCollectionViewItem

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSTextField *authorField;

@end

//
//  BooksArrayController.h
//  ListenBooks
//
//  Created by Libor Kučera on 23/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BookViewController;
@class ListController;

@interface ListArrayController : NSArrayController

@property (unsafe_unretained) IBOutlet BookViewController *bookViewController;
@property (unsafe_unretained) IBOutlet ListController *listController;


@end

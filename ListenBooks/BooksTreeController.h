//
//  BooksTreeController.h
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BookViewController;
@class ListViewController;

@interface BooksTreeController : NSTreeController

@property (unsafe_unretained) IBOutlet BookViewController *bookViewController;

@end

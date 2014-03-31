//
//  ImageViewController.h
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TabBarControllerProtocol.h"

@class Book;
@class Bookmark;

@interface ImageViewController : NSViewController <TabBarControllerProtocol, NSPageControllerDelegate>

@property (nonatomic, strong) Book* book;
@property (nonatomic, strong) Bookmark* bookmark;
@property (strong) IBOutlet NSPageController *pageController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSTabViewItem* tabViewItem;

@end

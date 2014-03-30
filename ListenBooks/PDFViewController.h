//
//  PDFViewController.h
//  ListenBooks
//
//  Created by Libor Kučera on 30.03.14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TabBarControllerProtocol.h"

@class Book;

@interface PDFViewController : NSViewController <TabBarControllerProtocol>

@property (nonatomic, strong) Book* book;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSTabViewItem* tabViewItem;

@end

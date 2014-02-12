//
//  BookViewController.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KFEpubController.h"
#import "KFEpubContentModel.h"


static NSString* const TextSizeDidChangeNotificaton = @"TEXT_SIZE_DID_CHANGE_NOTIFICATION";

@class Book;

@interface BookViewController : NSViewController <NSPageControllerDelegate, KFEpubControllerDelegate>

@property (strong) Book* book;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong) NSTabViewItem* tabViewItem;
@property (assign, getter = isProcessing) BOOL processing;

@end

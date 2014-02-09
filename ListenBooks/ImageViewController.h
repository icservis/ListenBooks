//
//  ImageViewController.h
//  ListenBooks
//
//  Created by Libor Kučera on 21/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageViewController : NSViewController <NSPageControllerDelegate>

@property (strong) IBOutlet NSPageController *pageController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong) NSTabViewItem* tabViewItem;

@end

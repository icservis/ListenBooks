//
//  TabBarControllerProtocol.h
//  ListenBooks
//
//  Created by Libor Kučera on 10/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Book;
@class Bookmark;

@protocol TabBarControllerProtocol <NSObject>

@property (nonatomic, strong) Book* book;
@property (nonatomic, strong) Bookmark* bookmark;
@property (nonatomic, strong) NSTabViewItem* tabViewItem;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

- (void)toggleToolBar;
- (BOOL)isToolBarOpened;
- (void)toggleSideBar;
- (BOOL)isSideBarOpened;
- (IBAction)add:(id)sender;
- (IBAction)edit:(id)sender;
- (IBAction)remove:(id)sender;
- (IBAction)export:(id)sender;

@end

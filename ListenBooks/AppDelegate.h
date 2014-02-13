//
//  AppDelegate.h
//  ListenBooks
//
//  Created by Libor Kučera on 14.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KFEpubController.h"
#import "KFEpubContentModel.h"
#import <MMTabBarView/MMTabBarView.h>
#import "TabBarModel.h"

@class Book;
@class KFToolbar;
@class BooksView;
@class BookmarksView;
@class BooksTreeController;
@class ListArrayController;
@class BookmarksArrayController;
@class BookViewController;
@class ImageViewController;
@class ListCollectionView;
@class ProgressWindowController;

extern NSString* const TabBarSelectionDidChangeNotification;
extern NSString* const TabBarCountDidChangeNotification;

@interface AppDelegate : NSObject <NSApplicationDelegate, KFEpubControllerDelegate, NSSplitViewDelegate, MMTabBarViewDelegate, NSTabViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet MMTabBarView *tabBar;
@property (weak) IBOutlet KFToolbar *toolBar;

@property (nonatomic, strong) ProgressWindowController* progressWindowController;
@property (nonatomic, strong) NSMutableArray* tabViewControllers;

@property (nonatomic, strong) IBOutlet BooksTreeController *booksTreeController;
@property (nonatomic, strong) IBOutlet BookmarksArrayController *bookmarksArrayController;
@property (nonatomic, strong) IBOutlet ListArrayController *listArrayController;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

#pragma mark - CoreData
- (NSURL *)applicationDocumentsDirectory;
- (NSURL *)applicationCacheDirectory;
- (IBAction)saveAction:(id)sender;

#pragma mark - Input/Output Operations
- (IBAction)openImportDialog:(id)sender;
- (void)unlinkBookWithUrl:(NSURL*)sandboxedFileUrl;
- (void)exportBook:(Book*)book;

#pragma mark - Tabs Management
- (void)addNewTabWithBook:(Book*)book;
- (IBAction)addNewTab:(id)sender;
- (IBAction)closeTab:(id)sender;
- (void)closeTabWithItem:(NSTabViewItem*)tabViewItem;
- (void)updateToolBarContentForTabView:(NSTabViewItem*)tabViewItem;

@end

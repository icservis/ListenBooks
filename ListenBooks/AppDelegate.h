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

extern NSString* const TabBarSelectionDidChangeNotification;
extern NSString* const TabBarCountDidChangeNotification;

@interface AppDelegate : NSObject <NSApplicationDelegate, KFEpubControllerDelegate, NSSplitViewDelegate, MMTabBarViewDelegate, NSTabViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet MMTabBarView *tabBar;
@property (weak) IBOutlet NSTabView *tabView;

@property (weak) IBOutlet KFToolbar *toolBar;
@property (weak) IBOutlet NSTextField *tabField;

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *inputView;

@property (weak) IBOutlet NSSplitView *subSplitView;
@property (weak) IBOutlet NSView *sourceSplitPane;
@property (weak) IBOutlet NSView *bookmarksSplitPane;
@property (weak) IBOutlet BooksView *booksView;
@property (weak) IBOutlet BookmarksView *bookmarksView;

@property (weak) IBOutlet ListCollectionView *listCollectionView;
@property (weak) IBOutlet NSView *listToolBarView;
@property (weak) IBOutlet NSSearchField *listSearchField;

@property (unsafe_unretained) IBOutlet NSPanel *progressWindow;
@property (weak) IBOutlet NSProgressIndicator *progressIndicatior;
@property (weak) IBOutlet NSTextField *progressTitle;
@property (weak) IBOutlet NSTextField *progressInfo;

@property (weak) IBOutlet NSMenu *actionMenu;
@property (weak) IBOutlet NSMenuItem *menuItemNewTab;
@property (weak) IBOutlet NSMenuItem *menuItemCloseTab;

@property (nonatomic, strong) NSMutableArray* tabViewControllers;

@property (nonatomic, strong) NSMutableArray* importedUrls;
@property (nonatomic, strong) KFEpubController *epubController;
@property (nonatomic, strong) KFEpubContentModel *contentModel;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;

@property (strong) IBOutlet BooksTreeController *booksTreeController;
@property (strong) IBOutlet BookmarksArrayController *bookmarksArrayController;
@property (strong) IBOutlet ListArrayController *listArrayController;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSURL *)applicationDocumentsDirectory;
- (NSURL *)applicationCacheDirectory;
- (NSArray*)allowedFileTypes;
- (IBAction)openImportDialog:(id)sender;
- (void)unlinkBookWithUrl:(NSURL*)sandboxedFileUrl;
- (void)addNewTabWithBook:(Book*)book;
- (IBAction)addNewTab:(id)sender;
- (IBAction)closeTab:(id)sender;
- (void)closeTabWithItem:(NSTabViewItem*)tabViewItem;
- (void)updateToolBarContentForTabView:(NSTabViewItem*)tabViewItem;
- (IBAction)saveAction:(id)sender;



@end

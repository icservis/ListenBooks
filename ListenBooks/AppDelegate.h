//
//  AppDelegate.h
//  ListenBooks
//
//  Created by Libor Kučera on 14.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KFToolbar;
@class SourceView;
@class BookmarksView;
@class SourceTreeController;
@class BookmarksArrayController;
@class ListViewController;
@class BookViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *inputView;
@property (weak) IBOutlet KFToolbar *toolBar;
@property (weak) IBOutlet NSMenu *actionMenu;
@property (weak) IBOutlet NSSplitView *subSplitView;
@property (weak) IBOutlet NSView *sourceSplitPane;
@property (weak) IBOutlet NSView *bookmarksSplitPane;
@property (weak) IBOutlet BookmarksView *bookmarksView;
@property (weak) IBOutlet SourceView *sourceView;

@property (strong) IBOutlet SourceTreeController *sourceTreeController;
@property (strong) IBOutlet BookmarksArrayController *bookmarksArrayController;

@property (strong, nonatomic) IBOutlet ListViewController *listViewController;
@property (strong, nonatomic) IBOutlet BookViewController *bookViewController;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSURL *)applicationDocumentsDirectory;
- (NSURL *)applicationCacheDirectory;

- (IBAction)saveAction:(id)sender;
- (IBAction)selectBookViewController:(id)sender;
- (IBAction)selectListViewController:(id)sender;


@end

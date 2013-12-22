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

@class KFToolbar;
@class BooksView;
@class BookmarksView;
@class BooksTreeController;
@class BookmarksArrayController;
@class ListViewController;
@class BookViewController;
@class ImageViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate, KFEpubControllerDelegate>

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
@property (weak) IBOutlet BooksView *booksView;

@property (unsafe_unretained) IBOutlet NSPanel *progressWindow;
@property (weak) IBOutlet NSProgressIndicator *progressIndicatior;
@property (weak) IBOutlet NSTextField *progressTitle;
@property (weak) IBOutlet NSTextField *progressInfo;

@property (nonatomic, strong) KFEpubController *epubController;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;

@property (strong) IBOutlet BooksTreeController *booksTreeController;
@property (strong) IBOutlet BookmarksArrayController *bookmarksArrayController;

@property (strong, nonatomic) IBOutlet ListViewController *listViewController;
@property (strong, nonatomic) IBOutlet BookViewController *bookViewController;
@property (strong, nonatomic) IBOutlet ImageViewController *imageViewController;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSURL *)applicationDocumentsDirectory;
- (NSURL *)applicationCacheDirectory;
- (NSArray*)allowedFileTypes;
- (IBAction)openImportDialog:(id)sender;
- (void)unlinkBookWithUrl:(NSURL*)sandboxedFileUrl;

- (IBAction)saveAction:(id)sender;
- (IBAction)selectBookViewController:(id)sender;
- (IBAction)selectListViewController:(id)sender;
- (IBAction)selectImageViewController:(id)sender;


@end

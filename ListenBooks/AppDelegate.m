//
//  AppDelegate.m
//  ListenBooks
//
//  Created by Libor Kučera on 14.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "KFToolbar.h"
#import "KFToolbarItem.h"
#import <MMTabBarView/MMTabBarView.h>
#import <MMTabBarView/MMTabStyle.h>
#import "TabBarControllerProtocol.h"

#import "Book.h"
#import "Bookmark.h"
#import "Page.h"

#import "ListViewController.h"
#import "BookViewController.h"
#import "ImageViewController.h"

#import "BooksTreeController.h"
#import "BookmarksArrayController.h"
#import "ListArrayController.h"

#import "PreferencesWindowController.h"
#import "ProgressWindowController.h"


@interface AppDelegate ()

@property (nonatomic, strong) NSURL *libraryURL;
@property (assign) NSInteger importedFilesCount;
@property (nonatomic, strong) NSMutableArray* importedUrls;
@property (nonatomic, strong) KFEpubController *epubController;
@property (nonatomic, strong) KFEpubContentModel *contentModel;
@property (nonatomic, strong) NSDateFormatter* dateFormatter;

@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *inputView;

@property (weak) IBOutlet NSSplitView *subSplitView;
@property (weak) IBOutlet NSView *sourceSplitPane;
@property (weak) IBOutlet NSView *bookmarksSplitPane;
@property (weak) IBOutlet BooksView *booksView;
@property (weak) IBOutlet BookmarksView *bookmarksView;

@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSTextField *tabField;

@property (weak) IBOutlet ListCollectionView *listCollectionView;
@property (weak) IBOutlet NSView *listToolBarView;
@property (weak) IBOutlet NSSearchField *listSearchField;

@property (weak) IBOutlet NSMenu *actionMenu;

@end

@implementation AppDelegate {
    CGFloat _inputViewWidth;
    CGFloat _bookmarksSplitPaneHeight;
    CGFloat _tabBarFrameHeight;
}

@synthesize dateFormatter = _dateFormatter;
@synthesize epubController = _epubController;
@synthesize importedUrls = _importedUrls;
@synthesize tabViewControllers = _tabViewControllers;
@synthesize progressWindowController = _progressWindowController;

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Logging.
    LumberjackFormatter *formatter = [[LumberjackFormatter alloc] init];
	[[DDTTYLogger sharedInstance] setLogFormatter:formatter];
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [self setupToolBar];
    [self setupTabBar];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    DDLogDebug(@"applicationShouldTerminateAfterLastWindowClosed");
    return YES;
}

- (void)dealloc
{
    self.booksTreeController = nil;
    self.bookmarksArrayController = nil;
    self.listArrayController = nil;
    self.tabViewControllers = nil;
    self.importedUrls = nil;
    self.epubController = nil;
    self.contentModel = nil;
    self.dateFormatter = nil;
    self.progressWindowController = nil;
}

#pragma mark - Setters

- (NSMutableArray*)importedUrls
{
    if (_importedUrls == nil) {
        _importedUrls = [NSMutableArray array];
    }
    return _importedUrls;
}

- (ProgressWindowController*)progressWindowController
{
    if (_progressWindowController == nil) {
        _progressWindowController = [ProgressWindowController sharedController];
    };
    return _progressWindowController;
}

- (NSDateFormatter*)dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

- (NSMutableArray*)tabViewControllers
{
    if (_tabViewControllers == nil) {
        _tabViewControllers = [NSMutableArray array];
    }
    return _tabViewControllers;
}

#pragma mark - NSWindowDelegate

- (void)windowWillClose:(NSNotification *)notification
{
    if ([notification.object isEqualTo:self.window]) {
        [self.tabViewControllers removeAllObjects];
        [NSApp stopModal];
    }
}

- (void)windowDidResignMain:(NSNotification *)notification
{
    DDLogVerbose(@"windowDidResignMain: %@", [notification.object description]);
}

#pragma mark - TabView Controller

- (void)setupTabBar
{
    DDLogDebug(@"setupTabBar");
    
    _tabBarFrameHeight = self.tabBar.frame.size.height;
    [self.tabBar setStyleNamed:@"Aqua"];
    [self.tabBar setShowAddTabButton:YES];
    [self.tabBar setHideForSingleTab:YES];
}

- (IBAction)addNewTab:(id)sender {
    static NSInteger counter = 1;
    [self addNewTabWithTitle:[NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"New Image", nil), (long)counter++]];
}

- (void)addNewTabWithTitle:(NSString *)aTitle
{
	TabBarModel *newModel = [[TabBarModel alloc] init];
    [newModel setTitle:aTitle];
	NSTabViewItem *newItem = [[NSTabViewItem alloc] initWithIdentifier:newModel];
    
    ImageViewController* imageViewController = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];;
    [self.tabViewControllers addObject:imageViewController];
    imageViewController.managedObjectContext = self.managedObjectContext;
    imageViewController.tabViewItem = newItem;
    
    NSView* mainView = [imageViewController view];
    [newItem setView:mainView];
	[self.tabView addTabViewItem:newItem];
    [self.tabView selectTabViewItem:newItem];
}

- (void)addNewTabWithBook:(Book*)book
{
    TabBarModel *newModel = [[TabBarModel alloc] init];
    [newModel setTitle:book.title];
	NSTabViewItem *newItem = [[NSTabViewItem alloc] initWithIdentifier:newModel];
    
    BookViewController* bookViewController = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
    [self.tabViewControllers addObject:bookViewController];
    bookViewController.managedObjectContext = self.managedObjectContext;
    bookViewController.tabViewItem = newItem;
    bookViewController.book = book;
    
    NSView* mainView = [bookViewController view];
    [newItem setView:mainView];
	[self.tabView addTabViewItem:newItem];
    [self.tabView selectTabViewItem:newItem];
}

- (IBAction)closeTab:(id)sender
{
    NSTabViewItem *tabViewItem = [self.tabView selectedTabViewItem];
    [self closeTabWithItem:tabViewItem];
}

- (void)closeTabWithItem:(NSTabViewItem*)tabViewItem
{
    DDLogVerbose(@"tabViewItem: %@", tabViewItem);
    
    if (([self.tabBar delegate]) && ([[self.tabBar delegate] respondsToSelector:@selector(tabView:shouldCloseTabViewItem:)])) {
        if (![[self.tabBar delegate] tabView:self.tabView shouldCloseTabViewItem:tabViewItem]) {
            return;
        }
    }
    
    if (([self.tabBar delegate]) && ([[self.tabBar delegate] respondsToSelector:@selector(tabView:willCloseTabViewItem:)])) {
        [[self.tabBar delegate] tabView:self.tabView willCloseTabViewItem:tabViewItem];
    }
    [self.tabView removeTabViewItem:tabViewItem];
    
    if (([self.tabBar delegate]) && ([[self.tabBar delegate] respondsToSelector:@selector(tabView:didCloseTabViewItem:)])) {
        [[self.tabBar delegate] tabView:self.tabView didCloseTabViewItem:tabViewItem];
    }
}

- (void)updateSelectionWithTabBarViewItem:(NSTabViewItem*)tabViewItem
{
    DDLogVerbose(@"tabViewItem: %@", tabViewItem);
    [self.tabViewControllers enumerateObjectsUsingBlock:^(id <TabBarControllerProtocol>controller, NSUInteger idx, BOOL *stop) {
        if ([controller.tabViewItem isEqualTo:tabViewItem]) {
            *stop = YES;
            if ([controller isKindOfClass:[BookViewController class]]) {
                BookViewController* bookViewController = (BookViewController*)controller;
                [self.booksTreeController setSelectedObject:bookViewController.book];
                [self.listArrayController setSelectedObjects:@[bookViewController.book]];
            }
        }
    }];
}


#pragma mark - NSMenu Delegate

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    DDLogVerbose(@"validateMenuItem: %@ - %d", menuItem.title, [menuItem isEnabled]);
    return [menuItem isEnabled];
}

#pragma mark - NSToolbarItem Delegate

-(BOOL)validateToolbarItem:(NSToolbarItem *)toolbarItem
{
    DDLogVerbose(@"validateToolbarItem: %@", [toolbarItem label]);
    return [toolbarItem isEnabled];
}

#pragma mark - Target Action

- (IBAction)toggleBookMarksPane:(id)sender
{
    DDLogVerbose(@"_bookmarksSplitPaneHeight: %.0f, %f",_bookmarksSplitPaneHeight, self.splitView.frame.size.height);
    [self.subSplitView adjustSubviews];
    if ([self.subSplitView isSubviewCollapsed:self.bookmarksSplitPane]) {
        [self.subSplitView setPosition:self.subSplitView.frame.size.height-_bookmarksSplitPaneHeight ofDividerAtIndex:0];
    } else {
        [self.subSplitView setPosition:self.subSplitView.frame.size.height ofDividerAtIndex:0];
    }
}

- (void)selectListCoverFlowView:(id)sender
{
    DDLogDebug(@"sender: %@", sender);
    
    KFToolbarItem *listCollectionItem = self.toolBar.rightItems[0];
    listCollectionItem.state = NSOffState;
    KFToolbarItem *listCoverFlowItem = self.toolBar.rightItems[1];
    listCoverFlowItem.state = NSOnState;
}

- (void)selectListCollectionView:(id)sender
{
    DDLogDebug(@"sender: %@", sender);
    
    KFToolbarItem *listCollectionItem = self.toolBar.rightItems[0];
    listCollectionItem.state = NSOnState;
    KFToolbarItem *listCoverFlowItem = self.toolBar.rightItems[1];
    listCoverFlowItem.state = NSOffState;
}

#pragma mark - KFToolBar

- (void)setupToolBar
{
    DDLogDebug(@"setupToolBar");
    [self setToolBarForMainTabView];
    
}

- (void)updateToolBarContentForTabView:(NSTabViewItem*)tabViewItem
{
    DDLogVerbose(@"tabViewItem: %@", tabViewItem);
    
    if ([self.tabView indexOfTabViewItem:tabViewItem] == 0) {
        [self setToolBarForMainTabView];
    } else {
        [self setToolBarForBookTabView];
    }
}

- (void)setToolBarForMainTabView
{
    KFToolbarItem *addItem = [KFToolbarItem toolbarItemWithIcon:[NSImage imageNamed:NSImageNameAddTemplate] tag:0];
    addItem.toolTip = @"Add";
    addItem.keyEquivalent = @"o";
    
    
    KFToolbarItem *actionItem = [KFToolbarItem toolbarItemWithType:NSMomentaryPushInButton icon:[NSImage imageNamed:NSImageNameActionTemplate] tag:1];
    actionItem.toolTip = @"Action";
    actionItem.keyEquivalent = @"e";
    
    KFToolbarItem *bookmarksItem = [KFToolbarItem toolbarItemWithType:NSToggleButton icon:[NSImage imageNamed:NSImageNameBookmarksTemplate] tag:2];
    bookmarksItem.toolTip = @"Bookmarks";
    if ([self.subSplitView isSubviewCollapsed:self.bookmarksSplitPane]) {
        bookmarksItem.state = NSOffState;
    } else {
        bookmarksItem.state = NSOnState;
    }
    
    KFToolbarItem *listCoverFlowItem = [KFToolbarItem toolbarItemWithType:NSToggleButton icon:[NSImage imageNamed:NSImageNameFlowViewTemplate] tag:3];
    listCoverFlowItem.toolTip = @"CoverFlow";
    
    KFToolbarItem *listCollectionItem = [KFToolbarItem toolbarItemWithType:NSToggleButton icon:[NSImage imageNamed:NSImageNameIconViewTemplate] tag:4];
    listCollectionItem.toolTip = @"Collection";
    
    self.toolBar.leftItems = @[addItem, actionItem, bookmarksItem];
    self.toolBar.rightItems = @[listCollectionItem, listCoverFlowItem];
    
    [self selectListCollectionView:listCollectionItem];
    
    [self.toolBar setItemSelectionHandler:^(KFToolbarItemSelectionType selectionType, KFToolbarItem *toolbarItem, NSUInteger tag)
     {
         switch (tag)
         {
             case 0:
                 [self openImportDialog:addItem];
                 break;
                 
             case 1:
                 [actionItem.button setMenu:self.actionMenu];
                 break;
                 
             case 2:
                 [self toggleBookMarksPane:bookmarksItem];
                 break;
                 
             case 3:
                 [self selectListCoverFlowView:listCoverFlowItem];
                 break;
                 
             case 4:
                 [self selectListCollectionView:listCollectionItem];
                 break;
                 
             default:
                 break;
         }
     }];
}

- (void)setToolBarForBookTabView
{
    KFToolbarItem *shareItem = [KFToolbarItem toolbarItemWithIcon:[NSImage imageNamed:NSImageNameShareTemplate] tag:0];
    shareItem.toolTip = @"Share";
    shareItem.keyEquivalent = @"s";
    
    
    self.toolBar.leftItems = nil;
    self.toolBar.rightItems = @[shareItem];
    
    [self.toolBar setItemSelectionHandler:^(KFToolbarItemSelectionType selectionType, KFToolbarItem *toolbarItem, NSUInteger tag)
     {
         switch (tag)
         {
             case 0:
                 break;
                 
             case 1:
                 break;
                 
             case 2:
                 break;
                 
             default:
                 break;
         }
     }];
}

#pragma mark - Import file

- (IBAction)openImportDialog:(id)sender
{
    DDLogDebug(@"openImportDialog");
    NSOpenPanel* openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanCreateDirectories:NO];
    [openPanel setCanSelectHiddenExtension:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setResolvesAliases:YES];
    [openPanel setAllowedFileTypes:[self allowedFileTypes]];
    
    [openPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        
        DDLogVerbose(@"result: %ld, urls: %@", (long)result, [openPanel.URLs description]);
        if (result == 0) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            [self processFiles:openPanel.URLs];
        });
    }];
}

- (void)processFiles:(NSArray*)fileURLs
{
    NSInteger filesCount = fileURLs.count;
    
    [self.progressWindowController openProgressWindowWithTitle:NSLocalizedString(@"Importing File(s)", nil) info:NSLocalizedString(@"Loading…", nil) indicatorMinValue:0 indicatorMaxValue:filesCount doubleValue:0 indeterminate:NO animating:NO];
    __weak ProgressWindowController* weakProgressWindowController = self.progressWindowController;
    weakProgressWindowController.completionBlock = ^() {
        self.progressWindowController = nil;
        DDLogVerbose(@"ProgressWindowController closed");
    };
    
    NSURL* documentsDirectory = [self applicationDocumentsDirectory];
    
    __block NSInteger successFilesCount = 0;
    __block NSMutableArray* copiedUrls = [NSMutableArray new];
    
    [fileURLs enumerateObjectsUsingBlock:^(NSURL* fileUrl, NSUInteger idx, BOOL *stop) {
        
        NSURL* sandboxedFileUrl = [documentsDirectory URLByAppendingPathComponent:[fileUrl lastPathComponent]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            [self.progressWindowController updateProgressWindowWithInfo:[fileUrl lastPathComponent]];
        });
        
        [self.progressWindowController updateProgressWindowWithDoubleValue:(double)(idx + 1)];
        
        NSError* error;
        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:[sandboxedFileUrl path]]) {
            
            unsigned int counter = 1;
            while ([fileManager fileExistsAtPath:[sandboxedFileUrl path]]) {
                
                NSString* fileName = [[fileUrl lastPathComponent] stringByDeletingPathExtension];
                NSString* fileExtension = [fileUrl pathExtension];
                NSString* newFileName = [NSString stringWithFormat:@"%@-%i.%@", fileName, counter++, fileExtension];
                sandboxedFileUrl = [[sandboxedFileUrl URLByDeletingLastPathComponent] URLByAppendingPathComponent:newFileName];
                if (counter > 512) break;
            };
        }
        [fileManager copyItemAtURL:fileUrl toURL:sandboxedFileUrl error:&error];
        
        if (error != nil) {
            DDLogError(@"copying error: %@", [error localizedDescription]);
            [self.progressWindowController updateProgressWindowWithInfo:[error localizedDescription]];
        } else {
            successFilesCount ++;
            [copiedUrls addObject:sandboxedFileUrl];
        }
    }];
    
    self.importedFilesCount = successFilesCount;
    self.importedUrls = [NSMutableArray arrayWithArray:copiedUrls];
    [self.progressWindowController updateProgressWindowWithInfo:[NSString stringWithFormat:@"%@: %ld", NSLocalizedString(@"Total Imported Files", nil), successFilesCount]];
    [self processImportedFiles];
}

#pragma mark - Importing Book

- (void)processImportedFiles
{
    [self.progressWindowController updateProgressWindowWithTitle:NSLocalizedString(@"Processing File(s)", nil)];
    [self.progressWindowController updateProgressWindowWithInfo:[NSString stringWithFormat:@"%@: %ld", NSLocalizedString(@"Processing File(s)", nil), self.importedFilesCount]];
    [self.progressWindowController updateProgressWindowWithDoubleValue:0];
    [self.progressWindowController updateProgressWindowWithMinValue:0];
    [self.progressWindowController updateProgressWindowWithMaxValue:self.importedFilesCount];
    
    [self importBookWithUrl:[self.importedUrls firstObject]];
}

- (void)importBookWithUrl:(NSURL*)sandboxedFileUrl
{
    DDLogVerbose(@"sandboxedFileUrl: %@", [sandboxedFileUrl absoluteString]);
    self.epubController = [[KFEpubController alloc] initWithEpubURL:sandboxedFileUrl andDestinationFolder:[self applicationCacheDirectory]];
    self.epubController.delegate = self;
    [self.epubController openAsynchronous:YES];
}

#pragma mark - Deleting Book

- (void)unlinkBookWithUrl:(NSURL*)sandboxedFileUrl
{
    NSError* error;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:sandboxedFileUrl error:&error];
    
    if (error != nil) {
        DDLogError(@"deleting error: %@", [error localizedDescription]);
    }
}

#pragma mark - Exporting Book

- (void)exportBook:(Book*)book
{
    NSSavePanel* savePanel = [NSSavePanel savePanel];
    [savePanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        DDLogVerbose(@"result: %ld, url: %@", (long)result, [savePanel.URL description]);
        
    }];
}

#pragma mark - Preferences

- (IBAction)openPreferencesWindow:(id)sender
{
    PreferencesWindowController* preferencesWindowController = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindowController"];
    [preferencesWindowController.window makeKeyAndOrderFront:self];
    __weak PreferencesWindowController* weakPrefsWindowController = preferencesWindowController;
    weakPrefsWindowController.completionBlock = ^(BOOL success) {
        [preferencesWindowController.window close];
    };
}

#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
    if ([splitView isEqualTo:self.splitView] && [subview isEqualTo:self.contentView]) {
        return NO;
    }
    
    if ([splitView isEqualTo:self.subSplitView] && [subview isEqualTo:self.sourceSplitPane]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex {
    BOOL result = NO;
    if ([splitView isEqualTo:self.splitView]) {
        result = YES;
    }
    return result;
}

- (void)splitViewDidResizeSubviews:(NSNotification *)notification
{
    NSSplitView* splitView = (NSSplitView*)notification.object;
    
    if ([splitView isEqualTo:self.splitView]) {
        if ([self.splitView isSubviewCollapsed:self.inputView] == NO) {
            _inputViewWidth = self.inputView.frame.size.width;;
        }
    }
    
    if ([splitView isEqualTo:self.subSplitView]) {
        KFToolbarItem *bookmarksItem = self.toolBar.leftItems[2];
        if ([self.subSplitView isSubviewCollapsed:self.bookmarksSplitPane]) {
            bookmarksItem.state = NSOffState;
        } else {
            _bookmarksSplitPaneHeight = self.bookmarksSplitPane.frame.size.height;
            bookmarksItem.state = NSOnState;
        }
    }
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    if ([splitView isEqualTo:self.splitView]) {
        CGFloat max = self.splitView.frame.size.width/3;
        if (proposedMaximumPosition > max) {
            proposedMaximumPosition = max;
        }
        return proposedMaximumPosition;
    } else if ([splitView isEqualTo:self.subSplitView]) {
        CGFloat max = self.subSplitView.frame.size.height*4/5;
        if (proposedMaximumPosition > max) {
            proposedMaximumPosition = max;
        }
        return proposedMaximumPosition;
    }
    return CGFLOAT_MAX;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex
{
    if ([splitView isEqualTo:self.splitView]) {
        CGFloat min = self.splitView.frame.size.width/5;
        if (proposedMinimumPosition < min) {
            proposedMinimumPosition = min;
        }
        return proposedMinimumPosition;
    } else if ([splitView isEqualTo:self.subSplitView]) {
        CGFloat min = self.subSplitView.frame.size.height*1/2;
        if (proposedMinimumPosition < min) {
            proposedMinimumPosition = min;
        }
        return proposedMinimumPosition;
    }
    return 0;
}

#pragma mark - CoreData

- (NSURL *)applicationDocumentsDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appDocumemtsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return appDocumemtsURL;
}

- (NSURL *)applicationCacheDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appCacheURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    return [appCacheURL URLByAppendingPathComponent:@"cc.andyapps.ListenBooks"];
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "cc.andyapps.ListenBooks" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"cc.andyapps.ListenBooks"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ListenBooks" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"ListenBooks.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
                              NSInferMappingModelAutomaticallyOption:@YES,
                              NSSQLitePragmasOption: @{@"journal_mode": @"WAL"}
                              };
    
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
    
    DDLogVerbose(@"save");
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

#pragma mark - File System

- (NSArray*)allowedFileTypes
{
    return [[NSArray alloc] initWithObjects:@"epub", @"ibook", @"opf", nil];
}

#pragma mark - KFEpubDelegate

- (void)epubController:(KFEpubController *)controller willOpenEpub:(NSURL *)epubURL
{
    DDLogDebug(@"will open epub");
    [self.progressWindowController updateProgressWindowWithInfo:[epubURL lastPathComponent]];
    [self.importedUrls removeObject:epubURL];
}


- (void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel
{
    self.contentModel = contentModel;
    DDLogVerbose(@"url %@", [controller.epubURL path]);
    DDLogVerbose(@"meta %@", [self.contentModel.metaData description]);
    
    Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
    book.title = [self.contentModel.metaData objectForKey:@"title"];
    book.author = [self.contentModel.metaData objectForKey:@"author"];
    book.subject = [self.contentModel.metaData objectForKey:@"subject"];
    book.identifier = [self.contentModel.metaData objectForKey:@"identifier"];
    book.language = [self.contentModel.metaData objectForKey:@"language"];
    book.publisher = [self.contentModel.metaData objectForKey:@"publisher"];
    book.creator = [self.contentModel.metaData objectForKey:@"creator"];
    book.rights = [self.contentModel.metaData objectForKey:@"rights"];
    book.source = [self.contentModel.metaData objectForKey:@"source"];
    book.fileUrl = controller.epubURL;
    book.type = [NSNumber numberWithInteger:self.contentModel.bookType];
    book.encryption = [NSNumber numberWithInteger:self.contentModel.bookEncryption];
    book.date = [self.dateFormatter dateFromString:[self.contentModel.metaData objectForKey:@"date"]];
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Do a taks in the background
        
        __block NSMutableArray* spinedData = [[NSMutableArray alloc] init];
        [contentModel.spine enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSString* media = contentModel.manifest[contentModel.spine[idx]][@"media"];
            
            if ([media isEqualToString:@"application/xhtml+xml"]) {
                
                NSString *contentFile = contentModel.manifest[contentModel.spine[idx]][@"href"];
                NSURL *contentURL = [controller.epubContentBaseURL URLByAppendingPathComponent:contentFile];
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithURL:contentURL documentAttributes:nil];
                
                if (attributedString != nil) {
                    
                    [spinedData addObject:attributedString];
                    
                    Page *page = [NSEntityDescription insertNewObjectForEntityForName:@"Page" inManagedObjectContext:self.managedObjectContext];
                    page.book = book;
                    page.sortIndex = [NSNumber numberWithInteger:idx];
                    page.data = attributedString;
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            
            DDLogVerbose(@"inserted book: %@", [book description]);
            [self.progressWindowController updateProgressWindowWithDoubleValue:(self.importedFilesCount - [self.importedUrls count])];
            [self addNewTabWithBook:book];
            [self processNextFiles];
        });
    });
}

- (void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error
{
    DDLogError(@"epubController:didFailWithError: %@", error.description);
    
    [self.progressWindowController updateProgressWindowWithDoubleValue:(self.importedFilesCount - [self.importedUrls count])];
    [self unlinkBookWithUrl:controller.epubURL];
    [self processNextFiles];
}

- (void)processNextFiles
{
    if ([self.importedUrls count] == 0) {
        
        AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        [appDelegate saveAction:nil];
        
        [self.progressWindowController updateProgressWindowWithInfo:NSLocalizedString(@"Importing File(s) completed", nil)];
        [self.progressWindowController closeProgressWindow];
    } else {
        [self importBookWithUrl:[self.importedUrls firstObject]];
    }
}

#pragma mark - TabBar Config

- (void)configStyle:(id)sender {
	[self.tabBar setStyleNamed:[sender titleOfSelectedItem]];
}

- (void)configOnlyShowCloseOnHover:(id)sender {
	[self.tabBar setOnlyShowCloseOnHover:[sender state]];
}

- (void)configCanCloseOnlyTab:(id)sender {
	[self.tabBar setCanCloseOnlyTab:[sender state]];
}

- (void)configDisableTabClose:(id)sender {
	[self.tabBar setDisableTabClose:[sender state]];
}

- (void)configAllowBackgroundClosing:(id)sender {
	[self.tabBar setAllowsBackgroundTabClosing:[sender state]];
}

- (void)configHideForSingleTab:(id)sender {
	[self.tabBar setHideForSingleTab:[sender state]];
}

- (void)configAddTabButton:(id)sender {
	[self.tabBar setShowAddTabButton:[sender state]];
}

- (void)configTabMinWidth:(id)sender {
	if ([self.tabBar buttonOptimumWidth] < [sender integerValue]) {
		[self.tabBar setButtonMinWidth:[self.tabBar buttonOptimumWidth]];
		[sender setIntegerValue:[self.tabBar buttonOptimumWidth]];
		return;
	}
    
	[self.tabBar setButtonMinWidth:[sender integerValue]];
}

- (void)configTabMaxWidth:(id)sender {
	if ([self.tabBar buttonOptimumWidth] > [sender integerValue]) {
		[self.tabBar setButtonMaxWidth:[self.tabBar buttonOptimumWidth]];
		[sender setIntegerValue:[self.tabBar buttonOptimumWidth]];
		return;
	}
    
	[self.tabBar setButtonMaxWidth:[sender integerValue]];
}

- (void)configTabOptimumWidth:(id)sender {
	if ([self.tabBar buttonMaxWidth] < [sender integerValue]) {
		[self.tabBar setButtonOptimumWidth:[self.tabBar buttonMaxWidth]];
		[sender setIntegerValue:[self.tabBar buttonMaxWidth]];
		return;
	}
    
	if ([self.tabBar buttonMinWidth] > [sender integerValue]) {
		[self.tabBar setButtonOptimumWidth:[self.tabBar buttonMinWidth]];
		[sender setIntegerValue:[self.tabBar buttonMinWidth]];
		return;
	}
    
	[self.tabBar setButtonOptimumWidth:[sender integerValue]];
}

- (void)configTabSizeToFit:(id)sender {
	[self.tabBar setSizeButtonsToFit:[sender state]];
}

- (void)configTearOffStyle:(id)sender {
	[self.tabBar setTearOffStyle:([sender indexOfSelectedItem] == 0) ? MMTabBarTearOffAlphaWindow : MMTabBarTearOffMiniwindow];
}

- (void)configUseOverflowMenu:(id)sender {
	[self.tabBar setUseOverflowMenu:[sender state]];
}

- (void)configAutomaticallyAnimates:(id)sender {
	[self.tabBar setAutomaticallyAnimates:[sender state]];
}

- (void)configAllowsScrubbing:(id)sender {
	[self.tabBar setAllowsScrubbing:[sender state]];
}

- (void)addNewTabToTabView:(NSTabView *)aTabView {
    DDLogVerbose(@"addNewTabToTabView");
    [self addNewTab:aTabView];
}

#pragma mark - TabView Delegate

- (void)tabView:(NSTabView *)aTabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem
{
    DDLogVerbose(@"tabViewItem: %@", [tabViewItem label]);
    [self updateToolBarContentForTabView:tabViewItem];
    [self updateSelectionWithTabBarViewItem:tabViewItem];
}

- (void)tabView:(NSTabView *)aTabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
	// need to update bound values to match the selected tab
    DDLogVerbose(@"tabViewItem: %@", [tabViewItem label]);
    if ([[tabViewItem identifier] respondsToSelector:@selector(title)]) {
        [self.tabField setStringValue:[[tabViewItem identifier] title]];
    }
    //self.window.title = [tabViewItem label];
}

- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)tabView
{
    NSUInteger tabsCount = [[tabView tabViewItems] count];
    DDLogVerbose(@"tabViewDidChangeNumberOfTabViewItems: %lu", (unsigned long)tabsCount);
    DDLogVerbose(@"tabViewControllers: %@", self.tabViewControllers);
}

- (BOOL)tabView:(NSTabView *)aTabView shouldCloseTabViewItem:(NSTabViewItem *)tabViewItem {
	return YES;
}

- (void)tabView:(NSTabView *)aTabView didCloseTabViewItem:(NSTabViewItem *)tabViewItem {
	DDLogVerbose(@"tabViewItem: %@", [tabViewItem label]);
}

- (void)tabView:(NSTabView *)aTabView didDetachTabViewItem:(NSTabViewItem *)tabViewItem
{
    DDLogVerbose(@"tabViewItem: %@", [tabViewItem label]);
    [self.tabViewControllers enumerateObjectsUsingBlock:^(id <TabBarControllerProtocol>controller, NSUInteger idx, BOOL *stop) {
        
        if ([controller.tabViewItem isEqualTo:tabViewItem]) {
            [_tabViewControllers removeObject:controller];
        }
    }];
}

- (void)tabView:(NSTabView *)aTabView didMoveTabViewItem:(NSTabViewItem *)tabViewItem toIndex:(NSUInteger)index
{
    DDLogVerbose(@"tab view did move tab view item %@ to index:%ld",[tabViewItem label],index);
}

- (NSArray *)allowedDraggedTypesForTabView:(NSTabView *)aTabView {
	return [NSArray arrayWithObjects:NSFilenamesPboardType, NSStringPboardType, nil];
}

- (BOOL)tabView:(NSTabView *)aTabView acceptedDraggingInfo:(id <NSDraggingInfo>)draggingInfo onTabViewItem:(NSTabViewItem *)tabViewItem {
	DDLogVerbose(@"acceptedDraggingInfo: %@ onTabViewItem: %@", [[draggingInfo draggingPasteboard] stringForType:[[[draggingInfo draggingPasteboard] types] objectAtIndex:0]], [tabViewItem label]);
    return YES;
}

- (NSMenu *)tabView:(NSTabView *)aTabView menuForTabViewItem:(NSTabViewItem *)tabViewItem {
	DDLogVerbose(@"menuForTabViewItem: %@", [tabViewItem label]);
	return nil;
}

- (BOOL)tabView:(NSTabView *)aTabView shouldAllowTabViewItem:(NSTabViewItem *)tabViewItem toLeaveTabBarView:(MMTabBarView *)tabBarView {
    return NO;
}

- (BOOL)tabView:(NSTabView*)aTabView shouldDragTabViewItem:(NSTabViewItem *)tabViewItem inTabBarView:(MMTabBarView *)tabBarView {
	return YES;
}

- (NSDragOperation)tabView:(NSTabView*)aTabView validateDrop:(id<NSDraggingInfo>)sender proposedItem:(NSTabViewItem *)tabViewItem proposedIndex:(NSUInteger)proposedIndex inTabBarView:(MMTabBarView *)tabBarView {
    
    return NSDragOperationMove;
}

- (NSDragOperation)tabView:(NSTabView *)aTabView validateSlideOfProposedItem:(NSTabViewItem *)tabViewItem proposedIndex:(NSUInteger)proposedIndex inTabBarView:(MMTabBarView *)tabBarView {
    
    return NSDragOperationMove;
}

- (void)tabView:(NSTabView*)aTabView didDropTabViewItem:(NSTabViewItem *)tabViewItem inTabBarView:(MMTabBarView *)tabBarView {
	DDLogVerbose(@"didDropTabViewItem: %@ inTabBarView: %@", [tabViewItem label], tabBarView);
}

- (NSImage *)tabView:(NSTabView *)aTabView imageForTabViewItem:(NSTabViewItem *)tabViewItem offset:(NSSize *)offset styleMask:(NSUInteger *)styleMask {
	// grabs whole window image
	NSImage *viewImage = [[NSImage alloc] init];
	NSRect contentFrame = [[[self window] contentView] frame];
	[[[self window] contentView] lockFocus];
	NSBitmapImageRep *viewRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:contentFrame];
	[viewImage addRepresentation:viewRep];
	[[[self window] contentView] unlockFocus];
    
	// grabs snapshot of dragged tabViewItem's view (represents content being dragged)
	NSView *viewForImage = [tabViewItem view];
	NSRect viewRect = [viewForImage frame];
	NSImage *tabViewImage = [[NSImage alloc] initWithSize:viewRect.size];
	[tabViewImage lockFocus];
	[viewForImage drawRect:[viewForImage bounds]];
	[tabViewImage unlockFocus];
    
	[viewImage lockFocus];
	NSPoint tabOrigin = [self.tabView frame].origin;
	tabOrigin.x += 10;
	tabOrigin.y += _tabBarFrameHeight/2+2;
    [tabViewImage drawAtPoint:tabOrigin fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    [tabViewImage compositeToPoint:tabOrigin operation:NSCompositeSourceOver];
	[viewImage unlockFocus];
    
    MMTabBarView *tabBarView = (MMTabBarView *)[aTabView delegate];
    
	//draw over where the tab bar would usually be
	NSRect tabFrame = [self.tabBar frame];
	[viewImage lockFocus];
	[[NSColor windowBackgroundColor] set];
	NSRectFill(tabFrame);
	//draw the background flipped, which is actually the right way up
	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform scaleXBy:1.0 yBy:-1.0];
	[transform concat];
	tabFrame.origin.y = -tabFrame.origin.y - tabFrame.size.height;
	[[tabBarView style] drawBezelOfTabBarView:tabBarView inRect:tabFrame];
	[transform invert];
	[transform concat];
	[viewImage unlockFocus];
    
	if ([tabBarView orientation] == MMTabBarHorizontalOrientation) {
		offset->width = [tabBarView leftMargin];
		offset->height = _tabBarFrameHeight;
	} else {
		offset->width = 0;
		offset->height = _tabBarFrameHeight + [tabBarView topMargin];
	}
    
	if (styleMask) {
		*styleMask = NSTitledWindowMask | NSTexturedBackgroundWindowMask;
	}
    
	return viewImage;
}

- (MMTabBarView *)tabView:(NSTabView *)aTabView newTabBarViewForDraggedTabViewItem:(NSTabViewItem *)tabViewItem atPoint:(NSPoint)point {
	DDLogVerbose(@"newTabBarViewForDraggedTabViewItem: %@ atPoint: %@", [tabViewItem label], NSStringFromPoint(point));
    
	//create a new window controller with no tab items
    return nil;
}

- (void)tabView:(NSTabView *)aTabView closeWindowForLastTabViewItem:(NSTabViewItem *)tabViewItem {
	DDLogVerbose(@"closeWindowForLastTabViewItem: %@", [tabViewItem label]);
	[[self window] close];
}

- (void)tabView:(NSTabView *)aTabView tabBarViewDidHide:(MMTabBarView *)tabBarView {
	DDLogVerbose(@"tabBarViewDidHide: %@", NSStringFromRect(tabBarView.frame));
    
    NSArray *constraints = tabBarView.constraints;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
    NSArray* filteredArray = [constraints filteredArrayUsingPredicate:predicate];
    if (filteredArray.count != 0) {
        NSLayoutConstraint *constraint =  [constraints firstObject];
        [[constraint animator] setConstant:0];
    }
}

- (void)tabView:(NSTabView *)aTabView tabBarViewDidUnhide:(MMTabBarView *)tabBarView {
	DDLogVerbose(@"tabBarViewDidUnhide: %@", NSStringFromRect(tabBarView.frame));
    
    NSArray *constraints = tabBarView.constraints;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
    NSArray* filteredArray = [constraints filteredArrayUsingPredicate:predicate];
    if (filteredArray.count != 0) {
        NSLayoutConstraint *constraint =  [constraints firstObject];
        [[constraint animator] setConstant:_tabBarFrameHeight];
    }
}

- (NSString *)tabView:(NSTabView *)aTabView toolTipForTabViewItem:(NSTabViewItem *)tabViewItem {
	return [tabViewItem label];
}

- (NSString *)accessibilityStringForTabView:(NSTabView *)aTabView objectCount:(NSInteger)objectCount {
	return (objectCount == 1) ? @"item" : @"items";
}

@end
//
//  AppDelegate.m
//  ListenBooks
//
//  Created by Libor Kučera on 14.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+TabBarView.h"
#import "KFToolbar.h"
#import "KFToolbarItem.h"

#import "ListViewController.h"
#import "BookViewController.h"
#import "ImageViewController.h"

#import "BooksTreeController.h"
#import "BookmarksArrayController.h"

NSString* const UpdateWebViewControllerNotification = @"UPDATE_TABVIEWCONTROLLER_NOTIFICATION";

@implementation AppDelegate {
    CGFloat _inputViewWidth;
    CGFloat _bookmarksSplitPaneHeight;
}

@synthesize dateFormatter = _dateFormatter;
@synthesize epubController = _epubController;
@synthesize importedUrls = _importedUrls;
@synthesize tabViewControllers = _tabViewControllers;

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

#pragma mark - Setters

- (NSMutableArray*)importedUrls
{
    if (_importedUrls == nil) {
        _importedUrls = [NSMutableArray array];
    }
    return _importedUrls;
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
    DDLogVerbose(@"setupTabBar");
    
    [self.menuItemCloseTab setEnabled:NO];
    [self.tabBar setStyleNamed:@"Safari"];
    [self.tabBar setShowAddTabButton:YES];
    [self.tabBar setHideForSingleTab:YES];
}

- (IBAction)addNewTab:(id)sender {
    static NSInteger counter = 1;
    [self addNewTabWithTitle:[NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"New Image", nil), (long)counter++]];
}

- (void)addNewTabWithTitle:(NSString *)aTitle {
    
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
    NSView* mainView = [bookViewController view];
    [newItem setView:mainView];
	[self.tabView addTabViewItem:newItem];
    [self.tabView selectTabViewItem:newItem];
    bookViewController.book = book;
}


- (IBAction)closeTab:(id)sender {
    
    NSTabViewItem *tabViewItem = [self.tabView selectedTabViewItem];
    
    if (([self.tabBar delegate]) && ([[self.tabBar delegate] respondsToSelector:@selector(tabView:shouldCloseTabViewItem:)])) {
        if (![[self.tabBar delegate] tabView:self.tabView shouldCloseTabViewItem:tabViewItem]) {
            return;
        }
    }
    
    if (([self.tabBar delegate]) && ([[self.tabBar delegate] respondsToSelector:@selector(tabView:willCloseTabViewItem:)])) {
        [[self.tabBar delegate] tabView:self.tabView willCloseTabViewItem:tabViewItem];
    }
    
    NSUInteger index = [[self.tabView tabViewItems] indexOfObject:tabViewItem] - 1;
    [self.tabViewControllers removeObjectAtIndex:index];
    [self.tabView removeTabViewItem:tabViewItem];
    
    if (([self.tabBar delegate]) && ([[self.tabBar delegate] respondsToSelector:@selector(tabView:didCloseTabViewItem:)])) {
        [[self.tabBar delegate] tabView:self.tabView didCloseTabViewItem:tabViewItem];
    }
}

- (void)closeTabWithItem:(NSTabViewItem*)tabViewItem
{
    if (([self.tabBar delegate]) && ([[self.tabBar delegate] respondsToSelector:@selector(tabView:shouldCloseTabViewItem:)])) {
        if (![[self.tabBar delegate] tabView:self.tabView shouldCloseTabViewItem:tabViewItem]) {
            return;
        }
    }
    
    if (([self.tabBar delegate]) && ([[self.tabBar delegate] respondsToSelector:@selector(tabView:willCloseTabViewItem:)])) {
        [[self.tabBar delegate] tabView:self.tabView willCloseTabViewItem:tabViewItem];
    }
    
    NSUInteger index = [[self.tabView tabViewItems] indexOfObject:tabViewItem] - 1;
    [self.tabViewControllers removeObjectAtIndex:index];
    [self.tabView removeTabViewItem:tabViewItem];
    
    if (([self.tabBar delegate]) && ([[self.tabBar delegate] respondsToSelector:@selector(tabView:didCloseTabViewItem:)])) {
        [[self.tabBar delegate] tabView:self.tabView didCloseTabViewItem:tabViewItem];
    }
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
        DDLogVerbose(@"Open");
        [self.subSplitView setPosition:self.subSplitView.frame.size.height-_bookmarksSplitPaneHeight ofDividerAtIndex:0];
    } else {
        DDLogVerbose(@"Close");
        [self.subSplitView setPosition:self.subSplitView.frame.size.height ofDividerAtIndex:0];
    }
}

- (void)selectListCoverFlowView:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    
    [self.listCollectionView setHidden:YES];
    KFToolbarItem *listCollectionItem = self.toolBar.rightItems[0];
    listCollectionItem.state = NSOffState;
    KFToolbarItem *listCoverFlowItem = self.toolBar.rightItems[1];
    listCoverFlowItem.state = NSOnState;
}

- (void)selectListCollectionView:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    
    [self.listCollectionView setHidden:NO];
    KFToolbarItem *listCollectionItem = self.toolBar.rightItems[0];
    listCollectionItem.state = NSOnState;
    KFToolbarItem *listCoverFlowItem = self.toolBar.rightItems[1];
    listCoverFlowItem.state = NSOffState;
}

#pragma mark - KFToolBar

- (void)setupToolBar
{
    DDLogVerbose(@"setupToolBar");
    
    KFToolbarItem *addItem = [KFToolbarItem toolbarItemWithIcon:[NSImage imageNamed:NSImageNameAddTemplate] tag:0];
    addItem.toolTip = @"Add";
    addItem.keyEquivalent = @"q";
    
    
    KFToolbarItem *actionItem = [KFToolbarItem toolbarItemWithType:NSMomentaryPushInButton icon:[NSImage imageNamed:NSImageNameActionTemplate] tag:1];
    actionItem.toolTip = @"Action";
    actionItem.keyEquivalent = @"a";
    
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

#pragma mark - Import file

- (IBAction)openImportDialog:(id)sender
{
    DDLogVerbose(@"openImportDialog");
    NSOpenPanel* openpanel = [NSOpenPanel openPanel];
    [openpanel setCanChooseFiles:YES];
    [openpanel setCanCreateDirectories:NO];
    [openpanel setCanSelectHiddenExtension:YES];
    [openpanel setCanChooseDirectories:NO];
    [openpanel setAllowsMultipleSelection:YES];
    [openpanel setResolvesAliases:YES];
    [openpanel setAllowedFileTypes:[self allowedFileTypes]];
    
    [openpanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        
        DDLogVerbose(@"result: %ld, urls: %@", (long)result, [openpanel.URLs description]);
        if (result == 0) {
            return ;
        }
        
        [self.progressWindow orderFront:self];
        NSInteger filesCount = openpanel.URLs.count;
        self.progressIndicatior.doubleValue = 0;
        self.progressIndicatior.minValue = 0;
        self.progressIndicatior.maxValue = filesCount;
        self.progressIndicatior.indeterminate = NO;
        self.progressTitle.stringValue = NSLocalizedString(@"Importing files", nil);
        
        NSURL* documentsDirectory = [self applicationDocumentsDirectory];
        __block NSInteger successFilesCount = 0;
        __block NSTextField* progressInfo = self.progressInfo;
        __block NSProgressIndicator* progressIndicator = self.progressIndicatior;
        __block NSMutableArray* copiedUrls = [NSMutableArray new];
        
        [openpanel.URLs enumerateObjectsUsingBlock:^(NSURL* fileUrl, NSUInteger idx, BOOL *stop) {
            
            NSURL* sandboxedFileUrl = [documentsDirectory URLByAppendingPathComponent:[fileUrl lastPathComponent]];
            progressInfo.stringValue = [fileUrl lastPathComponent];
            progressIndicator.doubleValue = idx;
            
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
                self.progressInfo.stringValue = [error localizedDescription];
            } else {
                successFilesCount ++;
                [copiedUrls addObject:sandboxedFileUrl];
            }
        }];
        
        self.progressIndicatior.doubleValue = 0;
        self.progressIndicatior.minValue = 0;
        self.progressIndicatior.maxValue = [copiedUrls count];
        self.progressInfo.stringValue = [NSString stringWithFormat:@"%@: %ld", NSLocalizedString(@"Processing file(s)", nil), successFilesCount];
        
        self.importedUrls = [NSMutableArray arrayWithArray:copiedUrls];

        [self importBookWithUrl:[self.importedUrls firstObject]];
        
    }];
}

#pragma mark - Importing Book

- (void)importBookWithUrl:(NSURL*)sandboxedFileUrl
{
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
    [self saveAction:nil];
}

#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
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
        CGFloat width = self.inputView.frame.size.width;
        if (width > 0) {
            _inputViewWidth = width;
        }
    }
    
    if ([splitView isEqualTo:self.subSplitView]) {
        CGFloat height = self.bookmarksSplitPane.frame.size.height;
        KFToolbarItem *bookmarksItem = self.toolBar.leftItems[2];
        DDLogVerbose(@"height: %.0f, splitView.frame.size.height: %.0f", height, splitView.frame.size.height);
        if (height > bookmarksPaneMinHeight) {
            _bookmarksSplitPaneHeight = height;
            bookmarksItem.state = NSOnState;
        } else {
            bookmarksItem.state = NSOffState;
        }
        DDLogVerbose(@"_bookmarksSplitPaneHeight: %.0f", _bookmarksSplitPaneHeight);
    }
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
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
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
    DDLogVerbose(@"will open epub");
    self.progressInfo.stringValue = NSLocalizedString([epubURL lastPathComponent], nil);
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
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        DDLogError(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    
    DDLogVerbose(@"inserted book: %@", [book description]);
    self.progressIndicatior.doubleValue = self.progressIndicatior.maxValue - [self.importedUrls count];
    
    if ([self.importedUrls count] == 0) {
        [self.booksTreeController setSelectedObject:book];
        [self.progressWindow close];
    } else {
        [self importBookWithUrl:[self.importedUrls firstObject]];
    }
    self.contentModel = nil;
}


- (void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error
{
    DDLogVerbose(@"epubController:didFailWithError: %@", error.description);
    self.progressIndicatior.doubleValue = self.progressIndicatior.maxValue - [self.importedUrls count];
    self.progressInfo.stringValue = error.localizedDescription;
    [self unlinkBookWithUrl:controller.epubURL];
    
    if ([self.importedUrls count] == 0) {
        [self.progressWindow close];
    } else {
        [self importBookWithUrl:[self.importedUrls firstObject]];
    }
}

@end
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

#import "ListViewController.h"
#import "BookViewController.h"
#import "ImageViewController.h"

@implementation AppDelegate

@synthesize dateFormatter = _dateFormatter;
@synthesize epubController = _epubController;

@synthesize listViewController = _listViewController;
@synthesize bookViewController = _bookViewController;
@synthesize imageViewController = _imageViewController;

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupToolBar];
}

#pragma mark - Setters

- (NSDateFormatter*)dateFormatter
{
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

- (ListViewController*)listViewController
{
    if (_listViewController == nil) {
        _listViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    }
    return _listViewController;
}

- (BookViewController*)bookViewController
{
    if (_bookViewController == nil) {
        _bookViewController = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
    }
    return _bookViewController;
}

- (ImageViewController*)imageViewController
{
    if (_imageViewController == nil) {
        _imageViewController = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    }
    return _imageViewController;
}


#pragma mark - SubViews

- (void)removeSubViewsFromContentView
{
    [[self.contentView subviews] enumerateObjectsUsingBlock:^(NSView* subView, NSUInteger idx, BOOL *stop) {
        [subView removeFromSuperview];
    }];
}

- (void)setupContentViewConstraintsForSubView:(NSView*)subView
{
    [subView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraintLeading = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    [self.contentView addConstraint:constraintLeading];
    
    NSLayoutConstraint *constraintTrailing = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    [self.contentView addConstraint:constraintTrailing];
    
    NSLayoutConstraint *constraintTop = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    [self.contentView addConstraint:constraintTop];
    
    NSLayoutConstraint *constraintBottom = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    [self.contentView addConstraint:constraintBottom];
    
}

#pragma mark - Target Action

- (IBAction)selectBookViewController:(id)sender
{
    [self removeSubViewsFromContentView];
    [self.contentView addSubview:self.bookViewController.view];
    [self setupContentViewConstraintsForSubView:self.bookViewController.view];
}

- (IBAction)selectListViewController:(id)sender
{
    [self removeSubViewsFromContentView];
    [self.contentView addSubview:self.listViewController.view];
    [self setupContentViewConstraintsForSubView:self.listViewController.view];
}

- (IBAction)selectImageViewController:(id)sender
{
    [self removeSubViewsFromContentView];
    [self.contentView addSubview:self.imageViewController.view];
    [self setupContentViewConstraintsForSubView:self.imageViewController.view];
}

#pragma mark - KFToolBar

- (void)setupToolBar
{
    KFToolbarItem *addItem = [KFToolbarItem toolbarItemWithIcon:[NSImage imageNamed:NSImageNameAddTemplate] tag:0];
    addItem.toolTip = @"Add";
    addItem.keyEquivalent = @"q";
    
    
    KFToolbarItem *actionItem = [KFToolbarItem toolbarItemWithType:NSMomentaryPushInButton icon:[NSImage imageNamed:NSImageNameActionTemplate] tag:1];
    actionItem.toolTip = @"Action";
    actionItem.keyEquivalent = @"a";
    
    KFToolbarItem *bookmarksItem = [KFToolbarItem toolbarItemWithType:NSToggleButton icon:[NSImage imageNamed:NSImageNameBookmarksTemplate] tag:2];
    bookmarksItem.toolTip = @"Bookmarks";
    
    
    KFToolbarItem *listItem = [KFToolbarItem toolbarItemWithType:NSToggleButton icon:[NSImage imageNamed:NSImageNameIconViewTemplate] tag:3];
    listItem.toolTip = @"List";
    listItem.state = NSOffState;
    
    KFToolbarItem *bookItem = [KFToolbarItem toolbarItemWithType:NSToggleButton icon:[NSImage imageNamed:NSImageNameFlowViewTemplate] tag:4];
    bookItem.toolTip = @"View";
    bookItem.state = NSOnState;
    
    self.toolBar.leftItems = @[addItem, actionItem, bookmarksItem];
    self.toolBar.rightItems = @[bookItem, listItem];
    
    [self selectBookViewController:bookItem];
    
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
                 break;
                 
             case 3:
                 [self selectListViewController:listItem];
                 bookItem.state = !listItem.state;
                 break;
                 
             case 4:
                 [self selectBookViewController:bookItem];
                 listItem.state = !bookItem.state;
                 break;
                 
             default:
                 break;
         }
     }];
}

#pragma mark - Import file

- (IBAction)openImportDialog:(id)sender
{
    NSLog(@"openImportDialog");
    NSOpenPanel* openpanel = [NSOpenPanel openPanel];
    [openpanel setCanChooseFiles:YES];
    [openpanel setCanCreateDirectories:NO];
    [openpanel setCanSelectHiddenExtension:YES];
    [openpanel setCanChooseDirectories:NO];
    [openpanel setAllowsMultipleSelection:NO];
    [openpanel setResolvesAliases:YES];
    [openpanel setAllowedFileTypes:[self allowedFileTypes]];
    
    [openpanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        
        NSLog(@"result: %ld, urls: %@", (long)result, [openpanel.URLs description]);
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
        __block NSMutableArray* copiedFiles = [NSMutableArray new];
        
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
                };
            }
            [fileManager copyItemAtURL:fileUrl toURL:sandboxedFileUrl error:&error];

            if (error != nil) {
                NSLog(@"copying error: %@", [error localizedDescription]);
                self.progressInfo.stringValue = [error localizedDescription];
            } else {
                successFilesCount ++;
                [copiedFiles addObject:sandboxedFileUrl];
            }
        }];
        
        self.progressIndicatior.doubleValue = 0;
        self.progressIndicatior.indeterminate = YES;
        self.progressInfo.stringValue = [NSString stringWithFormat:@"%@: %ld", NSLocalizedString(@"Processing file(s)", nil), successFilesCount];

        [copiedFiles enumerateObjectsUsingBlock:^(NSURL* epubURL, NSUInteger idx, BOOL *stop) {
            self.epubController = [[KFEpubController alloc] initWithEpubURL:epubURL andDestinationFolder:[self applicationCacheDirectory]];
            self.epubController.delegate = self;
            [self.epubController openAsynchronous:YES];
            
        }];
        
    }];
}

#pragma mark - deleting Book

- (void)unlinkBookWithUrl:(NSURL*)sandboxedFileUrl
{
    NSError* error;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:sandboxedFileUrl error:&error];
    
    if (error != nil) {
        NSLog(@"deleting error: %@", [error localizedDescription]);
    }
    [self saveAction:nil];
    self.bookViewController.book = nil;
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
    
    NSLog(@"save");
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
    return [[NSArray alloc] initWithObjects:@"epub", nil];
}

#pragma mark - KFEpubDelegate

- (void)epubController:(KFEpubController *)controller willOpenEpub:(NSURL *)epubURL
{
    NSLog(@"will open epub");
    [self.progressIndicatior startAnimation:nil];
}


- (void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel
{
    NSLog(@"url %@", [controller.epubURL path]);
    NSLog(@"model %@", [contentModel description]);
    NSLog(@"meta %@", [contentModel.metaData description]);
    NSLog(@"cover %@", contentModel.coverPath);
    
    Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.managedObjectContext];
    book.title = [contentModel.metaData objectForKey:@"title"];
    book.author = [contentModel.metaData objectForKey:@"author"];
    book.subject = [contentModel.metaData objectForKey:@"subject"];
    book.identifier = [contentModel.metaData objectForKey:@"identifier"];
    book.language = [contentModel.metaData objectForKey:@"language"];
    book.publisher = [contentModel.metaData objectForKey:@"publisher"];
    book.creator = [contentModel.metaData objectForKey:@"creator"];
    book.rights = [contentModel.metaData objectForKey:@"rights"];
    book.source = [contentModel.metaData objectForKey:@"source"];
    book.fileUrl = controller.epubURL;
    book.type = [NSNumber numberWithInteger:contentModel.bookType];
    book.encryption = [NSNumber numberWithInteger:contentModel.bookEncryption];
    book.date = [self.dateFormatter dateFromString:[contentModel.metaData objectForKey:@"date"]];
    
    self.bookViewController.book = book;
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSLog(@"book: %@", [book description]);
    [self.progressIndicatior stopAnimation:nil];
    [self.progressWindow close];
}


- (void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error
{
    NSLog(@"epubController:didFailWithError: %@", error.description);
    [self.progressIndicatior stopAnimation:nil];
    self.progressInfo.stringValue = error.localizedDescription;
}

@end
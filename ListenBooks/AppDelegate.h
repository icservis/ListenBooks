//
//  AppDelegate.h
//  ListenBooks
//
//  Created by Libor Kučera on 14.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class KFToolbar;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSSplitView *splitView;
@property (weak) IBOutlet KFToolbar *toolBar;
@property (weak) IBOutlet NSMenu *actionMenu;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSURL *)applicationDocumentsDirectory;
- (NSURL *)applicationCacheDirectory;

- (IBAction)saveAction:(id)sender;

@end

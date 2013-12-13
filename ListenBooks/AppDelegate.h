//
//  AppDelegate.h
//  ListenBooks
//
//  Created by Libor Kučera on 13.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KFEpubKit.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, KFEpubControllerDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong) KFEpubController* epubController;

- (IBAction)saveAction:(id)sender;

@end

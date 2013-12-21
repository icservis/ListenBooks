//
//  BookViewController.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KFEpubController.h"
#import "KFEpubContentModel.h"

@class BookPageController;

@interface BookViewController : NSViewController <NSPageControllerDelegate, KFEpubControllerDelegate>
@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSView *pageView;
@property (strong) IBOutlet NSPageController *pageController;
@property (nonatomic, strong) NSURL *libraryURL;
@property (nonatomic, strong) KFEpubController *epubController;
@property (nonatomic, strong) KFEpubContentModel *contentModel;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end

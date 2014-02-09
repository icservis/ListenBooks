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
#import "Book.h"

static NSString* const TextSizeDidChangeNotificaton = @"TEXT_SIZE_DID_CHANGE_NOTIFICATION";

@class BookPageController;

@interface BookViewController : NSViewController <NSPageControllerDelegate, KFEpubControllerDelegate>

@property (strong) Book* book;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong) NSTabViewItem* tabViewItem;

@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSView *pageView;
@property (strong) IBOutlet NSPageController *pageController;
@property (nonatomic, strong) NSURL *libraryURL;
@property (nonatomic, strong) KFEpubController *epubController;
@property (nonatomic, strong) KFEpubContentModel *contentModel;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSSlider *textSizeSlider;

- (void)resetPageView;

@end

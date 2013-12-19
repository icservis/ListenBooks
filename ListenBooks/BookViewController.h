//
//  BookViewController.h
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BookPageController;

@interface BookViewController : NSViewController <NSPageControllerDelegate>
@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSView *pageView;
@property (strong) IBOutlet BookPageController *pageController;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

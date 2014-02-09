//
//  InformationWindowController.m
//  ListenBooks
//
//  Created by Libor Kučera on 09/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "InformationWindowController.h"
#import "Book.h"

@interface InformationWindowController ()
@property (weak) IBOutlet NSView *view;
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSButton *saveButton;
@property (weak) IBOutlet NSButton *closeButton;
- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;

@end

@implementation InformationWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.window.title = self.book.title;
}


- (IBAction)saveButtonClicked:(id)sender
{
    if (self.completionBlock != nil) {
        self.completionBlock(YES);
    }
}

- (IBAction)closeButtonClicked:(id)sender
{
    if (self.completionBlock != nil) {
        self.completionBlock(NO);
    }
}
@end

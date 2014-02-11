//
//  ExportWindowController.m
//  ListenBooks
//
//  Created by Libor Kučera on 11/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "ExportWindowController.h"
#import "Book.h"

@interface ExportWindowController ()

@property (weak) IBOutlet NSView *view;
@property (weak) IBOutlet NSButton *exportButton;
@property (weak) IBOutlet NSButton *closeButton;
- (IBAction)exportButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;

@end

@implementation ExportWindowController

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
    DDLogVerbose(@"windowDidLoad");
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.window.title = self.book.title;
}

- (IBAction)exportButtonClicked:(id)sender
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

//
//  PreferencesWindowController.m
//  ListenBooks
//
//  Created by Libor Kučera on 12/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()
@property (weak) IBOutlet NSView *view;
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSButton *saveButton;
- (IBAction)saveButtonClicked:(id)sender;

@end

@implementation PreferencesWindowController

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
}
- (IBAction)saveButtonClicked:(id)sender
{
    if (self.completionBlock != nil) {
        self.completionBlock(YES);
    }
}
@end

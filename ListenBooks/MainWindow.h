//
//  MainWindow.h
//  ListenBooks
//
//  Created by Libor Kučera on 11/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

@interface MainWindow : NSWindow

@property (weak) IBOutlet AppDelegate *appDelegate;
- (IBAction)performClose:(id)sender;

@end

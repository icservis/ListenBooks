//
//  MainWindow.m
//  ListenBooks
//
//  Created by Libor Kučera on 11/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import "MainWindow.h"

@implementation MainWindow

- (IBAction)performClose:(id)sender
{
    DDLogVerbose(@"sender: %@", sender);
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    NSTabViewItem* selectedTabViewIntem = [appDelegate.tabBar selectedTabViewItem];
    NSInteger index = [appDelegate.tabBar indexOfTabViewItem:selectedTabViewIntem];
    
    if (index > 0) {
        [appDelegate closeTabWithItem:selectedTabViewIntem];
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    SEL theAction = [menuItem action];
    
    if (theAction == @selector(performClose:)) {
        
        AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        NSTabViewItem* selectedTabViewIntem = [appDelegate.tabBar selectedTabViewItem];
        NSInteger index = [appDelegate.tabBar indexOfTabViewItem:selectedTabViewIntem];
        
        if (index == 0) {
            return NO;
        }
    }
    
    return YES;
}

@end

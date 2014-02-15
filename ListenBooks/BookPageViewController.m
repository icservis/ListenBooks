//
//  BookPageViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 20/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "BookViewController.h"
#import "BookPageViewController.h"
#import "NSTextView+Extensions.h"

@interface BookPageViewController ()

@end

@implementation BookPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textView.textContainerInset = NSMakeSize(20.0f, 20.0f);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontSizeDidChange:) name:FontSizeDidChangeNotificaton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontNameDidChange:) name:FontNameDidChangeNotificaton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:ThemeDidChangeNotificaton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceNameDidChange:) name:VoiceNameDidChangeNotificaton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceSpeedDidChange:) name:VoiceSpeedDidChangeNotificaton object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications Implementation

- (void)fontSizeDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"object: %@", notification.object);
    
    static double lastFontSizeChange = 0;
    double requiredFontSizeChange = [notification.object doubleValue];
    
    if (requiredFontSizeChange != lastFontSizeChange) {
        double delta = requiredFontSizeChange - lastFontSizeChange;
        [self.textView changeFontSize:delta];
        lastFontSizeChange = requiredFontSizeChange;
    }
}

- (void)fontNameDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"object: %@", notification.object);
}

- (void)themeDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"object: %@", notification.object);
}

- (void)voiceNameDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"object: %@", notification.object);
}

- (void)voiceSpeedDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"object: %@", notification.object);
}

@end

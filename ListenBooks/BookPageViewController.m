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
#import "FontControl.h"
#import "ThemeControl.h"

@interface BookPageViewController ()  <NSTextViewDelegate>

@property (strong, nonatomic) FontControl* fontControl;
@property (strong, nonatomic) ThemeControl *themeControl;

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
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (FontControl*)fontControl
{
    if (_fontControl == nil) {
        _fontControl = [[FontControl alloc] init];
    }
    return _fontControl;
}

- (ThemeControl*)themeControl
{
    if (_themeControl == nil) {
        _themeControl = [[ThemeControl alloc] init];
    }
    return _themeControl;
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
    NSMenuItem* selectedItem = [notification.object selectedItem];
    NSString* fontName = [selectedItem title];
    [self.textView setFontFamily:fontName];
}

- (void)themeDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"object: %@", notification.object);
    NSInteger themeIndex = [notification.object selectedSegment];
    NSDictionary* selectedTheme = [[self.themeControl arrangedObjects] objectAtIndex:themeIndex];
    DDLogVerbose(@"selectedTheme: %@", selectedTheme);
    [self.textView setBackgroundColor:[selectedTheme valueForKey:@"BackgroundColor"]];
    [self.textView setForegroundColor:[selectedTheme valueForKey:@"ForegroundColor"]];
}


#pragma mark - NSTextViewDelegate

- (void)textViewDidChangeSelection:(NSNotification *)notification
{
    if (self.delegate != nil) {
        NSArray* selectionRanges = self.textView.selectedRanges;
        NSValue* rangeObject = [selectionRanges firstObject];
        [self.delegate bookPageController:self textViewSelectionDidChange:[rangeObject rangeValue]];
    }
}

@end

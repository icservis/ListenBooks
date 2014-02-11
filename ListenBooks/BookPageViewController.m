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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textSizeDidChange:) name:TextSizeDidChangeNotificaton object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)textSizeDidChange:(NSNotification*)notification
{
    static double lastFontSizeChange = 0;
    double requiredFontSizeChange = [notification.object doubleValue];
    
    if (requiredFontSizeChange != lastFontSizeChange) {
        double delta = requiredFontSizeChange - lastFontSizeChange;
        [self.textView changeFontSize:delta];
        lastFontSizeChange = requiredFontSizeChange;
    }
}

@end

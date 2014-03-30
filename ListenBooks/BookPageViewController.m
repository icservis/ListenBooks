//
//  BookPageViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 20/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "BookViewController.h"
#import "BookPageViewController.h"
#import "NSTextView+Extensions.h"
#import "CustomDelegateScrollView.h"
#import "FontControl.h"
#import "ThemeControl.h"
#import "Book.h"
#import "Page.h"

static CGFloat const kTextContainerMargin = 20.0f;

@interface BookPageViewController ()  <NSTextViewDelegate, CustomDelegateScrollViewDelegate>

@property (strong, nonatomic) FontControl* fontControl;
@property (strong, nonatomic) ThemeControl *themeControl;

@end

@implementation BookPageViewController {
    NSTimer* refreshPageAttributesTimer;
}

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
    self.textView.textContainerInset = NSMakeSize(kTextContainerMargin, kTextContainerMargin);
    self.scrollView.delegate = self;
    
    AppDelegate* appDelegate = [self appDelegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:appDelegate.managedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontSizeDidChange:) name:FontSizeDidChangeNotificaton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontNameDidChange:) name:FontNameDidChangeNotificaton object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:ThemeDidChangeNotificaton object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (AppDelegate*)appDelegate
{
    return (AppDelegate*)[[NSApplication sharedApplication] delegate];
}

#pragma mark - Getters And Setters

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

- (void)contextDidChange:(NSNotification*)notification
{
    NSSet *updatedObjects = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
    NSSet *deletedObjects = [[notification userInfo] objectForKey:NSDeletedObjectsKey];
    NSSet *insertedObjects = [[notification userInfo] objectForKey:NSInsertedObjectsKey];
    
    __block BOOL bookFound = NO;
    
    [[updatedObjects allObjects] enumerateObjectsUsingBlock:^(NSManagedObject* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[Book class]]) {
            bookFound = YES;
            *stop = YES;
        }
    }];
    
    [[deletedObjects allObjects] enumerateObjectsUsingBlock:^(NSManagedObject* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[Book class]]) {
            bookFound = YES;
            *stop = YES;
        }
    }];
    
    [[insertedObjects allObjects] enumerateObjectsUsingBlock:^(NSManagedObject* obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[Book class]]) {
            bookFound = YES;
            *stop = YES;
        }
    }];
    
    if (bookFound) {
        [self checkRefreshPageAttributes];
    }
}

- (void)checkRefreshPageAttributes
{
    [refreshPageAttributesTimer invalidate];
    refreshPageAttributesTimer = nil;
    refreshPageAttributesTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshPageAttritutes) userInfo:nil repeats:NO];
}

- (void)refreshPageAttritutes
{
    DDLogVerbose(@"refreshBookmarksTable: %@", refreshPageAttributesTimer);
    [self setPageAttributes];
}

- (void)fontSizeDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"object: %@", notification.object);
    //[self setPageAttributes];
}

- (void)fontNameDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"object: %@", notification.object);
    //[self setPageAttributes];
}

- (void)themeDidChange:(NSNotification*)notification
{
    DDLogVerbose(@"object: %@", notification.object);
    //[self setPageAttributes];
}

- (void)setPageAttributes
{
    BookViewController* bookViewController = (BookViewController*)self.delegate;
    Book* book = bookViewController.book;
    Page* page = [book.pages objectAtIndex:self.index];
    self.representedObject = page.data;
    
    [self.textView changeFontSize:[book.fontSizeDelta doubleValue]];
    [self.textView setFontFamily:book.fontName];
    NSDictionary* selectedTheme = [[self.themeControl arrangedObjects] objectAtIndex:[book.themeIndex integerValue]];
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

#pragma mark - CustomDelegateScrollViewDelegate

- (void)customDelegateScrollView:(CustomDelegateScrollView *)scrollView didChangeMagnitication:(CGFloat)magnication
{
    if (self.delegate != nil) {
        
        BookViewController* bookViewController = (BookViewController*)self.delegate;
        Book* book = bookViewController.book;
        
        static float magnificationDelta = NSNotFound;
        if (magnificationDelta == NSNotFound) {
            magnificationDelta = [book.fontSizeDelta floatValue];
        }
        
        magnificationDelta += magnication;
        double floorMagnificationDelta = floorf(magnificationDelta);
        
        if (![book.fontSizeDelta isEqualToNumber:[NSNumber numberWithDouble:floorMagnificationDelta]]) {
            
            if (floorMagnificationDelta >= self.fontControl.sliderMinValue && floorMagnificationDelta <= self.fontControl.sliderMaxValue) {
                book.fontSizeDelta = [NSNumber numberWithDouble:floorMagnificationDelta];
                DDLogVerbose(@"book.fontSizeDelta: %@", book.fontSizeDelta);
            } else {
                magnificationDelta = [book.fontSizeDelta floatValue];
            }
        }
    }
}

- (void)customDelegateScrollViewDidChangeSmartMagnification:(CustomDelegateScrollView *)scrollView
{
    if (self.delegate != nil) {
        
        BookViewController* bookViewController = (BookViewController*)self.delegate;
        Book* book = bookViewController.book;
        
        if ([book.fontSizeDelta isEqualToNumber:@([self.fontControl sliderDefaultValue])]) {
            book.fontSizeDelta = @([self.fontControl sliderMagnifiedValue]);
        } else {
            book.fontSizeDelta = @([self.fontControl sliderDefaultValue]);
        }
    }
}

- (void)customDelegateScrollView:(CustomDelegateScrollView *)scrollView didChangeRotation:(CGFloat)rotation
{
    DDLogVerbose(@"rotation: %f", rotation);
}

@end

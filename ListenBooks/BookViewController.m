//
//  BookViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "AppDelegate.h"
#import "BookViewController.h"
#import "BookPageViewController.h"
#import "TabBarControllerProtocol.h"
#import "NSTextView+Extensions.h"
#import "Book.h"
#import "Bookmark.h"
#import "Page.h"
#import "ProgressWindowController.h"

@interface BookViewController ()

@property (strong) id initialSelectedObject;

@property (weak) IBOutlet NSView *toolBarView;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSView *pageView;
@property (strong) IBOutlet NSPageController *pageController;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSSlider *textSizeSlider;

@end

@implementation BookViewController

@synthesize book = _book;

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
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:appDelegate.managedObjectContext];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.initialSelectedObject = nil;
}

- (void)contextDidChange:(NSNotification*)notification
{
    //AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
}

- (Book*)book
{
    return _book;
}

- (void)setBook:(Book *)book
{
    [self resetPageView];
    if (![book isEqual:_book]) {
        if ([book.pages count] > 0) {
            [self loadBookPageControllerContent:book];
        } else {
            self.titleField.stringValue = NSLocalizedString(@"Book Has No Pages!", nil);
        }
    }
    _book = book;
}

- (void)resetPageView
{
    DDLogVerbose(@"resetPageView");
    
    self.initialSelectedObject = nil;
    
    self.titleField.stringValue = NSLocalizedString(@"No Selection", nil);
    [[self.pageView subviews] enumerateObjectsUsingBlock:^(NSView* subView, NSUInteger idx, BOOL *stop) {
        if (![subView isKindOfClass:[NSProgressIndicator class]]) {
            [subView removeFromSuperview];
        }
    }];
}

- (void)loadBookPageControllerContent:(Book*)book
{
    DDLogVerbose(@"loadBookPageControllerContent: %@", book);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Finish in main queue
        self.titleField.stringValue = book.title;
        __block NSMutableArray* spinedData = [[NSMutableArray alloc] init];
        
        NSArray* pages = [[book.pages allObjects] sortedArrayUsingComparator:^NSComparisonResult(Page* obj1, Page* obj2) {
            NSInteger sortIndex1 = [obj1.sortIndex integerValue];
            NSInteger sortIndex2 = [obj2.sortIndex integerValue];
            
            if (sortIndex1 < sortIndex2) {
                return NSOrderedAscending;
            } else if (sortIndex1 > sortIndex2) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        [pages enumerateObjectsUsingBlock:^(Page* page, NSUInteger idx, BOOL *stop) {
            [spinedData addObject:page.data];
        }];
        [self.pageController setArrangedObjects:[[NSMutableArray alloc] initWithArray:spinedData]];
    });
    
}

- (IBAction)textSizeSliderChange:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TextSizeDidChangeNotificaton object:sender];
}


#pragma mark - BookPageControllerDelegate

- (NSString *)pageController:(NSPageController *)pageController identifierForObject:(id)object
{
    NSString *identifier = @"BookPage";
    return identifier;
}

- (NSViewController *)pageController:(NSPageController *)pageController viewControllerForIdentifier:(NSString *)identifier
{    
    BookPageViewController* bookPageViewController = [[BookPageViewController alloc] initWithNibName:@"BookPageViewController" bundle:nil];
    
    return bookPageViewController;
}

-(void)pageController:(NSPageController *)pageController prepareViewController:(NSViewController *)viewController withObject:(id)object
{
    // viewControllers may be reused... make sure to reset important stuff like the current magnification factor.
    
    // Since we implement this delegate method, we are reponsible for setting the representedObject.
    viewController.representedObject = object;
    
    // Normally, we want to reset the magnification value to 1 as the user swipes to other images. However if the user cancels the swipe, we want to leave the original magnificaiton and scroll position alone.
    BookPageViewController* bookPageViewController = (BookPageViewController*)viewController;
    
    BOOL isRepreparingOriginalView = (self.initialSelectedObject && self.initialSelectedObject == object) ? YES : NO;
    if (!isRepreparingOriginalView) {
        NSScrollView* scrollView = (NSScrollView*)bookPageViewController.view;
        scrollView.magnification = 1;
        [bookPageViewController.textView changeFontSize:[self.textSizeSlider doubleValue]];
    }
}

- (void)pageControllerWillStartLiveTransition:(NSPageController *)pageController
{
    // Remember the initial selected object so we can determine when a cancel occurred.
    self.initialSelectedObject = [pageController.arrangedObjects objectAtIndex:pageController.selectedIndex];
}

- (void)pageControllerDidEndLiveTransition:(NSPageController *)pageController {
    [pageController completeTransition];
}

@end

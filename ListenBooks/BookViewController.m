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
#import "Page.h"
#import "ProgressWindowController.h"

@interface BookViewController ()

@property (strong) id initialSelectedObject;
@property (nonatomic, strong) NSURL *libraryURL;
@property (nonatomic, strong) KFEpubController *epubController;
@property (nonatomic, strong) KFEpubContentModel *contentModel;

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
    self.libraryURL = nil;
    self.contentModel = nil;
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
    self.processing = NO;
    if (![book isEqual:_book]) {
        DDLogVerbose(@"self.book: %@", book);
        
        if ([book.pages count] > 0) {
            [self loadBookPageControllerContent:book];
        } else {
            [self setupBookPageControllerContent:book.fileUrl];
        }
    }
    _book = book;
}

- (void)resetPageView
{
    DDLogVerbose(@"resetPageView");
    
    self.initialSelectedObject = nil;
    self.libraryURL = nil;
    self.contentModel = nil;
    
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

- (void)setupBookPageControllerContent:(NSURL*)epubURL
{
    DDLogVerbose(@"setupBookPageControllerContent");
    
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    self.libraryURL = [appDelegate applicationCacheDirectory];
    self.epubController = [[KFEpubController alloc] initWithEpubURL:epubURL andDestinationFolder:self.libraryURL];
    self.epubController.delegate = self;
    [self.epubController openAsynchronous:YES];
}

- (IBAction)textSizeSliderChange:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TextSizeDidChangeNotificaton object:sender];
}

#pragma mark - KFEpubDelegate

- (void)epubController:(KFEpubController *)controller willOpenEpub:(NSURL *)epubURL
{
    DDLogVerbose(@"epubURL: %@", [epubURL absoluteString]);
    self.processing = YES;
    self.titleField.stringValue = NSLocalizedString(@"Opening Book…", nil);
}


- (void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel
{
    
    DDLogVerbose(@"meta %@", contentModel.metaData);
    
    [self.progressIndicator startAnimation:nil];
    self.titleField.stringValue = [contentModel.metaData valueForKey:@"title"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Do a taks in the background
        
        __block NSMutableArray* spinedData = [[NSMutableArray alloc] init];
        [contentModel.spine enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSString* media = contentModel.manifest[contentModel.spine[idx]][@"media"];
            
            if ([media isEqualToString:@"application/xhtml+xml"]) {

                NSString *contentFile = contentModel.manifest[contentModel.spine[idx]][@"href"];
                NSURL *contentURL = [controller.epubContentBaseURL URLByAppendingPathComponent:contentFile];
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithURL:contentURL documentAttributes:nil];
                
                if (attributedString != nil) {
                    
                    [spinedData addObject:attributedString];
                    
                    Page *page = [NSEntityDescription insertNewObjectForEntityForName:@"Page" inManagedObjectContext:self.managedObjectContext];
                    page.book = self.book;
                    page.sortIndex = [NSNumber numberWithInteger:idx];
                    page.data = attributedString;
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
            [appDelegate saveAction:nil];
            
            if ([spinedData count] > 0) {
                self.contentModel = contentModel;
                [self.pageController setArrangedObjects:[[NSMutableArray alloc] initWithArray:spinedData]];
            } else {
                [self resetPageView];
            }
            
            [self.progressIndicator stopAnimation:nil];
            self.processing = NO;
            [self checkProcessingStatusOfAllControllers];
        });
    });
}


- (void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error
{
    DDLogError(@"epubController:didFailWithError: %@", error.description);
    [self resetPageView];
    
    [self.progressIndicator stopAnimation:nil];
    self.processing = NO;
    [self checkProcessingStatusOfAllControllers];
}

- (void)checkProcessingStatusOfAllControllers
{
    DDLogVerbose(@"checkProcessingStatusOfAllControllers");
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    __block BOOL progress = NO;
    [appDelegate.tabViewControllers enumerateObjectsUsingBlock:^(id <TabBarControllerProtocol>controller, NSUInteger idx, BOOL *stop) {
        if ([controller isKindOfClass:[self class]]) {
            BookViewController* bookViewController = (BookViewController*)controller;
            if (bookViewController.processing == YES) {
                progress = YES;
                *stop = YES;
            }
        }
    }];
    if (progress == NO) {
        DDLogVerbose(@"progressWindow stop");
        [appDelegate.progressWindowController updateProgressWindowWithInfo:NSLocalizedString(@"Opening Book(s) Completed", nil)];
        [appDelegate.progressWindowController closeProgressWindow];
    } else {
        [appDelegate.progressWindowController updateProgressWindowWithInfo:self.book.title];
    }
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

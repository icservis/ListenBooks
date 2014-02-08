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
#import "NSTextView+Extensions.h"

@interface BookViewController ()

@property (strong) NSMutableArray *data;
@property (assign) id initialSelectedObject;

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

- (void)contextDidChange:(NSNotification*)notification
{
    AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    DDLogVerbose(@"booksArrayController: %@", appDelegate.listArrayController);
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

- (Book*)book
{
    return _book;
}

- (void)setBook:(Book *)book
{
    if (book == nil) {
        [self resetPageView];
    } else if (![book isEqual:_book]) {
        [self resetPageView];
        [self setupBookPageControllerContent:book.fileUrl];
    }
    _book = book;
    
}

- (void)resetPageView
{
    DDLogVerbose(@"resetPageView");
    self.data = nil;
    self.initialSelectedObject = nil;
    self.titleField.stringValue = NSLocalizedString(@"No Selection", nil);
    [[self.pageView subviews] enumerateObjectsUsingBlock:^(NSView* subView, NSUInteger idx, BOOL *stop) {
        if (![subView isKindOfClass:[NSProgressIndicator class]]) {
            [subView removeFromSuperview];
        }
    }];
}

- (IBAction)textSizeSliderChange:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TextSizeDidChangeNotificaton object:sender];
}

#pragma mark - KFEpubDelegate

- (void)epubController:(KFEpubController *)controller willOpenEpub:(NSURL *)epubURL
{
    self.titleField.stringValue = NSLocalizedString(@"Opening Book…", nil);
    [self.progressIndicator startAnimation:nil];
}


- (void)epubController:(KFEpubController *)controller didOpenEpub:(KFEpubContentModel *)contentModel
{
    
    //DDLogVerbose(@"meta %@", contentModel.metaData);
    //DDLogVerbose(@"spine %@", [contentModel.spine description]);
    //DDLogVerbose(@"guide %@", [contentModel.guide description]);
    
    self.titleField.stringValue = [contentModel.metaData valueForKey:@"title"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Do a taks in the background
        
        __block NSMutableArray* spinedData = [[NSMutableArray alloc] init];
        [contentModel.spine enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([contentModel.spine[idx] isKindOfClass:[NSNull class]] || [contentModel.manifest[contentModel.spine[idx]] isKindOfClass:[NSNull class]]) {
                *stop = YES;
                spinedData = nil;
            }
            
            NSString* media = contentModel.manifest[contentModel.spine[idx]][@"media"];
            
            if ([media isEqualToString:@"application/xhtml+xml"]) {

                NSString *contentFile = contentModel.manifest[contentModel.spine[idx]][@"href"];
                NSURL *contentURL = [controller.epubContentBaseURL URLByAppendingPathComponent:contentFile];
                NSAttributedString *attributedString = [[NSAttributedString alloc] initWithURL:contentURL documentAttributes:nil];
                if (attributedString != nil) {
                    [spinedData addObject:attributedString];
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Finish in main queue
            [self.progressIndicator stopAnimation:nil];
            
            if ([spinedData count] > 0) {
                self.contentModel = contentModel;
                self.data = [[NSMutableArray alloc] initWithArray:spinedData];
                [self.pageController setArrangedObjects:self.data];
            } else {
                self.contentModel = nil;
                self.data = nil;
                [self resetPageView];
            }
        });
    });
}


- (void)epubController:(KFEpubController *)controller didFailWithError:(NSError *)error
{
    DDLogError(@"epubController:didFailWithError: %@", error.description);
    [self.progressIndicator stopAnimation:nil];
    [self resetPageView];
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

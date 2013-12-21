//
//  BookViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 18.12.13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "BookViewController.h"
#import "BookPageViewController.h"

@interface BookViewController ()

@property (strong) NSMutableArray *data;
@property (assign) id initialSelectedObject;

@end

@implementation BookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        NSLog(@"initWithNibName");
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"awakeFromNib");
    [self setupBookPageControllerContent];
    
}

- (void)setupImagePageControllerContent
{
    NSURL *dirURL = [[NSBundle mainBundle] resourceURL];
    
    // load all the necessary image files by enumerating through the bundle's Resources folder,
    // this will only load images of type "kUTTypeImage"
    //
    self.data = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSDirectoryEnumerator *itr = [[NSFileManager defaultManager] enumeratorAtURL:dirURL includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLLocalizedNameKey, NSURLEffectiveIconKey, NSURLIsDirectoryKey, NSURLTypeIdentifierKey, nil] options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsSubdirectoryDescendants errorHandler:nil];
    
    for (NSURL *url in itr) {
        NSString *utiValue;
        [url getResourceValue:&utiValue forKey:NSURLTypeIdentifierKey error:nil];
        
        if (UTTypeConformsTo((__bridge CFStringRef)(utiValue), kUTTypeImage)) {
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:url];
            [self.data addObject:image];
        }
    }
    
    // set the first image in our list to the main magnifying view
    if ([self.data count] > 0) {
        NSLog(@"data: %@", [self.data description]);
        [self.pageController setArrangedObjects:self.data];
    }
}

- (void)setupBookPageControllerContent
{
    NSLog(@"setupBookPageControllerContent: %@", [self.pageController description]);
    
    
    NSAttributedString* string1 = [[NSAttributedString alloc] initWithString:@"Než jsem odlétal do USA, tak jsem panu předsedovi Sobotkovi řekl, že některá ministerstva jsou pro nás prioritní, některá velmi důležitá a některá jsou pro nás až na konci seznamu."];
    NSAttributedString* string2 = [[NSAttributedString alloc] initWithString:@"V tom prvním návrhu bylo jedno, které ministerstvo bylo na konci seznamu a které nebylo prioritní. Když vám dám jeden návrh, který je absolutně neakceptovatelný, tak je jasné, že jsme ho nemohli přijmout. Takže kdyby si pan předseda Sobotka tuto hru odpustil, tak jsme měli pouze druhý návrh."];
    NSAttributedString* string3 = [[NSAttributedString alloc] initWithString:@"Panu předsedovi Sobotkovi jsem řekl, že pro nás je prioritou ministerstvo zemědělství. Potom jedno ze třech ministerstev jako je místní rozvoj, průmysl a obchod, doprava. Vysokou prioritu pro nás má také ministerstvo školství a ministerstvo práce a sociálních věcí, popřípadě kultura. Ta ale byla na posledním místě."];
    NSAttributedString* string4 = [[NSAttributedString alloc] initWithString:@"První nabídka ale zněla na kulturu a zdravotnictví, to bylo naprosto nepřijatelné. Druhá nabídka zněla, že hnutí ANO bylo ochotno se vzdát ministerstva dopravy výměnou za to, že nebudeme požadovat ministerstvo zemědělství."];
    NSAttributedString* string5 = [[NSAttributedString alloc] initWithString:@"Já ale musím odmítnout to, že pan předseda Sobotka dává návrhy jen nám, protože součástí návrhu musí být i ANO. Nebo to dostalo posty v prvním kole a už se s nimi nesmí hýbat? Já myslím, že ten návrh nemůže být pouze pro nás, ale pro všechny tři. Ale tady je to jako by bylo ANO uspokojeno a už se s tím nemůže hýbat, zatímco s námi se hýbat může."];

    
    self.data = [[NSMutableArray alloc] initWithObjects:string1, string2, string3, string4, string5, nil];
    
    if ([self.data count] > 0) {
        [self.pageController setArrangedObjects:self.data];
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
    
    // Normally, we want to reset the magnification value to 1 as the user swipes to other images. However if the user cancels the swipe, we want to leave the original magnificaiton and scroll position alone.
    BookPageViewController* bookPageViewController = (BookPageViewController*)viewController;
    NSLog(@"frame: %@", NSStringFromRect(viewController.view.frame));
    
    BOOL isRepreparingOriginalView = (self.initialSelectedObject && self.initialSelectedObject == object) ? YES : NO;
    if (!isRepreparingOriginalView) {
        NSScrollView* scrollView = (NSScrollView*)bookPageViewController.view;
        scrollView.magnification = 1;
    }
    
    // Since we implement this delegate method, we are reponsible for setting the representedObject.
    viewController.representedObject = object;
}

- (void)pageControllerWillStartLiveTransition:(NSPageController *)pageController
{
    // Remember the initial selected object so we can determine when a cancel occurred.
    self.initialSelectedObject = [pageController.arrangedObjects objectAtIndex:pageController.selectedIndex];
}

- (void)pageControllerDidEndLiveTransition:(NSPageController *)pageController {
    [pageController completeTransition];
}


/*
- (NSString *)pageController:(NSPageController *)pageController identifierForObject:(id)object {
    return @"picture";
}

- (NSViewController *)pageController:(NSPageController *)pageController viewControllerForIdentifier:(NSString *)identifier {
    NSLog(@"viewControllerForIdentifier: %@", identifier);
    return [[NSViewController alloc] initWithNibName:@"imageview" bundle:nil];
}

-(void)pageController:(NSPageController *)pageController prepareViewController:(NSViewController *)viewController withObject:(id)object {
    // viewControllers may be reused... make sure to reset important stuff like the current magnification factor.
    
    // Normally, we want to reset the magnification value to 1 as the user swipes to other images. However if the user cancels the swipe, we want to leave the original magnificaiton and scroll position alone.
    
    BOOL isRepreparingOriginalView = (self.initialSelectedObject && self.initialSelectedObject == object) ? YES : NO;
    if (!isRepreparingOriginalView) {
        [(NSScrollView*)viewController.view setMagnification:1.0];
    }
    
    // Since we implement this delegate method, we are reponsible for setting the representedObject.
    viewController.representedObject = object;
}

- (void)pageControllerWillStartLiveTransition:(NSPageController *)pageController {
    // Remember the initial selected object so we can determine when a cancel occurred.
    self.initialSelectedObject = [pageController.arrangedObjects objectAtIndex:pageController.selectedIndex];
}

- (void)pageControllerDidEndLiveTransition:(NSPageController *)pageController {
    [pageController completeTransition];
}
*/
@end

//
//  ListCollectionViewController.m
//  ListenBooks
//
//  Created by Libor Kučera on 27/12/13.
//  Copyright (c) 2013 IC Servis. All rights reserved.
//

#import "ListCollectionViewItem.h"

@interface ListCollectionViewItem ()

@end

@implementation ListCollectionViewItem

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction)copy:(id)sender
{
    DDLogVerbose(@"copy");
}



@end

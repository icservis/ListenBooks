//
//  TabBarControllerProtocol.h
//  ListenBooks
//
//  Created by Libor Kučera on 10/02/14.
//  Copyright (c) 2014 IC Servis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TabBarControllerProtocol <NSObject>

@property (nonatomic, strong) NSTabViewItem* tabViewItem;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@end

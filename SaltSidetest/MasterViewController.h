//
//  MasterViewController.h
//  SaltSidetest
//
//  Created by Sajjeel Khilji on 10/16/15.
//  Copyright (c) 2015 Saltside. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TLIndexPathTools/TLTableViewController.h>

@class DetailViewController;

@interface MasterViewController : TLTableViewController


@property (strong, nonatomic) DetailViewController *detailViewController;


@end


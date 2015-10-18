//
//  ImageCache.h
//  SaltSidetest
//
//  Created by Sajjeel Khilji on 10/17/15.
//  Copyright (c) 2015 Saltside. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDisplayCell.h"
#import <Foundation/Foundation.h>

@interface ImageCache : NSObject

+(instancetype)sharedInstance;
-(void)loadImageForCell:(UIImageView*)iconImageView fromDict:(NSDictionary*)inputDict;

@end

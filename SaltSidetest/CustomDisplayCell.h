//
//  CustomDisplayCell.h
//  SaltSidetest
//
//  Created by Sajjeel Khilji on 10/16/15.
//  Copyright (c) 2015 Saltside. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Constants.h"
//#import <TLIndexPathTools/TLDynamicSizeView.h>


@interface CustomDisplayCell : UITableViewCell<UITableViewDelegate>

@property (nonatomic,weak)IBOutlet UIImageView *iconImageView;
-(void)setValues:(NSDictionary*)valuesDict;
@end

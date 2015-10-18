//
//  CustomDisplayCell.m
//  trafficmonitor
//
//  Created by Sajjeel Hussain on 9/23/13.
//  Copyright (c) 2013 Muzammil Mahmood. All rights reserved.
//

#import "CustomDisplayCell.h"
#import "Constants.h"
#import "ImageCache.h"




@interface CustomDisplayCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblDetailsText;
@property (nonatomic,weak)IBOutlet UILabel *lblHeaderText;
@property (nonatomic,weak)IBOutlet UIView *customContentView;
@property(nonatomic,copy)dispatch_block_t cacheImageBlock;

@property (nonatomic) CGSize originalSize;
@property (nonatomic) CGSize originalLabelSize;

@end


@implementation CustomDisplayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        [[self contentView] addSubview:self.customContentView];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutIfNeeded];
    
    //set resizing mask to work without Auto Layout
    self.lblHeaderText.autoresizingMask = 0;
    
    self.originalSize = self.bounds.size;
    self.originalLabelSize = self.lblHeaderText.bounds.size;
}


-(void)setValues:(NSDictionary*)valuesDict
{
    
    NSString *title = [valuesDict valueForKey:@"title"];
    NSString *details = [valuesDict valueForKey:@"description"];
    self.lblHeaderText.text = title;
    self.lblDetailsText.text = details;

    
    [[ImageCache sharedInstance] loadImageForCell:self.iconImageView fromDict:valuesDict];
//    self.lblHeaderText.frame = CGRectMake(self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 8, self.lblHeaderText.frame.origin.y, self.lblHeaderText.frame.size.width + self.iconImageView.frame.size.width, self.lblHeaderText.frame.size.height) ;
    
    
//    CGRect frame = self.lblHeaderText.frame;
//    frame.size = self.originalLabelSize;
//    self.lblHeaderText.frame = frame;
//    self.lblHeaderText.text = title;
//    [self.lblHeaderText sizeToFit];
//    
//    
//    frame = self.lblDetailsText.frame;
//    frame.size = self.originalLabelSize;
//    self.lblDetailsText.frame = frame;
//    self.lblDetailsText.text = details;
//    [self.lblDetailsText sizeToFit];
    
}


//#pragma mark - TLDynamicSizeView
//
//- (CGSize)sizeWithData:(id)data
//{
//    [self setValues:data];
//    //the dynamic size is calculated by taking the original size and incrementing
//    //by the change in the label's size after configuring. Here, we're using the
//    //intrinsic size because this project uses Auto Layout and the label's size
//    //after calling `sizeToFit` does not match the intrinsic size. I don't completely
//    //understand why this is yet, but using the intrinsic size works just fine.
//    CGSize labelSize = self.lblHeaderText.intrinsicContentSize;
//    CGSize size = self.originalSize;
//    size.width += labelSize.width - self.originalLabelSize.width;
//    size.height += labelSize.height - self.originalLabelSize.height;
//    return size;
//}



@end

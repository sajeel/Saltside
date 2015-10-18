//
//  ImageCache.m
//  SaltSidetest
//
//  Created by Sajjeel Khilji on 10/17/15.
//  Copyright (c) 2015 Saltside. All rights reserved.
//

#import "ImageCache.h"
#import "UIImageView+AFNetworking.h"



static ImageCache *imageCache;

@interface ImageCache()
@property (nonatomic, strong) NSMutableDictionary *images;
@property (nonatomic, strong) NSDictionary *inputDict;


@end

@implementation ImageCache

+(instancetype)sharedInstance{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            
            imageCache = [ImageCache new];
        });
    return imageCache;
}


-(void)loadImageForCell:(UIImageView*)iconImageView fromDict:(NSDictionary*)inputDict{
    
    self.inputDict = inputDict;
    NSString *title = [inputDict valueForKey:@"title"];
    NSURL *url = [NSURL URLWithString:[inputDict valueForKey:@"image"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    typeof (self) __weak weakSelf = self;
    __weak UIImageView *weakIconImageView = iconImageView;

    
    UIImage *image = [self.images objectForKey:title];
    if(image){
        NSLog(@"getting image form cache ");
        [iconImageView setImage:image];
    }
    else{
        NSLog(@"Downloading image for the ");
        [iconImageView setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           typeof (weakSelf) __strong strongSelf = weakSelf ;
                                           if(strongSelf == nil)
                                           {
                                               return ;
                                           }
                                           [strongSelf.images setObject:image forKey:[strongSelf.inputDict valueForKey:@"title"]];
                                            
                                           weakIconImageView.image = image;
                                           [weakIconImageView setNeedsLayout];
                                           
                                       } failure:nil];
    }
    

}




@end

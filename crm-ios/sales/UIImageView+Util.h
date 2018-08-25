//
//  UIImageView+Util.h
//  sales
//
//  Created by user on 2016/11/9.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Util)

- (void)loadPortrait:(NSString *)portraitURL;
- (void)loadPortrait:(NSString *)portraitURL completed:(void (^)(UIImage *image))completed;
- (NSString *)rongPortrait:(NSString *)avatar;

@end

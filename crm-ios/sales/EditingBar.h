//
//  EditingBar.h
//  sales
//
//  Created by user on 2016/11/22.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowingTextView.h"

@interface EditingBar : UIToolbar

@property (nonatomic, copy) void (^sendContent)(NSString *content);

@property (nonatomic, strong) GrowingTextView *editView;

- (instancetype)initWithShowSwitch:(BOOL)showSwitch showPhoto:(BOOL)showPhoto;

@end

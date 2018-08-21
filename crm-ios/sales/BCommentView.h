//
//  BCommentView.h
//  sales
//
//  Created by user on 2016/11/18.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BCommentView : UIView
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) MLLinkLabel *label;
- (void)setBComment:(Comment *)comment;
@end

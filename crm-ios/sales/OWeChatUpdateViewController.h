//
//  OWeChatUpdateViewController.h
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OWeChatUpdateDelegate <NSObject>

-(void) wechatUpdate:(NSString *)wechat;

@end

@interface OWeChatUpdateViewController : UIViewController

@property (nonatomic,strong) NSString *model;

@property (nonatomic,assign) id <OWeChatUpdateDelegate> delegate;

@end

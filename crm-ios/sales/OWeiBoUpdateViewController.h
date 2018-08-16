//
//  OWeiBoUpdateViewController.h
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OWeiBoUpdateDelegate <NSObject>

-(void) weiboUpdate:(NSString *)weibo;

@end

@interface OWeiBoUpdateViewController : UIViewController

@property (nonatomic,strong) NSString *model;

@property (nonatomic,assign) id <OWeiBoUpdateDelegate> delegate;

@end

//
//  ODescUpdateViewController.h
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ODescUpdateDelegate <NSObject>

-(void) descUpdate:(NSString *)desc;

@end
@interface ODescUpdateViewController : UIViewController

@property (nonatomic,strong) NSString *model;
@property (nonatomic,assign) id <ODescUpdateDelegate> delegate;

@end

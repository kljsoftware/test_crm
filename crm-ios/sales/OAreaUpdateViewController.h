//
//  OAreaUpdateViewController.h
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OAreaUpdateDelegate <NSObject>

-(void) areaUpdate:(NSString *)area;

@end

@interface OAreaUpdateViewController : UIViewController

@property (nonatomic,strong) NSString *model;

@property (nonatomic,assign) id <OAreaUpdateDelegate> delegate;

@end

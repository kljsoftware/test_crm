//
//  CustomerEditViewController.h
//  sales
//
//  Created by user on 2017/2/16.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"

@protocol CustomerEditDelegate <NSObject>

-(void) customerEdit:(Customer *)customer;

@end

@interface CustomerEditViewController : UIViewController

@property (nonatomic,strong) Customer *customer;

@property (nonatomic,assign) id <CustomerEditDelegate> delegate;

@end

//
//  ONameUpdateViewController.h
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ONameUpdateDelegate <NSObject>

-(void) nameUpdate:(NSString *)name;

@end

@interface ONameUpdateViewController : UIViewController

@property (nonatomic,strong) NSString *model;

@property (nonatomic,assign) id <ONameUpdateDelegate> delegate;

@end

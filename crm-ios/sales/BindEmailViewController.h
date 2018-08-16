//
//  BindEmailViewController.h
//  sales
//
//  Created by user on 2017/4/26.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EmailUpdateDelegate <NSObject>

-(void) emailUpdate:(NSString *)email;

@end

@interface BindEmailViewController : UIViewController

@property (nonatomic,strong) NSString *model;

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,assign) id <EmailUpdateDelegate> delegate;

@end

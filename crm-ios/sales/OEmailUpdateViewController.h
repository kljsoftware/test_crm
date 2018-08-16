//
//  OEmailUpdateViewController.h
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OEmailUpdateDelegate <NSObject>

-(void) emailUpdate:(NSString *)name;

@end

@interface OEmailUpdateViewController : UIViewController

@property (nonatomic,strong) NSString *model;

@property (nonatomic,assign) id <OEmailUpdateDelegate> delegate;

@end

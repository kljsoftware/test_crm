//
//  MeTitleUpdateViewController.h
//  sales
//
//  Created by user on 2017/4/26.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TitleUpdateDelegate <NSObject>

-(void) titleUpdate:(NSString *)title;

@end

@interface MeTitleUpdateViewController : UIViewController

@property (nonatomic,strong) NSString *model;

@property (nonatomic,assign) id <TitleUpdateDelegate> delegate;

@end

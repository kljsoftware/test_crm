//
//  OLinkedUpdateViewController.h
//  sales
//
//  Created by user on 2017/4/24.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OLinkedUpdateDelegate <NSObject>

-(void) linkedUpdate:(NSString *)name;

@end

@interface OLinkedUpdateViewController : UIViewController

@property (nonatomic,strong) NSString *model;

@property (nonatomic,assign) id <OLinkedUpdateDelegate> delegate;

@end

//
//  ReadTableViewController.h
//  sales
//
//  Created by user on 2017/1/3.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReadItemDelegate <NSObject>

-(void) itemChange:(NSInteger) index vc:(UIViewController *)viewController;

@end

@interface ReadViewController : UIViewController

@property (nonatomic,assign) id <ReadItemDelegate> delegate;

@end

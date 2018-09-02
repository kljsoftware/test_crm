//
//  SelectColleaguesTableViewController.h
//  sales
//
//  Created by user on 2017/3/2.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SelectColleaguesType) {
    SelectColleaguesAdd,
    SelectColleaguesDelete,
    SelectColleaguesCreate,
};

@interface SelectColleaguesTableViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSString *discussionId;
@property (nonatomic, assign) SelectColleaguesType type;

@end

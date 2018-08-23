//
//  ReadTableViewController.m
//  sales
//
//  Created by user on 2017/1/3.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadTopChannelContianerView.h"
#import "INoticeTableViewController.h"
#import "IBlackboardTableViewController.h"
#import "INewsTableViewController.h"
#import "IPaperTableViewController.h"
#import "IActiveTableViewController.h"
@interface ReadViewController ()<UIScrollViewDelegate,ReadTopChannelContianerViewDelegate>

@property (nonatomic, strong) NSMutableArray *currentChannelsArray;
@property (nonatomic, weak) ReadTopChannelContianerView *topContianerView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray *arrayLists;

@end

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    [self setupTopContianerView];
    [self setupChildController];
    [self setupContentScrollView];
}

- (void)setupTopContianerView{
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    ReadTopChannelContianerView *topContianerView = [[ReadTopChannelContianerView alloc] initWithFrame:CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width, 30)];
    topContianerView.channelNameArray = self.currentChannelsArray;
    self.topContianerView  = topContianerView;
    topContianerView.delegate = self;
    [self.view addSubview:topContianerView];
}

#pragma mark --private Method--初始化子控制器
-(void)setupChildController {
    INoticeTableViewController *noticeVC = [[INoticeTableViewController alloc] init];
    [self addChildViewController:noticeVC];
    
    IBlackboardTableViewController *blackboardVC = [[IBlackboardTableViewController alloc] init];
    [self addChildViewController:blackboardVC];
    
    INewsTableViewController *newsVC= [[INewsTableViewController alloc] init];
    [self addChildViewController:newsVC];
    
    IPaperTableViewController *paperVC = [[IPaperTableViewController alloc] init];
    [self addChildViewController:paperVC];
    
    IActiveTableViewController *activeVC = [[IActiveTableViewController alloc] init];
    [self addChildViewController:activeVC];
}
#pragma mark --private Method--初始化相信新闻内容的scrollView
- (void)setupContentScrollView {
    UIScrollView *contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView = contentScrollView;
    contentScrollView.frame = self.view.bounds;
    contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width* self.currentChannelsArray.count, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    [self.view insertSubview:contentScrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:contentScrollView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        if (index == 0) {
            NSLog(@"SCROLL -- 0");
            [_delegate itemChange:10 vc:self];
            INoticeTableViewController *vc = self.childViewControllers[0];
            vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
            vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame)+self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
            [scrollView addSubview:vc.view];
            for (int i = 0; i<self.contentScrollView.subviews.count; i++) {
                NSInteger currentIndex = vc.tableView.frame.origin.x/self.contentScrollView.frame.size.width;
                if ([self.contentScrollView.subviews[i] isKindOfClass:[UITableView class]]) {
                    UITableView *theTableView = self.contentScrollView.subviews[i];
                    NSInteger theIndex = theTableView.frame.origin.x/self.contentScrollView.frame.size.width;
                    NSInteger gap = theIndex - currentIndex;
                    if (gap<=2&&gap>=-2) {
                        continue;
                    } else {
                        [theTableView removeFromSuperview];
                    }
                }
                
            }
        }else if(index == 1){
            NSLog(@"SCROLL -- 1");
            [_delegate itemChange:11 vc:self];
            IBlackboardTableViewController *vc = self.childViewControllers[1];
            vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
            vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame)+self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
            [scrollView addSubview:vc.view];
            for (int i = 0; i<self.contentScrollView.subviews.count; i++) {
                NSInteger currentIndex = vc.tableView.frame.origin.x/self.contentScrollView.frame.size.width;
                if ([self.contentScrollView.subviews[i] isKindOfClass:[UITableView class]]) {
                    UITableView *theTableView = self.contentScrollView.subviews[i];
                    NSInteger theIndex = theTableView.frame.origin.x/self.contentScrollView.frame.size.width;
                    NSInteger gap = theIndex - currentIndex;
                    if (gap<=2&&gap>=-2) {
                        continue;
                    } else {
                        [theTableView removeFromSuperview];
                    }
                }
                
            }
        }else if(index == 2){
            NSLog(@"SCROLL -- 2");
            [_delegate itemChange:12 vc:self];
            INewsTableViewController *vc = self.childViewControllers[2];
            vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
            vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame)+self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
            [scrollView addSubview:vc.view];
            for (int i = 0; i<self.contentScrollView.subviews.count; i++) {
                NSInteger currentIndex = vc.tableView.frame.origin.x/self.contentScrollView.frame.size.width;
                if ([self.contentScrollView.subviews[i] isKindOfClass:[UITableView class]]) {
                    UITableView *theTableView = self.contentScrollView.subviews[i];
                    NSInteger theIndex = theTableView.frame.origin.x/self.contentScrollView.frame.size.width;
                    NSInteger gap = theIndex - currentIndex;
                    if (gap<=2&&gap>=-2) {
                        continue;
                    } else {
                        [theTableView removeFromSuperview];
                    }
                }
                
            }
        }else if(index == 3){
            NSLog(@"SCROLL -- 3");
            [_delegate itemChange:13 vc:self];
            IPaperTableViewController *vc = self.childViewControllers[3];
            vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
            vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame)+self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
            [scrollView addSubview:vc.view];
            for (int i = 0; i<self.contentScrollView.subviews.count; i++) {
                NSInteger currentIndex = vc.tableView.frame.origin.x/self.contentScrollView.frame.size.width;
                if ([self.contentScrollView.subviews[i] isKindOfClass:[UITableView class]]) {
                    UITableView *theTableView = self.contentScrollView.subviews[i];
                    NSInteger theIndex = theTableView.frame.origin.x/self.contentScrollView.frame.size.width;
                    NSInteger gap = theIndex - currentIndex;
                    if (gap<=2&&gap>=-2) {
                        continue;
                    } else {
                        [theTableView removeFromSuperview];
                    }
                }
                
            }
        }else if (index == 4){
            NSLog(@"SCROLL -- 4");
            [_delegate itemChange:14 vc:self];
            IActiveTableViewController *vc = self.childViewControllers[4];
            vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
            vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame)+self.topContianerView.scrollView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
            [scrollView addSubview:vc.view];
            for (int i = 0; i<self.contentScrollView.subviews.count; i++) {
                NSInteger currentIndex = vc.tableView.frame.origin.x/self.contentScrollView.frame.size.width;
                if ([self.contentScrollView.subviews[i] isKindOfClass:[UITableView class]]) {
                    UITableView *theTableView = self.contentScrollView.subviews[i];
                    NSInteger theIndex = theTableView.frame.origin.x/self.contentScrollView.frame.size.width;
                    NSInteger gap = theIndex - currentIndex;
                    if (gap<=2&&gap>=-2) {
                        continue;
                    } else {
                        [theTableView removeFromSuperview];
                    }
                }
                
            }
        }
        
    }
}




#pragma mark --UIScrollViewDelegate-- 滑动的减速动画结束后会调用这个方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        [self.topContianerView selectChannelButtonWithIndex:index];
    }
}

#pragma mark --UICollectionViewDataSource-- 返回每个UICollectionViewCell发Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kDeviceWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kMargin = 10;
    return CGSizeMake((kDeviceWidth - 5*kMargin)/4, 40);
}

#pragma mark --TTTopChannelContianerViewDelegate--选择了某个新闻频道，更新scrollView的contenOffset
- (void)chooseChannelWithIndex:(NSInteger)index {
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.frame.size.width * index, 0) animated:YES];
}
#pragma mark --private Method--存储更新后的currentChannelsArray到偏好设置中
-(NSMutableArray *)currentChannelsArray {
    if (!_currentChannelsArray) {
        if (!_currentChannelsArray) {
            _currentChannelsArray = [NSMutableArray arrayWithObjects:@"公告",@"黑板",@"新闻",@"文章",@"活动", nil];
        }
    }
    return _currentChannelsArray;
}
@end

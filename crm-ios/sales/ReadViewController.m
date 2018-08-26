//
//  ReadTableViewController.m
//  sales
//
//  Created by user on 2017/1/3.
//  Copyright © 2017年 rayootech. All rights reserved.
//

#import "ReadViewController.h"
#import "INoticeTableViewController.h"
#import "IBlackboardTableViewController.h"
#import "INewsTableViewController.h"
#import "IPaperTableViewController.h"
#import "IActiveTableViewController.h"
#import "CCSegmentView.h"

@interface ReadViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *currentChannelsArray;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) CCSegmentView *segmentView;
@property (nonatomic, strong) NSArray *arrayLists;

@end

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xf2f2f2];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self setupSegmentView];
    [self setupChildController];
    [self setupContentScrollView];
}

- (void)setupSegmentView {
    CCSegmentView *segmentView = [[CCSegmentView alloc] initWithTitles:self.currentChannelsArray normalColor:[UIColor colorWithHex:0x333333] selectColor:UIColor.blackColor];
    [self.view addSubview:segmentView];
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    segmentView.segmentBlock = ^(NSInteger index) {
        [self.contentScrollView setContentOffset:CGPointMake(KSCREEN_WIDTH*index, 0) animated:true];
    };
    self.segmentView = segmentView;
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
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40+2, KSCREEN_WIDTH, KSCREEN_HEIGHT-KNAV_HEIGHT-40-KMAINTAB_HEIGHT)];
    self.contentScrollView = contentScrollView;
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
        [_delegate itemChange:10+index vc:self];
        INoticeTableViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
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


#pragma mark --UIScrollViewDelegate-- 滑动的减速动画结束后会调用这个方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x/self.contentScrollView.frame.size.width;
        [self.segmentView setIndex:index];
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

- (NSArray *)currentChannelsArray {
    if (!_currentChannelsArray) {
        _currentChannelsArray = @[@"公告",@"黑板",@"新闻",@"文章",@"活动"];
    }
    return _currentChannelsArray;
}

@end

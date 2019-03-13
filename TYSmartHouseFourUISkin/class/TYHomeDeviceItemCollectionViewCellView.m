//
//  TYHomeIndexDeviceNormalCellView.m
//  TYSmartHouseDefaultUISkin
//
//  Created by 朱盼 on 2018/11/21.
//

#import "TYHomeDeviceItemCollectionViewCellView.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UIView+TYFrame.h"
#import "UIColor+TYCategory.h"
#import "UIImage+TYSmartHouseBundle.h"

#import "TYHomeDeviceQuickControlView.h"
#import "UIScreen+TYFrame.h"

static CGFloat const kTYNormalCellContainerInfoAreaHeight = 170;
static CGFloat const kTYNormalCellContainerControlAreaHeight = 40;

@interface TYHomeDeviceItemCollectionViewCellView () <TYHomeDeviceMoreControlViewDelegate>

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *statusLabel;    // 需要内间距…用button好了

@property (nonatomic, strong) UIButton *quickSwitchButton;
@property (nonatomic, strong) UIButton *moreControlButton;

@property (nonatomic, strong) UIImageView *groupTipImageView;

@property (nonatomic, strong) TYHomeDeviceQuickControlView *moreControlView;

@property (nonatomic, strong) id<TYSHDeviceNormalCellData> cellData;

@end

@implementation TYHomeDeviceItemCollectionViewCellView
@synthesize data;
@synthesize eventDelegate;

+ (UIView <TYTSIViewComponent> *)getComponentView {
    UIView<TYTSIViewComponent> *view = [[self alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

+ (CGSize)getViewSizeWithEntity:(id<TYSHDeviceNormalCellData>)entity preferSize:(CGSize)preferSize {
    // 不显示快捷 104  显示快捷 192
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, kTYNormalCellContainerControlAreaHeight);
}

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, (TY_ScreenWidth()-30)/2, kTYNormalCellContainerInfoAreaHeight + kTYNormalCellContainerControlAreaHeight + 6 * 2)]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    _containerView = [UIView new];
    _containerView.backgroundColor = [UIColor ty_colorWithStringHex:@"F8F8F8"];
    _containerView.ty_left = 0;
    _containerView.ty_top = 0;
    _containerView.ty_height = 170;
    _containerView.ty_width = (TY_ScreenWidth()-30)/2 - 0;
    _containerView.layer.cornerRadius = 6;
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _containerView.layer.shadowOpacity = 0.05;
    _containerView.layer.shadowOffset = CGSizeMake(0, 2);
    _containerView.layer.shadowRadius = 6;
    [self addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(6);
        make.left.mas_equalTo(self).offset(0);
        make.width.mas_equalTo((TY_ScreenWidth()-30)/2);
        make.bottom.mas_equalTo(self).offset(-6);
    }];
    
    _iconImageView = [UIImageView new];
    _iconImageView.ty_size = CGSizeMake(48, 48);
    _iconImageView.layer.cornerRadius = 15;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderWidth = 1;
    _iconImageView.layer.borderColor = [UIColor clearColor].CGColor;
    _iconImageView.layer.shadowColor = [UIColor clearColor].CGColor;
    _iconImageView.layer.shadowRadius = 6;
    _iconImageView.layer.shadowOpacity = 0.1;
    _iconImageView.image = [UIImage tysh_skin_imageNamed:@"ty_home_device_empty"];
    _iconImageView.ty_top = 14;
    _iconImageView.ty_centerX=_containerView.ty_width/2;
    [_containerView addSubview:_iconImageView];
    

    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor ty_colorWithHex:0x444444];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.numberOfLines = 1;
    _nameLabel.ty_width=_containerView.ty_width-20;
    _nameLabel.ty_centerX=_containerView.ty_width/2;
    [_containerView addSubview:_nameLabel];
    
    _statusLabel = [UIButton new];
    _statusLabel.userInteractionEnabled = NO;
    _statusLabel.layer.borderColor = [UIColor ty_colorWithHex:0x565768].CGColor;
    _statusLabel.layer.borderWidth = 0;
    _statusLabel.layer.cornerRadius = 3;
    [_statusLabel setTitleColor:[UIColor ty_colorWithHex:0x565768] forState:UIControlStateNormal];
    _statusLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    _statusLabel.ty_centerX = _nameLabel.ty_centerX;
    [_containerView addSubview:_statusLabel];

    _quickSwitchButton = [UIButton new];
    _quickSwitchButton.ty_size = CGSizeMake(40, 40);
    _quickSwitchButton.ty_right = _containerView.ty_width/2-20;
    _quickSwitchButton.ty_top = _statusLabel.ty_bottom+40;
    _quickSwitchButton.adjustsImageWhenHighlighted = NO;
    _quickSwitchButton.accessibilityIdentifier = @"homepage_switch";
    [_quickSwitchButton setImage:[UIImage tysh_skin_imageNamed:@"ty_home_switch_close"] forState:UIControlStateNormal];
    [_quickSwitchButton setImage:[UIImage tysh_skin_imageNamed:@"ty_home_switch_open"
                                  ] forState:UIControlStateSelected];
    [_quickSwitchButton addTarget:self action:@selector(quickSwitchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_quickSwitchButton];
    
    _moreControlButton = [UIButton new];
    _moreControlButton.accessibilityIdentifier = @"homepage_fold";
    _moreControlButton.ty_left =  _containerView.ty_width/2 +20;
     _moreControlButton.ty_top =  _statusLabel.ty_bottom+40;
    _moreControlButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_moreControlButton setTitleColor:[UIColor ty_colorWithHex:0x38c998] forState:UIControlStateNormal];
    [_moreControlButton addTarget:self action:@selector(moreControlButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_containerView addSubview:_moreControlButton];
    
//    _groupTipImageView = [UIImageView new];
//    _groupTipImageView.ty_size = CGSizeMake(12, 12);
//    _groupTipImageView.ty_left = _nameLabel.ty_right + 4;
//    _groupTipImageView.image = [UIImage tysh_skin_imageNamed:@"ty_home_group"];
//    [_containerView addSubview:_groupTipImageView];
//    [_groupTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.nameLabel.mas_right).offset(4);
//        make.size.mas_equalTo(CGSizeMake(12, 12));
//        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
//    }];

    _moreControlView = [[TYHomeDeviceQuickControlView alloc] initWithFrame:CGRectMake(0, kTYNormalCellContainerInfoAreaHeight, _containerView.ty_width, kTYNormalCellContainerControlAreaHeight)];
    [_containerView addSubview:_moreControlView];
    _moreControlView.ty_left = 0;
    _moreControlView.ty_top = 92;
    _moreControlView.delegate = self;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapAction)]];
}

- (void)refreshWithData:(__kindof id<TYSHDeviceNormalCellData>)data {
    _cellData = data;
    
    _containerView.alpha = !data.showIconMask ? 1 : 0.5;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:data.iconUrl] placeholderImage:[UIImage tysh_skin_imageNamed:@"ty_home_device_empty"]];
    
    _nameLabel.text = data.name;
    [_nameLabel sizeToFit];
    _nameLabel.ty_width = MIN(_nameLabel.ty_width, _quickSwitchButton.ty_left - _nameLabel.ty_left  - (_groupTipImageView.hidden ? 10 : _groupTipImageView.ty_width + 4));
    _nameLabel.ty_left = _iconImageView.ty_right + 16;
    
    _groupTipImageView.hidden = !data.isGroup;
    
    [_statusLabel setTitle:data.showDeviceStatus forState:UIControlStateNormal];
    [_statusLabel setTitleColor:[UIColor ty_colorWithStringHex:data.showDeviceStatusColor] forState:UIControlStateNormal];
    _statusLabel.titleLabel.font = data.showStatusLabelBorder ? [UIFont systemFontOfSize:10] : [UIFont systemFontOfSize:11];
    _statusLabel.contentEdgeInsets = data.showStatusLabelBorder ? UIEdgeInsetsMake(3, 4, 4, 3) : UIEdgeInsetsMake(CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN);
    _statusLabel.layer.borderWidth = data.showStatusLabelBorder ? 0.5 : 0;
    [_statusLabel sizeToFit];
    _statusLabel.ty_left = _nameLabel.ty_left;
    _statusLabel.ty_width = MIN(_statusLabel.ty_width, _quickSwitchButton.ty_left - 10 - _statusLabel.ty_left);
    
    _statusLabel.hidden = !data.showStatus;
    
    _quickSwitchButton.hidden = !data.isQuickToggle;
    _quickSwitchButton.selected = _cellData.isOpen;
    
    [_moreControlButton setTitle:_cellData.showQuickControlView ? NSLocalizedString(@"device_functions_on", nil): NSLocalizedString(@"device_functions_off", nil) forState:UIControlStateNormal];
    [_moreControlButton sizeToFit];
    _moreControlButton.ty_left = _nameLabel.ty_left;
    
    _moreControlButton.hidden = !_cellData.quickDatas || _cellData.quickDatas.count == 0;
    
    CGFloat h = _nameLabel.ty_height + (_statusLabel.hidden ? 0 : (5 + _statusLabel.ty_height)) + (_moreControlButton.hidden ? 0 : (5 + _moreControlButton.ty_height - 12)); // moreControlButton上下大概各有6的间距
    _nameLabel.ty_top = (92 - h)/2.0;
    _statusLabel.ty_top = _nameLabel.ty_bottom + 5;
    _moreControlButton.ty_top = (_statusLabel.hidden ? _nameLabel.ty_bottom : _statusLabel.ty_bottom) + 5 - 6;
    
    [self refreshMoreControlView];
}

- (void)refreshMoreControlView {
    if (_cellData.quickDatas.count > 0) {
        [_moreControlButton setTitle:_cellData.showQuickControlView ? NSLocalizedString(@"device_functions_on", nil): NSLocalizedString(@"device_functions_off", nil) forState:UIControlStateNormal];
        [_moreControlButton sizeToFit];
        
        _moreControlView.userInteractionEnabled = _cellData.showQuickControlView;
        [_moreControlView refreshWithData:_cellData.quickDatas];
    }
}

#pragma mark - <TYHomeDeviceMoreControlViewDelegate>
- (void)moreControlView:(TYHomeDeviceQuickControlView *)controlView didClickedItem:(id<TYSHDeviceQuickControlItemData>)item atIndex:(NSInteger)idx {
    if ([self.eventDelegate respondsToSelector:@selector(deviceCell:quickItemAction:)]) {
        [self.eventDelegate deviceCell:_cellData quickItemAction:item];
    }
}

#pragma mark - Action
- (void)moreControlButtonAction {
    _cellData.showQuickControlView = !_cellData.showQuickControlView;

    [self refreshMoreControlView];
    
    [self.eventDelegate viewComponentNeedsUpdateSize:self];
    
    if ([self.eventDelegate respondsToSelector:@selector(deviceCell:quickFoldAction:)]) {
        [self.eventDelegate deviceCell:_cellData quickFoldAction:!_cellData.showQuickControlView];
    }
}

- (void)quickSwitchButtonAction {
    _quickSwitchButton.transform = CGAffineTransformMakeScale(0.9, 0.9);
    __weak typeof(self) weakSelf = self;
    _quickSwitchButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.quickSwitchButton.transform = CGAffineTransformIdentity;
        weakSelf.quickSwitchButton.userInteractionEnabled = YES;
    } completion:nil];
    
    if ([self.eventDelegate respondsToSelector:@selector(deviceCell:quickSwitchAction:)]) {
        [self.eventDelegate deviceCell:_cellData quickSwitchAction:!_quickSwitchButton.selected];
    }
}

- (void)cellTapAction {
    if ([self.eventDelegate respondsToSelector:@selector(deviceCellTapAction:)]) {
        [self.eventDelegate deviceCellTapAction:_cellData];
    }
}

@end

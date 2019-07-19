//
//  UITableViewCell+CATStaticDataBinding.m
//  CatAccounting
//
//  Created by ran on 2017/9/29.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "UITableViewCell+CATStaticDataBinding.h"

@implementation UITableViewCell (CATStaticDataBinding)

- (void)cat_bindStaticData:(CATStaticTableCellData *)staticCellData {
    self.imageView.image = staticCellData.image;
    self.textLabel.text = staticCellData.text;
    self.detailTextLabel.text = staticCellData.detailText;
    self.accessoryType = [CATStaticTableCellData tableViewCellAccessoryTypeWithStaticAccessoryType:staticCellData.accessoryType];
    
    if (staticCellData.accessoryType == CATStaticTableViewCellAccessoryTypeSwitch) {
        UISwitch *switcher;
        BOOL switcherOn = NO;
        if ([self.accessoryView isKindOfClass:[UISwitch class]]) {
            switcher = (UISwitch *)self.accessoryView;
        } else {
            switcher = [[UISwitch alloc] init];
        }
        if ([staticCellData.accessoryValue isKindOfClass:[NSNumber class]]) {
            switcherOn = [((NSNumber *)staticCellData.accessoryValue) boolValue];
        }
        
        switcher.onTintColor = UIColorMakeWithHex(CAT_THEME_COLOR);
        switcher.tintColor = switcher.onTintColor;
        switcher.on = switcherOn;
        [switcher removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [switcher addTarget:staticCellData.accessoryTarget action:staticCellData.accessoryAction forControlEvents:UIControlEventValueChanged];
        self.accessoryView = switcher;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end

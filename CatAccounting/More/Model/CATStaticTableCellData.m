//
//  CATStaticTableCellData.m
//  CatAccounting
//
//  Created by ran on 2017/9/29.
//  Copyright © 2017年 ran. All rights reserved.
//

#import "CATStaticTableCellData.h"

@implementation CATStaticTableCellData

+ (instancetype)staticTableViewCellDataWithIdentifier:(NSString *)identifier
                                                style:(UITableViewCellStyle)style
                                               height:(CGFloat)height
                                                image:(UIImage *)image
                                                 text:(NSString *)text
                                           detailText:(NSString *)detailText
                                        accessoryType:(CATStaticTableViewCellAccessoryType)accessoryType
                                 accessoryValueObject:(id)accessoryValueObject
                                      accessoryTarget:(id)accessoryTarget
                                      accessoryAction:(SEL)accessoryAction
{
    CATStaticTableCellData *data = [[CATStaticTableCellData alloc] init];
    data.identifier = [NSString stringWithFormat:@"CATStaticTableCellIdentifier_%@", identifier];
    data.style = style;
    data.height = height;
    data.image = image;
    data.text = text;
    data.detailText = detailText;
    data.accessoryType = accessoryType;
    data.accessoryValue = accessoryValueObject;
    data.accessoryTarget = accessoryTarget;
    data.accessoryAction = accessoryAction;
    return data;
}

+ (instancetype)staticTableViewCellDataWithIdentifier:(NSString *)identifier
                                                image:(UIImage *)image
                                                 text:(NSString *)text
                                           detailText:(NSString *)detailText
                                        accessoryType:(CATStaticTableViewCellAccessoryType)accessoryType
{
    return [self staticTableViewCellDataWithIdentifier:identifier
                                                 style:detailText?UITableViewCellStyleSubtitle:UITableViewCellStyleDefault
                                                height:50
                                                 image:image
                                                  text:text
                                            detailText:detailText
                                         accessoryType:accessoryType
                                  accessoryValueObject:nil
                                       accessoryTarget:nil
                                       accessoryAction:NULL];
}

- (void)addSelectedTarget:(id)target action:(SEL)action {
    self.selectedTarget = target;
    self.selectedAction = action;
}

+ (UITableViewCellAccessoryType)tableViewCellAccessoryTypeWithStaticAccessoryType:(CATStaticTableViewCellAccessoryType)type {
    switch (type) {
        case CATStaticTableViewCellAccessoryTypeDisclosureIndicator:
            return UITableViewCellAccessoryDisclosureIndicator;
        case CATStaticTableViewCellAccessoryTypeDetailDisclosureButton:
            return UITableViewCellAccessoryDetailDisclosureButton;
        case CATStaticTableViewCellAccessoryTypeCheckmark:
            return UITableViewCellAccessoryCheckmark;
        case CATStaticTableViewCellAccessoryTypeDetailButton:
            return UITableViewCellAccessoryDetailButton;
        case CATStaticTableViewCellAccessoryTypeSwitch:
        default:
            return UITableViewCellAccessoryNone;
    }
}

@end

//
//  PZTooltipObj.h
//  Pointzi
//
//  Created by Mahipal Kummari on 23/05/19.
//  Copyright © 2019 Mahipal Kummari. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PZTooltipObj : NSObject

@property (nonatomic, strong)NSString * nameTitle;
@property (nonatomic, strong)NSString * firstName;
@property (nonatomic, strong)NSString * lastName;
@property (nonatomic, strong)NSString * profileURL;
@property (nonatomic, strong)NSString * tooltipImgURL;
@property (nonatomic, strong)NSString * tooltipMessage;

- (void) initWithJsonDict:(NSDictionary *) dict;
@end

NS_ASSUME_NONNULL_END

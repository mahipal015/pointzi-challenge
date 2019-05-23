//
//  PZToolTip.h
//  Pointzi
//
//  Created by Mahipal Kummari on 23/05/19.
//  Copyright © 2019 Mahipal Kummari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZTooltipObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface PZToolTip : NSObject
{
    PZTooltipObj * tooltipObj;
}
@property (nonatomic , retain) PZTooltipObj * tooltipObj;

+(PZToolTip *)sharedPZToolTip;
- (void)initToolTipWithCompletionHandler:(void(^)(bool))comp;
@end

NS_ASSUME_NONNULL_END

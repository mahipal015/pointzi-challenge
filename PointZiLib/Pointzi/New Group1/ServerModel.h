//
//  ServerModel.h
//  Pointzi
//
//  Created by Mahipal Kummari on 23/05/19.
//  Copyright © 2019 Mahipal Kummari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PZTooltipObj.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServerModel : NSObject
-(void)getJSONData:(NSString*)urlString andCompletionHandler:(void(^)(PZTooltipObj *))comp;
@end

NS_ASSUME_NONNULL_END

//
//  FQSearchRecordModel.h
//  Fanqie
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "RLMObject.h"

@interface FQSearchRecordModel : RLMObject
@property (nonatomic,copy)NSString*searchTitle;
@property (nonatomic,strong)NSDate*date;
@end

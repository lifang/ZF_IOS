//
//  NetworkInterface.h
//  ZFUB
//
//  Created by 徐宝桥 on 15/2/10.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkRequest.h"
#import "MBProgressHUD.h"


/*
 已完成
 1.注册
 2.登录
 3.找回密码手机验证码
 5.注册验证码
 6.获取开通申请列表
 7.进入开通申请
 12.获取对公对私材料
 15.获取终端管理终端列表
 16.指定收单通道
 17.添加终端
 18.找回POS密码
 19.视频认证
 20.同步
 21.终端详情
 22.商品搜索条件
 23.商品列表
 24.商品详细
 27.购物车列表
 29.删除购物车
 30.修改购物车数量
 32.从购物车创建订单
 33.从商品购买创建订单
 34.从商品租赁创建订单
 35.获取终端列表
 36.查询交易流水
 37.交易流水详情
 38.统计交易流水
 39.获取用户信息
 40.修改用户信息
 41.修改用户密码
 42.我的积分列表
 43.我的积分总计
 44.兑换积分
 45.地址列表
 46.新增地址
 47.删除地址
 48.我的商户列表
 49.我的商户详情
 55.我的消息列表
 56.我的消息详情
 57.我的消息单个删除
 58.我的消息批量删除
 59.我的消息批量已读
 60.我的订单列表
 61.我的订单详情
 62.取消订单
 63.订单评论
 64.维修记录列表 
 65.维修记录取消订单
 66.维修记录详情
 67.维修记录物流
 68.退货记录列表
 69.退货记录取消订单
 70.退货记录详情
 71.退货记录物流
 72.注销记录列表 
 73.注销记录取消申请
 74.重新提交注销记录
 75.注销记录详情
 76.换货记录列表 
 77.换货记录详情
 78.换货记录取消申请
 79.换货记录物流
 80.更新资料记录列表
 81.更新资料记录详情
 82.更新资料取消申请
 83.租赁退还记录列表
 84.租赁退还记录详情
 85.租赁退货取消申请
 86.租赁退还记录物流
 */

@class MerchantDetailModel;

typedef enum {
    RequestTokenOverdue = -3,   //token失效
    RequestShortInventory = -2, //库存不足
    RequestFail = -1,           //请求错误
    RequestSuccess = 1,         //请求成功
}RequestCode;

typedef enum {
    OrderFilterNone = -1,
    OrderFilterDefault,       //商品默认排序
    OrderFilterSales,         //销量排序
    OrderFilterPriceDown,     //价格降序
    OrderFilterPriceUp,       //价格升序
    OrderFilterScore,         //评分排序
}OrderFilter;

typedef enum {
    TradeTypeNone = -1,
    TradeTypeConsume = 1,     //消费
    TradeTypeTransfer,        //转账
    TradeTypeRepayment,       //还款
    TradeTypeTelephoneFare,   //话费充值
    TradeTypeLife,            //生活充值
}TradeType;

typedef enum {
    CSTypeNone = 0,
    CSTypeRepair,      //维修记录
    CSTypeReturn,      //退货记录
    CSTypeCancel,      //注销记录
    CSTypeChange,      //换货记录
    CSTypeUpdate,      //更新资料记录
    CSTypeLease,       //租赁退货记录
}CSType;

typedef enum {
    OrderTypeAll= -1,  //全部
    OrderTypeBuy = 1,  //购买
    OrderTypeRent,     //租赁
}OrderType;//我的订单列表类型

typedef enum {
    OpenApplyNone = 0,
    OpenApplyPublic,    //对公
    OpenApplyPrivate,   //对私
}OpenApplyType;  //开通类型

typedef enum {
    AddressNone = 0,
    AddressDefault,    //默认地址
    AddressOther,      //非默认地址
}AddressType;

//注册
static NSString *s_register_method = @"user/userRegistration";

//登录
static NSString *s_login_method = @"user/studentLogin";

//注册手机验证码
static NSString *s_registerValidate_method = @"user/sendPhoneVerificationCodeReg";

//发送邮件
static NSString *s_sendEmail_method = @"user/sendEmailVerificationCode";

//找回密码手机验证码
static NSString *s_findValidate_method = @"user/sendPhoneVerificationCodeFind";

//找回密码发送邮件
static NSString *s_findEmail_method = @"sendEmailVerificationCode";

//开通申请列表
static NSString *s_applyList_method = @"apply/getApplyList";

//选择商户
static NSString *s_applyMerchant_method = @"apply/getMerchant";

//选择通道
static NSString *s_applyChannel_method = @"apply/getChannels";

//选择银行
static NSString *s_applyBank_method = @"terminal/ChooseBank";

//上传图片
static NSString *s_loadImage_method = @"terminal/upload/tempImage";

//对公对私材料
static NSString *s_applyMaterial_method = @"apply/getMaterialName";

//提交申请
static NSString *s_applySubmit_method = @"apply/addOpeningApply";

//终端管理列表
static NSString *s_terminalManagerList_method = @"terminal/getApplyList";

//进入开通申请
static NSString *s_intoApply_method = @"apply/getApplyDetails";

//收单机构
static NSString *s_organzationList_method = @"terminal/getFactories";

//添加终端
static NSString *s_addTerminal_method = @"terminal/addTerminal";

//找回POS密码
static NSString *s_terminalFindPsw_method = @"terminal/Encryption";

//视频认证
static NSString *s_videoAuth_method = @"terminal/videoAuthentication";

//同步
static NSString *s_synchronize_method = @"terminal/synchronous";

//终端详情
static NSString *s_termainlDetail_method = @"terminal/getApplyDetails";

//商品列表
static NSString *s_goodList_method = @"good/list";

//商品搜索条件获取
static NSString *s_goodSearch_method = @"good/search";

//商品详细
static NSString *s_goodDetail_method = @"good/goodinfo";

//支付通道详细
static NSString *s_channelDetail_method = @"paychannel/info";

//评论列表
static NSString *s_commentList_method = @"comment/list";

//购物车列表
static NSString *s_shoppingList_method = @"cart/list";

//添加购物车
static NSString *s_addShoppingList_method = @"cart/add";

//删除购物车
static NSString *s_deleteShoppingList_method = @"cart/delete";

//修改购物车数量
static NSString *s_updateShoppingList_method = @"cart/update";

//从购物车创建订单
static NSString *s_createOrderFromCart_method = @"order/cart";

//从商品购买创建订单
static NSString *s_createOrderFromGood_method = @"order/shop";

//从商品租赁创建订单
static NSString *s_createOrderFromLease_method = @"order/lease";

//查询终端开通情况
static NSString *s_terminalSearch_method = @"terminal/openStatus";

//获取交易流水终端列表
static NSString *s_terminalList_method = @"trade/record/getTerminals";

//查询交易流水
static NSString *s_tradeRecord_method = @"trade/record/getTradeRecords";

//交易流水详情
static NSString *s_tradeDetail_method = @"trade/record/getTradeRecord";

//统计交易流水
static NSString *s_tradeTotal_method = @"trade/record/getTradeRecordTotal";

//获取用户信息
static NSString *s_userInfo_method = @"customers/getOne";

//修改用户信息
static NSString *s_userUpdate_method = @"customers/update";

//修改用户密码
static NSString *s_mofityUserPassword_method = @"customers/updatePassword";

//我的积分列表
static NSString *s_scoreList_method = @"customers/getIntegralList";

//我的积分总计
static NSString *s_scoreTotal_method = @"customers/getjifen";

//积分兑换
static NSString *s_exchangeScore_method = @"customers/insertIntegralConvert";

//地址列表
static NSString *s_addressList_method = @"customers/getAddressList";

//新增地址
static NSString *s_addressAdd_method = @"customers/insertAddress";

//修改地址
static NSString *s_addressModify_method = @"customers/updateAddress";

//删除地址
static NSString *s_addressDelete_method = @"customers/deleteAddress";

//我的商户列表
static NSString *s_merchantList_method = @"merchant/getList";

//我的商户详情
static NSString *s_merchantDetail_method = @"merchant/getOne";

//新增商户
static NSString *s_merchantAdd_method = @"merchant/insert";

//修改商户
static NSString *s_merchantModify_method = @"merchant/update";

//商户上传图片
static NSString *s_merchantUploadImage_method = @"index/upload";

//删除商户
static NSString *s_merchantDelete_method = @"merchant/delete";

//系统公告列表
static NSString *s_systemList_method = @"web/message/getAll";

//系统公告详情
static NSString *s_systemDetail_method = @"web/message/getById";

//我的消息列表
static NSString *s_messageList_method = @"message/receiver/getAll";

//我的消息详情
static NSString *s_messageDetail_method = @"message/receiver/getById";

//我的消息 单个删除
static NSString *s_messageDeleteSingle_method = @"message/receiver/deleteById";

//我的消息 批量删除
static NSString *s_messageDeleteMulti_method = @"message/receiver/batchDelete";

//我的消息已读
static NSString *s_messageRead_method = @"message/receiver/batchRead";

//我的订单列表
static NSString *s_myOrderList_method = @"order/getMyOrderAll";

//订单详情
static NSString *s_orderDetail_method = @"order/getMyOrderById";

//取消订单
static NSString *s_orderCancel_method = @"order/cancelMyOrder";

//订单评论
static NSString *s_orderComment_method = @"order/saveComment";

//订单批量评论
static NSString *s_orderMultiReview_method = @"order/batchSaveComment";

//维修记录列表
static NSString *s_repairList_method = @"cs/repair/getAll";

//维修记录取消申请
static NSString *s_repairCancel_method = @"cs/repair/cancelApply";

//维修记录详情
static NSString *s_repairDetail_method = @"cs/repair/getRepairById";

//维修记录物流
static NSString *s_repairLogistic_method = @"cs/repair/addMark";

//退货记录列表
static NSString *s_returnList_method = @"return/getAll";

//退货记录取消申请
static NSString *s_returnCancel_method = @"return/cancelApply";

//退货记录详情
static NSString *s_returnDetail_method = @"return/getReturnById";

//退货记录物流
static NSString *s_returnLogistic_method = @"return/addMark";

//注销记录列表
static NSString *s_cancelList_method = @"cs/cancels/getAll";

//注销记录取消申请
static NSString *s_cancelCancel_method = @"cs/cancels/cancelApply";

//注销记录重新提交
static NSString *s_cancelSubmit_method = @"cs/cancels/resubmitCancel";

//注销记录详情
static NSString *s_cancelDetail_method = @"cs/cancels/getCanCelById";

//换货记录列表
static NSString *s_changeList_method = @"cs/change/getAll";

//换货记录取消申请
static NSString *s_changeCancel_method = @"cs/change/cancelApply";

//换货记录详情
static NSString *s_changeDetail_method = @"cs/change/getChangeById";

//换货记录物流
static NSString *s_changeLogistic_method = @"cs/change/addMark";

//更新资料记录列表
static NSString *s_updateList_method = @"update/info/getAll";

//更新资料记录详情
static NSString *s_updateDetail_method = @"update/info/getInfoById";

//更新资料取消申请
static NSString *s_updateCancel_method = @"update/info/cancelApply";

//租赁退货记录列表
static NSString *s_leaseList_method = @"cs/lease/returns/getAll";

//租赁退货记录详情
static NSString *s_leaseDetail_method = @"cs/lease/returns/getById";

//租赁退货记录取消申请
static NSString *s_leaseCancel_method = @"cs/lease/returns/cancelApply";

//租赁退货记录物流
static NSString *s_leaseLogistic_method = @"cs/lease/returns/addMark";

//首页轮播图
static NSString *s_homeImageList_method = @"index/sysshufflingfigure/getList";

//找回密码
static NSString *s_findPassword_method = @"user/updatePassword";

//购买意向
static NSString *s_intention_method = @"paychannel/intention/add";

//订单信息
static NSString *s_orderConfirm_method = @"order/payOrder";

//维修单付款
static NSString *s_repairPay_method = @"cs/repair/repairPay";

//修改手机验证码
static NSString *s_modifyMobileValidate_method = @"index/getPhoneCode";

//修改邮箱验证码
static NSString *s_modifyEmailValidate_method = @"customers/getUpdateEmailDentcode";

//商品图片
static NSString *s_goodImage_method = @"good/getGoodImgUrl";

//推送
static NSString *s_push_method = @"customers/sendDeviceCode";

//更新
static NSString *s_update_method = @"index/getVersion";

@interface NetworkInterface : NSObject

/*!
 @abstract 1.注册
 @param activation      激活码
 @param username        邮箱
 @param userPassword    密码
 @param cityID          城市ID
 @param isEmailRegister 是否邮箱注册
 @result finish  请求回调结果
 */
+ (void)registerWithActivation:(NSString *)activation
                     username:(NSString *)username
                  userPassword:(NSString *)userPassword
                        cityID:(NSString *)cityID
               isEmailRegister:(BOOL)isEmailRegister
                      finished:(requestDidFinished)finish;

/*!
 @abstract 2.登录
 @param username      用户名
 @param password      密码
 @param encrypt       是否已加密
 @result finish  请求回调结果
 */
+ (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
         isAlreadyEncrypt:(BOOL)encrypt
                 finished:(requestDidFinished)finish;

/*!
 @abstract 3.找回密码手机验证码
 @param mobileNumber    手机号
 @result finish  请求回调结果
 */
+ (void)getFindValidateCodeWithMobileNumber:(NSString *)mobileNumber
                                   finished:(requestDidFinished)finish;

/*!
 @abstract 4.发送邮件
 @param email    邮箱号
 @result finish  请求回调结果
 */
+ (void)sendEmailWithEmail:(NSString *)email
                  finished:(requestDidFinished)finish;

/*!
 @abstract 5.获取注册手机验证码
 @param mobileNumber    手机号
 @result finish  请求回调结果
 */
+ (void)getRegisterValidateCodeWithMobileNumber:(NSString *)mobileNumber
                                       finished:(requestDidFinished)finish;


/*!
 @abstract 6.获取开通申请列表
 @param token       登录返回
 @param userID      用户ID
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */
+ (void)getApplyListWithToken:(NSString *)token
                       userID:(NSString *)userID
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish;

/*!
 @abstract 7.进入开通申请
 @param token       登录返回
 @param userID      用户ID
 @param applyStatus  开通类型 1.对公 2.对私
 @param terminalID   终端id
 @result finish  请求回调结果
 */
+ (void)beginToApplyWithToken:(NSString *)token
                       userID:(NSString *)userID
                  applyStatus:(OpenApplyType)applyStatus
                   terminalID:(NSString *)terminalID
                     finished:(requestDidFinished)finish;

/*!
 @abstract 8.选择商户
 @param token       登录返回
 @param merchantID  商户ID
 @result finish  请求回调结果
 */
+ (void)selectedMerchantWithToken:(NSString *)token
                       merchantID:(NSString *)merchantID
                         finished:(requestDidFinished)finish;

/*!
 @abstract 9.选择通道
 @param token       登录返回
 @result finish  请求回调结果
 */
+ (void)selectedChannelWithToken:(NSString *)token
                        finished:(requestDidFinished)finish;

/*!
 @abstract 10.选择银行
 @param token       登录返回
 @result finish  请求回调结果
 */
+ (void)getBankListWithToken:(NSString *)token
                  terminalID:(NSString *)terminalID
                     keyword:(NSString *)keyword
                        page:(int)page
                        rows:(int)rows
                    finished:(requestDidFinished)finish;

/*!
 @abstract 11.上传图片
 @param image       图片
 @result finish  请求回调结果
 */
+ (void)uploadImageWithImage:(UIImage *)image
                  terminalID:(NSString *)terminalID
                    finished:(requestDidFinished)finish;

/*!
 @abstract 12.获取对公对私材料
 @param token       登录返回
 @param terminalID      终端ID
 @param type        对公 对私类型
 @result finish  请求回调结果
 */
+ (void)getApplyMaterialWithToken:(NSString *)token
                       terminalID:(NSString *)terminalID
                         openType:(OpenApplyType)type
                         finished:(requestDidFinished)finish;

/*!
 @abstract 13.提交申请
 @param token       登录返回
 @param paramList   参数数组
 @result finish  请求回调结果
 */
+ (void)submitApplyWithToken:(NSString *)token
                      params:(NSArray *)paramList
                    finished:(requestDidFinished)finish;

/*!
 @abstract 15.获取终端管理终端列表
 @param token       登录返回
 @param userID      用户ID
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */
+ (void)getTerminalManagerListWithToken:(NSString *)token
                                 userID:(NSString *)userID
                                   page:(int)page
                                   rows:(int)rows
                               finished:(requestDidFinished)finish;

/*!
 @abstract 16.指定收单通道
 @param token       登录返回
 @result finish  请求回调结果
 */
+ (void)getCollectionChannelWithToken:(NSString *)token
                             finished:(requestDidFinished)finish;

/*!
 @abstract 17.添加终端
 @param token       登录返回
 @param userID      用户id
 @param institutionID    收单机构id
 @param terminalNumber   终端号
 @param merchantName     商家名
 @result finish  请求回调结果
 */
+ (void)addTerminalWithToken:(NSString *)token
                      userID:(NSString *)userID
               institutionID:(NSString *)institutionID
              terminalNumber:(NSString *)terminalNumber
                merchantName:(NSString *)merchantName
                    finished:(requestDidFinished)finish;

/*!
 @abstract 18.找回POS密码
 @param token       登录返回
 @param tmID     终端信息id
 @result finish  请求回调结果
 */
+ (void)findPOSPasswordWithToken:(NSString *)token
                            tmID:(NSString *)tmID
                        finished:(requestDidFinished)finish;

/*!
 @abstract 19.视频认证
 @param token       登录返回
 @param tmID     终端信息id
 @result finish  请求回调结果
 */
+ (void)videoAuthWithToken:(NSString *)token
                      tmID:(NSString *)tmID
                  finished:(requestDidFinished)finish;

/*!
 @abstract 20.同步
 @param token       登录返回
 @param tmID     终端信息id
 @result finish  请求回调结果
 */
+ (void)synchronizeWithToken:(NSString *)token
                        tmID:(NSString *)tmID
                    finished:(requestDidFinished)finish;

/*!
 @abstract 21.终端详情
 @param token       登录返回
 @param userID   用户id
 @param tmID     终端信息id
 @result finish  请求回调结果
 */
+ (void)getTerminalDetailWithToken:(NSString *)token
                            userID:(NSString *)userID
                              tmID:(NSString *)tmID
                          finished:(requestDidFinished)finish;

/*!
 @abstract 22.商品搜索条件
 @param cityID      城市ID
 @result finish  请求回调结果
 */
+ (void)goodSearchInfoWithCityID:(NSString *)cityID
                        finished:(requestDidFinished)finish;

/*!
 @abstract 23.商品列表
 @param cityID      城市ID
 @param filterType  排序类型
 @param brandID     POS机品牌ID
 @param category    POS机类型
 @param channelID   支付通道
 @param cardID      支付卡类型
 @param tradeID     支持交易类型
 @param slipID      签单方式
 @param date        对账日期
 @param maxPrice    最高价
 @param minPrice    最低价
 @param keyword     搜索关键字
 @param rent        是否只支持租赁 
 @param page        分页参数 页
 @param rows        分页参数 行
 @result finish  请求回调结果
 */
+ (void)getGoodListWithCityID:(NSString *)cityID
                     sortType:(OrderFilter)filterType
                      brandID:(NSArray *)brandID
                     category:(NSArray *)category
                    channelID:(NSArray *)channelID
                    payCardID:(NSArray *)cardID
                      tradeID:(NSArray *)tradeID
                       slipID:(NSArray *)slipID
                         date:(NSArray *)date
                     maxPrice:(CGFloat)maxPrice
                     minPrice:(CGFloat)minPrice
                      keyword:(NSString *)keyword
                     onlyRent:(BOOL)rent
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish;

/*!
 @abstract 24.商品详细
 @param cityID      城市ID
 @param goodID      商品ID
 @result finish  请求回调结果
 */
+ (void)getGoodDetailWithCityID:(NSString *)cityID
                         goodID:(NSString *)goodID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 25.支付通道详细
 @param channelID  支付通道id
 @result finish  请求回调结果
 */
+ (void)getChannelDetailWithChannleID:(NSString *)channelID
                             finished:(requestDidFinished)finish;

/*!
 @abstract 26.商品评论列表
 @param goodID   商品id
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getCommentListWithGoodID:(NSString *)goodID
                            page:(int)page
                            rows:(int)rows
                        finished:(requestDidFinished)finish;

/*!
 @abstract 27.购物车列表
 @param token       登录返回
 @param userID      用户ID
 @result finish  请求回调结果
 */
+ (void)getShoppingCartWithToken:(NSString *)token
                          userID:(NSString *)userID
                         finished:(requestDidFinished)finish;

/*!
 @abstract 28.添加购物车
 @param token       登录返回
 @param userID      用户ID
 @param goodID      商品ID
 @param channelID   支付通道ID
 @result finish  请求回调结果
 */
+ (void)addShoppingCartWithToken:(NSString *)token
                          userID:(NSString *)userID
                          goodID:(NSString *)goodID
                       channelID:(NSString *)channelID
                        finished:(requestDidFinished)finish;

/*!
 @abstract 29.删除购物车
 @param token       登录返回
 @param cartID      某一订单ID
 @result finish  请求回调结果
 */
+ (void)deleteShoppingCartWithToken:(NSString *)token
                             cartID:(NSString *)cartID
                           finished:(requestDidFinished)finish;

/*!
 @abstract 30.修改购物车
 @param token       登录返回
 @param cartID      某一订单ID
 @param count      数量
 @result finish  请求回调结果
 */
+ (void)updateShoppingCartWithToken:(NSString *)token
                             cartID:(NSString *)cartID
                              count:(int)count
                           finished:(requestDidFinished)finish;

/*!
 @abstract 31.查询终端业务开通情况
 @param token       登录返回
 @param userID      登录用户ID
 @param phoneNumber 手机号
 @result finish  请求回调结果
 */
+ (void)searchTerminalStatusWithToken:(NSString *)token
                               userID:(NSString *)userID
                          phoneNumber:(NSString *)phoneNumber
                             finished:(requestDidFinished)finish;

/*!
 @abstract 32.购物车创建订单
 @param token       登录返回
 @param userID      登录用户id
 @param cartsID     选中的订单id数组
 @param addressID   地址id
 @param comment     留言
 @param needInvoice 是否需要发票 0.不要 1.要
 @param invoiceType 发票类型 0.公司 1.个人
 @param invoiceTitle  发票抬头
 @result finish  请求回调结果
 */
+ (void)createOrderFromCartWithToken:(NSString *)token
                              userID:(NSString *)userID
                             cartsID:(NSArray *)cartsID
                           addressID:(NSString *)addressID
                             comment:(NSString *)comment
                         needInvoice:(int)needInvoice
                         invoiceType:(int)invoiceType
                         invoiceInfo:(NSString *)invoiceTitle
                            finished:(requestDidFinished)finish;

/*!
 @abstract 33.商品购买创建订单
 @param token       登录返回
 @param userID      登录用户id
 @param goodID     商品id
 @param channelID  支付通道id
 @param count      数量
 @param addressID   地址id
 @param comment     留言
 @param needInvoice 是否需要发票 0.不要 1.要
 @param invoiceType 发票类型 0.公司 1.个人
 @param invoiceTitle  发票抬头
 @result finish  请求回调结果
 */
+ (void)createOrderFromGoodBuyWithToken:(NSString *)token
                                 userID:(NSString *)userID
                                 goodID:(NSString *)goodID
                              channelID:(NSString *)channelID
                                  count:(int)count
                              addressID:(NSString *)addressID
                                comment:(NSString *)comment
                            needInvoice:(int)needInvoice
                            invoiceType:(int)invoiceType
                            invoiceInfo:(NSString *)invoiceTitle
                               finished:(requestDidFinished)finish;

/*!
 @abstract 34.商品租赁创建订单
 @param token       登录返回
 @param userID      登录用户id
 @param goodID     商品id
 @param channelID  支付通道id
 @param count      数量
 @param addressID   地址id
 @param comment     留言
 @param needInvoice 是否需要发票 0.不要 1.要
 @param invoiceType 发票类型 0.公司 1.个人
 @param invoiceTitle  发票抬头
 @result finish  请求回调结果
 */
+ (void)createOrderFromGoodRentWithToken:(NSString *)token
                                  userID:(NSString *)userID
                                  goodID:(NSString *)goodID
                               channelID:(NSString *)channelID
                                   count:(int)count
                               addressID:(NSString *)addressID
                                 comment:(NSString *)comment
                             needInvoice:(int)needInvoice
                             invoiceType:(int)invoiceType
                             invoiceInfo:(NSString *)invoiceTitle
                                finished:(requestDidFinished)finish;

/*!
 @abstract 35.获取终端列表
 @param token       登录返回
 @param userID      登录用户id
 @result finish  请求回调结果
 */
+ (void)getTerminalListWithToken:(NSString *)token
                          userID:(NSString *)userID
                        finished:(requestDidFinished)finish;

/*!
 @abstract 36.查询交易流水
 @param token       登录返回
 @param tradeType   交易类型
 @param terminalNum  终端号
 @param startTime   开始时间
 @param endTime     结束时间
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)searchTradeRecordWithToken:(NSString *)token
                         tradeType:(TradeType)tradeType
                    terminalNumber:(NSString *)terminalNum
                         startTime:(NSString *)startTime
                           endTime:(NSString *)endTime
                              page:(int)page
                              rows:(int)rows
                          finished:(requestDidFinished)finish;

/*!
 @abstract 37.交易流水详情
 @param token       登录返回
 @param tradeType   交易类型
 @param tradeID   交易流水id
 @result finish  请求回调结果
 */
+ (void)getTradeDetailWithToken:(NSString *)token
                      tradeType:(TradeType)tradeType
                        tradeID:(NSString *)tradeID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 38.统计交易流水
 @param token       登录返回
 @param tradeType   交易类型
 @param terminalNum  终端号
 @param startTime   开始时间
 @param endTime     结束时间
 @result finish  请求回调结果
 */
+ (void)getTradeTotalWithToken:(NSString *)token
                     tradeType:(TradeType)tradeType
                terminalNumber:(NSString *)terminalNum
                     startTime:(NSString *)startTime
                       endTime:(NSString *)endTime
                      finished:(requestDidFinished)finish;

/*!
 @abstract 39.获取用户信息
 @param token       登录返回
 @param userID      用户ID
 @result finish  请求回调结果
 */
+ (void)getUserInfoWithToken:(NSString *)token
                      userID:(NSString *)userID
                    finished:(requestDidFinished)finish;

/*!
 @abstract 40.修改用户信息
 @param token       登录返回
 @param userID      用户ID
 @param username    用户姓名
 @param mobilePhone   手机
 @param email         邮箱
 @param cityID      城市ID
 @result finish  请求回调结果
 */
+ (void)modifyUserInfoWithToken:(NSString *)token
                         userID:(NSString *)userID
                        username:(NSString *)username
                     mobilePhone:(NSString *)mobilePhone
                           email:(NSString *)email
                          cityID:(NSString *)cityID
                        finished:(requestDidFinished)finish;

/*!
 @abstract 41.修改用户密码
 @param token       登录返回
 @param userID      用户ID
 @param primayPassword   原密码
 @param newPassword      新密码
 @result finish  请求回调结果
 */
+ (void)modifyUserPasswordWithToken:(NSString *)token
                             userID:(NSString *)userID
                    primaryPassword:(NSString *)primayPassword
                        newPassword:(NSString *)newPassword
                           finished:(requestDidFinished)finish;

/*!
 @abstract 42.我的积分列表
 @param token    登录返回
 @param userID   用户id
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getScoreListWithToken:(NSString *)token
                       userID:(NSString *)userID
                         page:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish;

/*!
 @abstract 43.我的积分总计
 @param token       登录返回
 @param userID   用户id
 @result finish  请求回调结果
 */
+ (void)getScoreTotalWithToken:(NSString *)token
                        userID:(NSString *)userID
                      finished:(requestDidFinished)finish;

/*!
 @abstract 44.兑换积分
 @param token       登录返回
 @param userID   用户id
 @param handler  姓名
 @param phoneNumber   手机号
 @param money   金额
 @result finish  请求回调结果
 */
+ (void)exchangeScoreWithToken:(NSString *)token
                        userID:(NSString *)userID
                   handlerName:(NSString *)handlerName
            handlerPhoneNumber:(NSString *)phoneNumber
                         money:(int)money
                      finished:(requestDidFinished)finish;

/*!
 @abstract 45.地址列表
 @param token       登录返回
 @param userID   交易类型
 @result finish  请求回调结果
 */
+ (void)getAddressListWithToken:(NSString *)token
                         usedID:(NSString *)userID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 46.新增地址
 @param token       登录返回
 @param userID   用户id
 @param cityID    城市id
 @param receiverName   收件人姓名
 @param phoneNumber   收件人电话
 @param zipCode   邮编
 @param address   详细地址
 @param addressType  是否默认地址
 @result finish  请求回调结果
 */
+ (void)addAddressWithToken:(NSString *)token
                     userID:(NSString *)userID
                     cityID:(NSString *)cityID
               receiverName:(NSString *)receiverName
                phoneNumber:(NSString *)phoneNumber
                    zipCode:(NSString *)zipCode
                    address:(NSString *)address
                  isDefault:(AddressType)addressType
                   finished:(requestDidFinished)finish;

/*!
 @abstract .修改地址
 @param token       登录返回
 @param userID      用户id
 @param addressID   地址ID
 @param cityID    城市id
 @param receiverName   收件人姓名
 @param phoneNumber   收件人电话
 @param zipCode   邮编
 @param address   详细地址
 @param addressType  是否默认地址
 @result finish  请求回调结果
 */
+ (void)modifyAddressWithToken:(NSString *)token
                        userID:(NSString *)userID
                     addressID:(NSString *)addressID
                        cityID:(NSString *)cityID
                  receiverName:(NSString *)receiverName
                   phoneNumber:(NSString *)phoneNumber
                       zipCode:(NSString *)zipCode
                       address:(NSString *)address
                     isDefault:(AddressType)addressType
                      finished:(requestDidFinished)finish;

/*!
 @abstract 47.删除地址
 @param token       登录返回
 @param addressIDs   地址id数组
 @result finish  请求回调结果
 */
+ (void)deleteAddressWithToken:(NSString *)token
                     addressIDs:(NSArray *)addressIDs
                      finished:(requestDidFinished)finish;

/*!
 @abstract 48.我的商户列表
 @param token       登录返回
 @param userID   用户id
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getMerchantListWithToken:(NSString *)token
                          userID:(NSString *)userID
                            page:(int)page
                            rows:(int)rows
                        finished:(requestDidFinished)finish;

/*!
 @abstract 49.我的商户详情
 @param token       登录返回
 @param merchantID   商户id
 @result finish  请求回调结果
 */
+ (void)getMerchantDetailWithToken:(NSString *)token
                        merchantID:(NSString *)merchantID
                          finished:(requestDidFinished)finish;

/*!
 @abstract 50.添加商户

 @result finish  请求回调结果
 */
+ (void)createMerchantWithToken:(NSString *)token
                         userID:(NSString *)userID
                   merchantName:(NSString *)merchantName
                     personName:(NSString *)personName
                       personID:(NSString *)personID
                      licenseID:(NSString *)licenseID
                          taxID:(NSString *)taxID
                       oraganID:(NSString *)organID
                         cityID:(NSString *)cityID
                       bankName:(NSString *)bankName
                         bankID:(NSString *)bankID
                      frontPath:(NSString *)frontPath
                       backPath:(NSString *)backPath
                       bodyPath:(NSString *)bodyPath
                    licensePath:(NSString *)licensePath
                        taxPath:(NSString *)taxPath
                        orgPath:(NSString *)orgPath
                       bankPath:(NSString *)bankPath
                       finished:(requestDidFinished)finish;

/*!
 @abstract 51.修改商户
 @param token       登录返回
 @param merchant   商户信息  只需传修改的字段即可 未修改的传nil
 @result finish  请求回调结果
 */
+ (void)modifyMerchantWithToken:(NSString *)token
                 merchantDetail:(MerchantDetailModel *)merchant
                       finished:(requestDidFinished)finish;

/*!
 @abstract 上传商户图片
 @param image      图片
 @result finish  请求回调结果
 */
+ (void)uploadMerchantImageWithImage:(UIImage *)image
                            finished:(requestDidFinished)finish;

/*!
 @abstract 52.删除商户 多删
 @param token       登录返回
 @param merchantIDs   需要删除商户的id数组 id为int类型
 @result finish  请求回调结果
 */
+ (void)deleteMerchantWithToken:(NSString *)token
                    merchantIDs:(NSArray *)merchantsID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 53.系统公告列表
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getSystemListWithPage:(int)page
                         rows:(int)rows
                     finished:(requestDidFinished)finish;

/*!
 @abstract 54.系统公告详情
 @param messageID   系统公告id
 @result finish  请求回调结果
 */
+ (void)getSystemDetailWithID:(NSString *)messageID
                     finished:(requestDidFinished)finish;

/*!
 @abstract 55.我的消息列表
 @param token       登录返回
 @param userID   用户id
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getMyMessageListWithToken:(NSString *)token
                           userID:(NSString *)userID
                             page:(int)page
                             rows:(int)rows
                         finished:(requestDidFinished)finish;

/*!
 @abstract 56.我的消息详情
 @param token       登录返回
 @param userID   用户id
 @param messageID   消息id
 @result finish  请求回调结果
 */
+ (void)getMyMessageDetailWithToken:(NSString *)token
                             userID:(NSString *)userID
                          messageID:(NSString *)messageID
                           finished:(requestDidFinished)finish;

/*!
 @abstract 57.我的消息单个删除
 @param token       登录返回
 @param userID   用户id
 @param messageID   消息id
 @result finish  请求回调结果
 */
+ (void)messageDeleteSingleWithToken:(NSString *)token
                              userID:(NSString *)userID
                           messageID:(NSString *)messageID
                            finished:(requestDidFinished)finish;

/*!
 @abstract 58.我的消息批量删除
 @param token       登录返回
 @param userID   用户id
 @param messagesID   消息数组
 @result finish  请求回调结果
 */
+ (void)messsageDeleteMultiWithToken:(NSString *)token
                              userID:(NSString *)userID
                          messagesID:(NSArray *)messagesID
                            finished:(requestDidFinished)finish;

/*!
 @abstract 59.我的消息批量已读
 @param token       登录返回
 @param userID   用户id
 @param messagesID   消息数组
 @result finish  请求回调结果
 */
+ (void)messageReadWithToken:(NSString *)token
                      userID:(NSString *)userID
                  messagesID:(NSArray *)messagesID
                    finished:(requestDidFinished)finish;

/*!
 @abstract 60.我的订单列表
 @param token       登录返回
 @param userID   用户id
 @param type     订单类型
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getMyOrderListWithToken:(NSString *)token
                         userID:(NSString *)userID
                      orderType:(OrderType)type
                           page:(int)page
                           rows:(int)rows
                       finished:(requestDidFinished)finish;

/*!
 @abstract 61.我的订单详情
 @param token       登录返回
 @param orderID   订单id
 @result finish  请求回调结果
 */
+ (void)getMyOrderDetailWithToken:(NSString *)token
                          orderID:(NSString *)orderID
                         finished:(requestDidFinished)finish;

/*!
 @abstract 62.取消订单
 @param token       登录返回
 @param orderID   订单id
 @result finish  请求回调结果
 */
+ (void)cancelMyOrderWithToken:(NSString *)token
                       orderID:(NSString *)orderID
                      finished:(requestDidFinished)finish;

/*!
 @abstract 63.订单评论
 @param token       登录返回
 @param userID   用户id
 @param orderID   订单id
 @param score   评分
 @param content  评论内容
 @result finish  请求回调结果
 */
+ (void)commentMyOrderWithToken:(NSString *)token
                         userID:(NSString *)userID
                        orderID:(NSString *)orderID
                          score:(int)score
                        content:(NSString *)content
                       finished:(requestDidFinished)finish;

/*!
 @abstract 63.订单批量评论
 @param token       登录返回
 @param orderID     订单id
 @param reviewList  评论数组
 @result finish  请求回调结果
 */
+ (void)reviewMultiOrderWithToken:(NSString *)token
                          orderID:(NSString *)orderID
                       reviewList:(NSArray *)reviewList
                         finished:(requestDidFinished)finish;

/*!
 @abstract 64.维修记录列表 68.退货记录列表 72.注销记录列表 76.换货记录列表 80.更新资料记录列表 83.租赁退还记录列表
 @param token       登录返回
 @param userID   用户id
 @param csType   售后记录类别
 @param page     分页参数 页
 @param rows     分页参数 行
 @result finish  请求回调结果
 */
+ (void)getCSListWithToken:(NSString *)token
                    userID:(NSString *)userID
                    csType:(CSType)csType
                      page:(int)page
                      rows:(int)rows
                  finished:(requestDidFinished)finish;

/*!
 @abstract 65.维修记录取消订单 69.退货记录取消申请  73.注销记录取消申请 78.换货记录取消申请 82.更新资料取消申请 85.租赁退货取消申请
 @param token       登录返回
 @param csID      id
 @param csType   售后记录类别
 @result finish  请求回调结果
 */
+ (void)csCancelWithToken:(NSString *)token
                     csID:(NSString *)csID
                   csType:(CSType)csType
                 finished:(requestDidFinished)finish;


/*!
 @abstract 66.维修记录详情 70.退货记录详情 75.注销记录详情 77.换货记录详情 81.更新资料记录详情 84.租赁退还记录详情
 @param token       登录返回
 @param csID     售后id
 @param csType   售后记录类别
 @result finish  请求回调结果
 */
+ (void)getCSDetailWithToken:(NSString *)token
                        csID:(NSString *)csID
                      csType:(CSType)csType
                    finished:(requestDidFinished)finish;

/*!
 @abstract 67.维修记录物流 71.退货记录物流 79.换货记录物流 86.租赁退还记录物流
 @param token       登录返回
 @param userID     用户id
 @param csID     售后id
 @param csType   售后记录类别
 @param csID     售后id
 @param companyName    物流公司
 @param number    物流单号
 @result finish  请求回调结果
 */
+ (void)csLogisticWithToken:(NSString *)token
                     userID:(NSString *)userID
                       csID:(NSString *)csID
                     csType:(CSType)csType
            logisticCompany:(NSString *)companyName
             logisticNumber:(NSString *)number
                   finished:(requestDidFinished)finish;

/*!
 @abstract 74.重新提交注销记录
 @param token       登录返回
 @param csID     售后id
 @result finish  请求回调结果
 */
+ (void)submitCancelInfoWithToken:(NSString *)token
                             csID:(NSString *)csID
                         finished:(requestDidFinished)finish;


/*!
 @abstract 首页轮播图
 @result finish  请求回调结果
 */
+ (void)getHomeImageListFinished:(requestDidFinished)finish;

/*!
 @abstract 90.找回密码
 @param username  用户名
 @param password  密码
 @param validateCode  验证码
 @result finish  请求回调结果
 */
+ (void)findPasswordWithUsername:(NSString *)username
                        password:(NSString *)password
                    validateCode:(NSString *)validateCode
                        finished:(requestDidFinished)finish;

/*!
 @abstract 购买意向
 @param name  姓名
 @param phoneNumber  手机号
 @param content  内容
 @result finish  请求回调结果
 */
+ (void)sendBuyIntentionWithName:(NSString *)name
                     phoneNumber:(NSString *)phoneNumber
                         content:(NSString *)content
                        finished:(requestDidFinished)finish;

/*!
 @abstract 订单信息
 @result finish  请求回调结果
 */
+ (void)orderConfirmWithOrderID:(NSString *)orderID
                       finished:(requestDidFinished)finish;

/*!
 @abstract 维修单支付
 @result finish  请求回调结果
 */
+ (void)repairConfirmWithRepairID:(NSString *)repairID
                         finished:(requestDidFinished)finish;

+ (void)beginVideoAuthWithTerminalID:(NSString *)terminalID
                            finished:(requestDidFinished)finish;

+ (void)getModifyMobileValidateWithPhoneNumber:(NSString *)phoneNumber
                                      finished:(requestDidFinished)finish;

+ (void)getModifyEmailValidateWithUserID:(NSString *)userID
                                   email:(NSString *)email
                               finished:(requestDidFinished)finish;

+ (void)getGoodImageWithGoodID:(NSString *)goodID
                      finished:(requestDidFinished)finish;

+ (void)uploadPushInfoWithUserID:(NSString *)userID
                     channelInfo:(NSString *)channelInfo
                        finished:(requestDidFinished)finish;

+ (void)checkVersionFinished:(requestDidFinished)finish;

@end

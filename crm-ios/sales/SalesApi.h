//
//  SalesApi.h
//  sales
//
//  Created by user on 2016/11/7.
//  Copyright © 2016年 rayootech. All rights reserved.
//

#ifndef SalesApi_h
#define SalesApi_h

//#define QINIU                           @"http://7xpvmt.com1.z0.glb.clouddn.com/"
#define QINIU                           @"http://p0zvn8w56.bkt.clouddn.com/"
//#define BASE_URL                        @"http://192.168.1.172:8080/crm"
#define BASE_URL                        @"http://106.14.170.7:8080/crm"
#define API_CONTACT_LIST                @"/api/v1/contact/list"
#define API_LOGIN                       @"/api/v1/u/login"
#define API_UPDATE_PWD                  @"/api/v1/u/updatepwd"
#define API_USERINFO_UPDATE             @"/api/v1/u/edit"
#define API_CIRCLE_LIST                 @"/api/v1/circle/list"
#define API_CIRCLE_COMMENT_LIST         @"/api/v1/circle/comment"
#define API_CIRCLE_COMMENT_POST         @"/api/v1/circle/comment/post"
#define API_CIRCLE_UNREAD               @"/api/v1/opost/updateopostlist"
#define API_CIRCLE_DELETE               @"/api/v1/circle/comment/del"
#define API_CIRCLE_FAV                  @"/api/v1/circle/comment/favour"
#define API_COMMON_QINIU_NOKEY_TOKEN    @"/common/getUptoken"
#define API_COMMON_QINIU_KEY_TOKEN      @"/common/getToken"
#define API_CIRCLE_NEW                  @"/api/v1/circle/new"
#define API_CONTACT_ADD                 @"/api/v1/contact/add"
#define API_CONTACT_EDIT                @"/api/v1/contact/edit"
#define API_CONTACT_DELETE              @"/api/v1/contact/delete"
#define API_CONTACT_SEARCH              @"/api/v1/contact/search"
#define API_REQ_ADD_FRIEND              @"/api/v1/contact/friend/add"
#define API_FIND_BYID                   @"/api/v1/u/findbyid"
#define API_ORGANIZATION_LIST           @"/api/v1/organization/list"
#define API_ORGANIZATION_JOIN           @"/api/v1/organization/join"
#define API_ORGANIZATION_ACCEPT_INVITE  @"/api/v1/organization/apply"
#define API_ORGANIZATION_NEW            @"/api/v1/organization/new"
#define API_ORGANIZATION_EDIT           @"/api/v1/organization/edit"
#define API_PUSH_IDENTIFYCODE           @"/api/v1/auth/pushIdentifyCode"
#define API_CHECK_IDENTIFYCODE          @"/api/v1/auth/checkIdentifyCode"
#define API_REGISTER                    @"/api/v1/u/reg"
#define API_FORGETPWD                   @"/api/v1/u/forgetpwd"

#define API_COLLEAGUE_LIST              @"/api/v1/org/colleague/list"
#define API_COLLEAGUE_GETLEADER         @"/api/v1/org/colleague/superior"
#define API_COLLEAGUE_SETLEADER         @"/api/v1/org/colleague/leader"
#define API_ORGUSER_SEARCH              @"/api/v1/u/findByMobile"
#define API_ORG_INVITE                  @"/api/v1/organization/invite"
#define API_NOTICE_LIST                 @"/api/v1/announcement/list"
#define API_PAPER_LIST                  @"/api/v1/article/list"
#define API_NEWS_LIST                   @"/api/v1/news/list"
#define API_SERVICE_LIST                @"/api/v1/message/getpmlist"
#define API_DEAL_SERVICE                @"/api/v1/message/dealmessage"
#define API_ACTIVE_LIST                 @"/api/v1/active/list"
#define API_BLACKBOARD_LIST             @"/api/v1/blackboard/list"
#define API_BLACKBOARD_COMMENT_LIST     @"/api/v1/blackboard/comment"
#define API_BLACKBOARD_COMMENT_POST     @"/api/v1/blackboard/comment/post"
#define API_BLACKBOARD_FAV              @"/api/v1/blackboard/comment/favour"
#define API_CUSTOMER_LIST               @"/api/v1/customer/list"
#define API_CUSTOMER_EDIT               @"/api/v1/customer/edit"
#define API_CUSTOMER_ADD                @"/api/v1/customer/new"
#define API_CUSTOMER_SEARCH             @"/api/v1/customer/search"
#define API_CUSTOMER_SHIFT              @"/api/v1/customer/shift"
#define API_CUSTOMER_LOCK               @"/api/v1/customer/lock"
#define API_CUSTOMER_DIST               @"/api/v1/customer/distribution"
#define API_CUSTOMER_DELETE             @"/api/v1/customer/del"


#define API_CUSTOMER_INFO_SAVE          @"/api/v1/customer/personal/save"
#define API_CUSTOMER_SOCIAL_GET         @"/api/v1/customer/sns/info"
#define API_CUSTOMER_SOCIAL_EDIT        @"/api/v1/customer/sns/edit"
#define API_CUSTOMER_EVALUATION_GET     @"/api/v1/customer/evaluation"
#define API_CUSTOMER_EVALUATION_SAVE    @"/api/v1/customer/evaluation/save"
#define API_CUSTOMER_SETTING_GET        @"/api/v1/customer/setting"

#define API_NOTICE_PUBLISH              @"/api/v1/announcement/new"
#define API_BLACKBOARD_PUBLISH          @"/api/v1/blackboard/new"

#define API_ACCEPT_FRIEND_REQ           @"/api/v1/contact/add/do"

#define API_UNREAD_CIRCLE_REPLY         @"/api/v1/comments/updatecommentslist"
#define API_BLACKBOARD_UNREAD           @"/api/v1/blackboard/updateblackboardlist"
#define API_BLACKBOARD_DELETE           @"/api/v1/blackboard/comment/del"
#define API_UNREAD_BLACKBOARD_REPLY     @"/api/v1/blackboard/updatebbcommentslist"
#define API_CUSTOMER_DUP                @"/api/v1/customer/check/duplicate"

#define API_WORK_LIST                   @"/api/v1/work/list"
#define API_WORK_COMMENT_LIST           @"/api/v1/work/comment"
#define API_WORK_COMMENT_POST           @"/api/v1/work/comment/post"
#define API_WORK_FAV                    @"/api/v1/work/comment/favour"
#define API_WORK_PUBLISH                @"/api/v1/work/publish"
#define API_WORK_UNREAD                 @"/api/v1/work/updateWorkList"
#define API_UNREAD_WORK_REPLY           @"/api/v1/work/updatecommentslist"

#define API_DEPT_DEPTINFO               @"/api/v1/dept/deptinfo"
#define API_DEPT_POINT                  @"/api/v1/dept/appoint"
#define API_DEPT_ADD                    @"/api/v1/dept/adddept"
#define API_GET_EMAIL_CODE              @"/api/v1/org/sendEmail"
#define API_BIND_EMAIL                  @"/api/v1/org/checkCode"
#define API_ORGUSER_INFO_SAVE           @"/api/v1/org/protal/info/save"

#define API_NEW_INVITE                  @"/api/v1/organization/findCast"

#endif /* SalesApi_h */

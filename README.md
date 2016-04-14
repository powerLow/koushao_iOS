#KoushaoAPI
#用户

URL | HTTP| 功能
:----------- | :-----------: | -----------:
/1.0/login   | POST        | 手机用户登陆
/1.0/logout   | POST        | 用户登出
/1.0/login/auth|POST|第三方SNS登陆
/1.0/login/sms|POST|短信登陆
/1.0/users/register   | POST        | 手机用户注册
/1.0/users/bindphone   | POST        | 绑定手机号
/1.0/users/resetpwd   | POST        | 短信重置密码
/1.0/users/modifypwd|POST|修改密码
/1.0/users/show		   |POST		 | 获取用户信息
/1.0/users/subaccount|POST|添加子账号
/1.0/users/subaccount|GET|获取子账号列表
/1.0/users/subaccount|PUT|获取修改子账号密码、权限
/1.0/users/subaccount|DELETE|删除子账号
/1.0/users/profile|POST|修改昵称
#短信验证
URL | HTTP| 功能
:----------- | :-----------: | -----------:
/1.0/requestSmsCode|POST|请求发送短信验证码
#活动
URL | HTTP| 功能
:----------- | :-----------: | -----------:
/1.0/activity|POST|创建活动
/1.0/activity|PUT|修改活动
/1.0/activity|GET|获取活动详情
/1.0/activity/exist|POST|活动是否存在
/1.0/activity/bindanonymous|POST|匿名活动绑定账号
/1.0/activity/start|POST|开始活动
/1.0/activity/stop|POST|停止活动
/1.0/activity/list|POST|获取我的活动列表
/1.0/activity/ticket|POST|活动票务设置
/1.0/activity/template|POST|活动模板设置
/1.0/activity/module|POST|活动模块启用设置
/1.0/activity/welfare|POST|创建福利
/1.0/activity/welfare|DELETE|删除福利
/1.0/activity/welfare/stop|POST|停用福利(管理)
/1.0/activity/welfare/analyse|POST|统计福利(管理)
/1.0/activity/welfare/verify|POST|扫码发放、短信码发放(福利发放)
/1.0/activity/welfare/verifylogs|POST|福利发放统计
/1.0/activity/welfare/verifylogs/detail|POST|福利发放统计->福利详情
/1.0/activity/welfare/award/list|POST|福利实物奖品列表
/1.0/activity/welfare/award/detail|POST|福利实物奖品详情
/1.0/activity/welfare/award/confirm|POST|确认发放
/1.0/activity/signin|POST|主办方活动签到（扫描、短信码）
/1.0/activity/signin/list|POST|主办方活动签到列表
/1.0/activity/signin/detail|POST|主办方活动签到列表->详情
#咨询
URL | HTTP| 功能
:----------- | :-----------: | -----------:
/1.0/question/list|POST|获取活动的咨询问题列表
/1.0/question/reply|POST|回复咨询的问题
/1.0/question/reply|DELETE|删除咨询
#二维码
URL | HTTP| 功能
:----------- | :-----------: | -----------:
/1.0/activity/qrcode|POST|生成相应活动的签到二维码
#统计数据
URL | HTTP| 功能
:----------- | :-----------: | -----------:
/1.0/analyse/info|POST|我的统计
/1.0/analyse/moneyinfo|POST|我的金额
/1.0/analyse/moneyrecord|POST|我的金额-详细记录
/1.0/analyse/baseinfo|POST|活动主页面
/1.0/analyse/visitsinfo|POST|浏览详情页面
/1.0/analyse/enrollinfo|POST|报名详情页面
/1.0/analyse/enrollrecord|POST|报名记录/售票 页面
/1.0/analyse/enrollrecord/detail|POST|报名记录/售票->个人报名详情
/1.0/analyse/drawmoney|POST|我要提现
#钱
URL | HTTP| 功能
:----------- | :-----------: | -----------:
/1.0/money/gettoken|POST|获取上传身份证的token
/1.0/money/drawcash|POST|申请提现
#意见反馈
URL | HTTP| 功能
:----------- | :-----------: | -----------:
/1.0/feedback|POST|意见反馈
#网络图片
URL | HTTP| 功能
:----------- | :-----------: | -----------:
/1.0/picture|POST|获取网络图库的图片
#source的算法
post的参数，key-value，对`key`进行升序排序，然后以`key+value`组合成字符串。
字符串首尾加上`8fbd1f48f57585874528afe622f241eadd54ff5a`，取md5

`PS:（只包括字符串和数值类型，如果是数组或者其他类型则忽略）`

例如

    [('t', 1436162479), ('username', '15605817820')]
    
排序并拼接字符串后

    8fbd1f48f57585874528afe622f241eadd54ff5at1436162479username156058178208fbd1f48f57585874528afe622f241eadd54ff5a
    
取md5计算得

    source: 6c3f40fd5256ceedc92517a3f56b0c1c
    
   
提交参数

    {"username": "15605817820", "source": "6c3f40fd5256ceedc92517a3f56b0c1c", "t": 1436162479}

##用户注册(手机号)

	
 **简要描述：** 

- 用户注册接口

**请求URL：** 
- ` http://api.koushaoapp.com/1.0/users/register `
  
**请求方式：**
- POST 

**参数：** 

|参数名|必选|类型|说明|
|:----    |:---|:----- |-----   |
|nickname |是  |string |用户昵称  |
|mobilePhone |是  |string |注册的手机号  |
|password |是  |string | 密码    |
|code     |是  |string | 手机验证码    |
|t     |是  |int | 时间戳    |
 **返回示例**
 
``` 
  {
		"error": {
			"errorno": 0,
			"msg": "注册成功"
		}
	}
```

 **返回参数说明** 

|参数名|类型|说明|
|:-----  |:-----|-----                           |
|error |int   |用户组id，1：超级管理员；2：普通用户  |

 **备注** 

- 更多返回错误代码请看首页的错误代码描述
- 注:如果带上`hash`，则表示登陆时把该`hash`对应的活动归属到登陆用户名下


 
##手机登陆

**简要描述：** 

- 手机登陆接口

**请求URL：** 
- ` http://api.koushaoapp.com/1.0/login `
  
**请求方式：**
- POST 

**参数：** 

|参数名|必选|类型|说明|
|:----    |:---|:----- |-----   |
|mobilePhone |是  |string |对应请求返回的accesstoken |
|password |是  |string | 对应请求返回的openid,uid等|
|login_page     |否  |string |登陆页面，0是正常登陆，1是发布页面|
|t     |是  |int | 时间戳    |

 **返回示例**

成功

``` 

	{
		"result": {
			"sessionToken": "b18ecdcf26b1d5efd9336f860a13c696"
			"username": "fe8e72eac162d2576bf2e948072f340f"
		},
		"error": {
			"errorno": 0,
			"msg": "登陆成功"
		}
	}
```

失败

```
	{
		"error": {
			"errorno": 210,
			"msg": "用户名和密码不匹配"
		}
	}
```
 **返回参数说明** 

|参数名|类型|说明|
|:-----  |:-----|-----                           |
|sessionToken |string   |表明登陆状态,有有效期限|
|username |string   |是用户的唯一标识,防止以后有更换手机号的需求,故用`username`做唯一标识|

 **备注** 

- 更多返回错误代码请看首页的错误代码描述
- 登陆成功后的`sessionToken`和`username`需要添加在后续请求的header中


##第三方登陆

**简要描述：** 

- 第三方登陆接口,支持`QQ` `微信` `微博`

**请求URL：** 
- ` http://api.koushaoapp.com/1.0/login/auth `
  
**请求方式：**
- POST 

**参数：** 

|参数名|必选|类型|说明|
|:----    |:---|:----- |-----   |
|access_token|是|string|对应请求返回的accesstoken
|openid|是|string|对应请求返回的openid,uid等|
|type|是|string|第三方授权的类型,`weibo`,`weixin`,`qq`
|t|是|int|当前时间戳

 **返回示例**

成功

``` 
	{
		"error": {
			"errorno": 0,
			"msg": "登陆成功"
		},
		"result": {
			"sessionToken": "d8717c335da4e4a65e5602ef80f09abc",
			"username": "5499663623",
			"nickname": "DevilLiao",
			"mobilePhoneVerified":  True
		}
	}
```
 **返回参数说明** 

|参数名|类型|说明|
|:-----  |:-----|-----                           |
|sessionToken |string   |token  |
|username |string   |唯一标识  |
|nickname |string   |昵称  |
|mobilePhoneVerified |bool   |  是否验证|

 **备注** 

- 更多返回错误代码请看首页的错误代码描述


##短信登陆
>请求验证码的`type`为2,不管手机存不存在都发送验证码

######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
mobilePhone|true|string|手机号
code|true|string|验证码
t|true|int|当前时间戳


######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-d '{"mobilePhone": "13216708954", "code": "549966", 
	 "source": "2db94efbf7b6445e61fef5cd666c831c", "t": "1321670891"}' \
	http://api.koushaoapp.com/1.0/login/sms
	
######返回
参数 | 必选
:----------- | :-----------: | 
isnew|新创建的用户(第一次登陆)

##绑定手机号
>需要在第三方登陆的情况下进行保存,header包括`token`和`username`

######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
mobilePhone|true|string|需要绑定的手机号
code|true|string|收到的手机验证码
t|true|int|当前时间戳

######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-d '{"source": "f0e4edcbb6b611b949b6511a386911ea", "code": "420231", "t": 1436782023, "mobilePhone": "18679824092"}' \
	http://api.koushaoapp.com/1.0/users/bindphone
	
#####成功

	{
	  "error": {
	    "errorno": 0, 
		"msg": "绑定手机号成功"
	  }
	}

#####失败

	{
 	 "error": {
    	"errorno": 214, 
    	"msg": "手机号码已经被注册"
  		}
	}

	
##用户登出

######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-d '{"mobilePhone": "15605817820", "source": "8361cb85e4ccad2843d4f976896b2a92", "t": 1436160710}' \
	http://api.koushaoapp.com/1.0/logout
	
######成功

	{
		"error": {
			"errorno": 0,
			"msg": "退出成功"
		}
	}
##获取用户信息

######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-d '{"t": 1436160710, "source": "091c10b52b65320a37b0beb1fda7bb4e"}' \
	http://api.koushaoapp.com/1.0/users/show

#####成功

	{
		"error": {
			"errorno": 0,
			"msg": "获取成功"
		},
		"result": {
			"userinfo": {
				"attr": {},
				"email": "",
				"mobilePhone": "18679824092",
				"nickname": "猫帅",
				"username": "fe8e72eac162d2576bf2e948072f340d"
			}
		}
   }
##修改密码
>先调用手机验证码
######请求参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
old_password|true|string|旧密码
new_password|true|string|新密码
code|true|string|短信验证码
t|true|int|当前时间戳
######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-d '{"source": "091c10b52b65320a37b0beb1fda7bb4e", "new_password": "qqqqqq", "old_password": "wwwwww", "code": "593294", "t": 1436175645}' \
	http://api.koushaoapp.com/1.0/users/modifypwd

##重置密码
>先调用手机验证码
######请求参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
mobilePhone|true|string|手机号
password|true|string|密码
code|true|string|短信验证码
t|true|int|当前时间戳
######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-d '{"mobilePhone": "15605817820", "source": "091c10b52b65320a37b0beb1fda7bb4e", "password": "qqqqqq", "code": "593294", "t": 1436175645}' \
	http://api.koushaoapp.com/1.0/users/resetpwd
######成功

	{
		"error": {
			"errorno": 0,
			"msg": "重置成功"
		}
	}
######失败

	{
		"error": {
			"errorno": 603,
			"msg": "无效的短信验证码"
		}
	}
##请求手机验证码

######发送格式 

	curl -X POST \
	-H "Content-Type: application/json" \
	-d '{"mobilePhoneNumber":"18679824092","t":1436280479,"source": "7975c8045966483efa2b8a1a0350a620"}' \
	http://api.koushaoapp.com/1.0/requestSmsCode

######成功

	{
		"error": {
			"errorno": 0,
			"msg": "短信请求成功"
	  }
	}
######失败

	{
		"error": {
			"errorno": 603,
			"msg": "发送短信过于频繁。"
		}
	}

##创建子账号
######请求参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
username|true|string|子账号名字,@之前的
password|true|string|密码
signin|true|int|是否有签到管理权限,0没有1有
question|true|int|是否有咨询回复权限,0没有1有
welfare|true|int|是否有福利发放权限,0没有1有
t|true|int|当前时间戳

######发送格式 

	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"username": "chenqi", "question": 1, "signin": 1, "source": "c04d1eb29f6da7e6521bf6f9bea0a952", "t": 1437642380, "welfare": 1, "password": "qwerty"}' \
	http://api.koushaoapp.com/1.0/users/subaccount
######回复参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
username|true|string|子账号名字,全名,xxx@xxx,用于登陆
#####成功
    {
      "error": {
        "errorno": 0, 
        "msg": "success"
      }, 
      "result": {
        "username": "chenqi@18679824093"
      }
    }
##获取该账号的子账号列表
######请求参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
t|true|int|当前时间戳
######发送格式 

	curl -X GET \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	http://127.0.0.1:5000/1.0/users/subaccount?source=e1dcc7be40148c979c303c4a961b83f6&t=1437642611

#####成功

    {
      "error": {
        "errorno": 0, 
        "msg": "success"
      }, 
      "result": {
        "list": [
          {
            "attr": {
              "question": 1, 
              "signin": 1, 
              "welfare": 1
            }, 
            "mobilePhone": "", 
            "nickname": "liao", 
            "username": "liao@18679824093"
          }, 
          {
            "attr": {
              "question": 1, 
              "signin": 1, 
              "welfare": 1
            }, 
            "mobilePhone": "", 
            "nickname": "chenqi", 
            "username": "chenqi@18679824093"
          }
        ]
      }
    }
##修改子账号密码、权限
######请求参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
username|true|string|子账号名字,@之前的
password|true|string|密码
signin|true|int|是否有签到管理权限,0没有1有
question|true|int|是否有咨询回复权限,0没有1有
welfare|true|int|是否有福利发放权限,0没有1有
t|true|int|当前时间戳

######发送格式 

	curl -X PUT \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"username": "chenqi@18679824093", "question": 1, "signin": 1, "source": "c04d1eb29f6da7e6521bf6f9bea0a952", "t": 1437642380, "welfare": 1, "password": "qwerty"}' \
	http://api.koushaoapp.com/1.0/users/subaccount
##删除子账号
######请求参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
username|true|string|子账号名字,@之前的
t|true|int|当前时间戳

######发送格式 

	curl -X DELETE \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"username": "chenqi@18679824093", "source": "c04d1eb29f6da7e6521bf6f9bea0a952", "t": 1437642380}' \
	http://api.koushaoapp.com/1.0/users/subaccount
##修改昵称

|参数名|必选|类型|说明|
|:----    |:---|:----- |-----   |
|name |是  |string |新的名字   |
|gender|是|int|男0，女1|

######发送格式 

	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"source": "7d34db4bb85bc64e3c557c1fb4386ebd", "name": "我是帅哥", "t": 1439867538}' \
	http://api.koushaoapp.com/1.0/users/profile

#活动
##创建活动
>点击创建活动后会返回一个`hash`,是这个活动的唯一标识(对外).

######参数

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
title|true|string|活动的主题
category|true|int|0是线下,1是线上
poster|true|string|海报URL
detail|false|string|活动详情
location|false|string|活动地址
longitude|false|string|经度
latitude|false|float|纬度
startTime|false|int|开始时间戳
endTime|false|int|结束时间戳
t|true|int|当前时间戳

######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-d '{"category": 1, "title": "华东交大毕业晚会", "poster": "https://ymr.me", "detail": "<h5>detail</h5>", "source": "686cd1047f2c394ec164bd52fd3e6700", "location": "中南海", "t": 1436341266}' \
	http://api.koushaoapp.com/1.0/activity
	
######成功

	{
		"result": {
			"hash": "4de74ae3-2544-11e5-8802-b8e8563b581e",
			"sig": "a0e370fb99e1b706c9cd9456919e8621"
		},
		"error": {
			"errorno": 0,
			"msg": "活动创建成功"
		}
	}


##修改活动
>增量更新

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的hash
title|false|string|活动的主题
category|false|string|0是线下,1是线上
poster|false|string|海报URL
detail|false|string|活动详情
location|false|string|活动地址
longitude|false|string|经度
latitude|false|float|纬度
startTime|false|int|开始时间戳
endTime|false|int|结束时间戳
color|false|string|颜色值,默认F48B85
######发送格式

	curl -X PUT \
	-H "Content-Type: application/json" \
	-d '{"category": 0, "title": "华东交大毕业晚会", "poster": "https://ymr.me", "detail": "<h5>detail</h5>", "source": "686cd1047f2c394ec164bd52fd3e6700", "location": "中南海"' \
	http://api.koushaoapp.com/1.0/activity

##活动是否存在
>恢复活动时候调用判断

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的hash
t|true|int|时间戳
######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-d '{"source": "686cd1047f2c394ec164bd52fd3e6700", "t": "1234567898"}' \
	http://api.koushaoapp.com/1.0/activity/exist
	
##当前账号绑定匿名活动
######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的hash
t|true|int|当前时间戳

######发送格式

	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696" \
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f" \
	-H "Content-Type: application/json" \
	-d '{"source": "5aaaac94942d79ca0b4b0f10298a0e42", "hash": "084ff558-3697-11e5-b881-00163e0019f1", "t": 1438322820}' \
	http://api.koushaoapp.com/1.0/activity/bindanonymous

##发布活动
######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的hash
t|true|int|当前时间戳

######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696" \
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f" \
	-d '{"source": "5aaaac94942d79ca0b4b0f10298a0e42", "hash": "084ff558-3697-11e5-b881-00163e0019f1", "t": 1438322820}' \
	http://api.koushaoapp.com/1.0/activity/start
	
##停止活动

######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的hash
t|true|int|当前时间戳

######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696" \
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f" \
	-d '{"source": "5aaaac94942d79ca0b4b0f10298a0e42", "hash": "084ff558-3697-11e5-b881-00163e0019f1", "t": 1438322820}' \
	http://api.koushaoapp.com/1.0/activity/stop

##获取已经发布的活动列表
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
limit|false|int|获取数量,默认10
create_time|false|int|获取比此创建时间小的活动
type|false|int|0取小于create,1取大于create_time,默认0
t|true|int|当前时间戳

######发送格式

	curl -X POST \
	-H "Content-Type: application/json" \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-d '{"source": "4db84e7a70a429786f2b29134cf533ad", "t": 1437033900}' \
	http://api.koushaoapp.com/1.0/activity/list

######成功

	{
		"error": {
			"errorno": 0,
			"msg": "获取活动成功"
		},
		"result": {
			"activity_list": [
				{
					"attr": {
						"question": []
					},
					"category": "线上",
					"coordinate": "(115,111)",
					"create_time": 1436342768,
					"detail": "<h5>detail</h5>",
					"endTime": 0,
					"hash": "3072db78-2548-11e5-b111-b8e8563b581e",
					"location": "中南海",
					"modified_time": 0,
					"owner": "",
					"poster": "https://ymr.me",
					"sig": "368187fbdbebebc09e0c1d3c9e82b87f",
					"startTime": 0,
					"status": 1,
					"title": "11111"
				}
			]
		}
	}
##活动票务设置
######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
type|true|int|`0`:实名制 `1`:非实名制
limit|true|int|每种票的购票限制,`0`不限制
form|true|array|自定义表单信息
items|false|array|自定义票务信息
t|true|int|当前时间戳
######items说明
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
amount|true|string|该类型票的数量
title|true|string|该类型票的名字
price|true|float|该类型票的单价
######请求地址
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "352d9045-2ec0-11e5-974b-b8e8563b581e", "form": ["名字是啥", "性别是啥"], "source": "c57474e84db415161738e6291a3564f9", "limit": 100, "t": 1437401768, "type": 1}' \
	http://api.koushaoapp.com/1.0/activity/ticket
	
#####成功

	{
	  "error": {
	    "errorno": 0, 
 	   "msg": "success"
 	 	}
	}
	

##活动模板设置
######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
cover|true|string|首页,模板在服务端的文件名
detail|true|string|详情页,模板在服务端的文件名
question|true|string|咨询页,模板在服务端的文件名
signin|true|string|签到页,模板在服务端的文件名
t|true|int|当前时间戳
######请求地址

	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "352d9045-2ec0-11e5-974b-b8e8563b581e", "question": "1", "cover": "1", "detail": "1", "signin": "1", "source": "95e3e0cedf9cf4ea88c2f1c0cb28d94b", "t": 1437405003}' \
	http://api.koushaoapp.com/1.0/activity/template

#####成功

	{
	  "error": {
	    "errorno": 0, 
 	   "msg": "success"
 	 	}
	}
##活动模块启用设置
######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
question|true|int|咨询模块,0不启用,1启用
signin|true|int|签到模块,0不启用,1启用
welfare|true|int|福利模块,0不启用,1启用
t|true|int|当前时间戳
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "352d9045-2ec0-11e5-974b-b8e8563b581e", "question": 1, "signin": 1, "source": "835c1e42fd06a1cfdfc4d29bff55ce7d", "t": 1437405003, "welfare": 1}' \
	http://api.koushaoapp.com/1.0/activity/module

#####成功

	{
	  "error": {
	    "errorno": 0, 
 	   "msg": "success"
 	 	}
	}


##创建福利
>创建之前会先删除之前的福利,确保只有一个

######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的唯一hash
welfare_name|true|string|福利名称
welfare_description|true|string|福利说明文字
category|true|int|1红包 2奖券 3大转盘 4公告福利(目前仅2,3)
showstatus|true|int|是否显示中奖动态,0否,1是
welfare_items|true|array|所有的奖品类型
probability|true|int|不中奖概率（大转盘作用）
t|true|int|当前时间戳
######welfare_items成员
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
name|true|string|奖券（奖品）名称
content|true|string|奖券（奖品）内容
delivery|false|int|0非验证发放，1验证发放，2快递（实物奖品）
online|true|int|0线下券(抽取时候生成) \ 1线上券(自己提供,导入)
amount|true|int|该类奖卷数量

codes|true|array|所对应的兑换码（奖品码）
######codes成员
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
code|true|string|兑换码（奖品码）

######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"welfare_items": [{"category": 0, "amount": 4, "codes": ["11111111", "22222222", "33333333", "44444444"], "name": "新会员20元现金奖券", "probability": 0.5}, {"category": 0, "amount": 2, "codes": ["55555555", "66666666"], "name": "新会员50元现金奖券", "probability": 0.3}, {"category": 0, "amount": 1, "codes": ["7777777"], "name": "新会员100元现金奖券", "probability": 0.2}], "showstatus": 1, "hash": "3072db78-2548-11e5-b111-b8e8563b581e", "welfare_description": "本次奖券仅发送给参加活动的用户,奖券的发放在活动签到后开始进行", "gettype": 1, "source": "077cbccfd9fe2d5ae676734c7587e15d", "t": 1437545652, "welfare_name": "欢淫新用户，疯狂送奖券"}' \
	http://api.koushaoapp.com/1.0/activity/welfare
	
##删除福利
>删除该活动之前创建的所有福利

######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的唯一hash
t|true|int|当前时间戳
######请求
	curl -X DELETE \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e","source": "077cbccfd9fe2d5ae676734c7587e15d", "t": 1437545652}' \
	http://api.koushaoapp.com/1.0/activity/welfare
	
##停用福利
>停用之后不可启用

######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的唯一hash
t|true|int|当前时间戳
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e","source": "077cbccfd9fe2d5ae676734c7587e15d", "t": 1437545652}' \
	http://api.koushaoapp.com/1.0/activity/welfare/stop

##福利状态
>当前福利是否停用

######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的唯一hash
t|true|int|当前时间戳
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e","source": "077cbccfd9fe2d5ae676734c7587e15d", "t": 1437545652}' \
	http://api.koushaoapp.com/1.0/activity/welfare/status
######返回参数
参数 |说明
:----------- | :-----------: |
status|福利状态  0是停用,1是启用
activity_title|福利标题
##统计福利
>奖券的使用情况统计

######参数说明
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的唯一hash
t|true|int|当前时间戳
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e","source": "077cbccfd9fe2d5ae676734c7587e15d", "t": 1437545652}' \
	http://api.koushaoapp.com/1.0/activity/welfare/analyse
#####返回参数

	{
	  "error": {
	    "errorno": 0, 
	    "msg": "success"
	  }, 
	  "result": {
	    "detail_statistics": [ //具体单个奖卷详情
	      {
	        "detail": {
	          "hasget": 0,   //单个 已经抽取、且被领取
	          "noget": 0     //单个 已经抽取、未被领取
	        }, 
	        "hasdraw": 0, 
	        "name": "名字1",  //奖券名字 
	        "nodraw": 0      //单个 未被抽取的奖券数
	      }, 
	      {
	        "detail": {
	          "hasget": 0, 
	          "noget": 0
	        }, 
	        "hasdraw": 0, 
	        "name": "名字2", 
	        "nodraw": 0
	      }
	    ], 
	    "total_statistics": { //总计奖券详情
	      "detail": {
	        "hasget": 0,   //总计 已经抽取、且被领取
	        "noget": 0     //总计 已经抽取、未被领取
	      }, 
	      "hasdraw": 0     //总计 已经抽取
	    }
	  }
	}
##福利发放（扫码发放\短信码发放）
>扫码发放是读取客户出示的二维码（包含`sig`）
短信码发放是使用8位校验码(`code`)

#####参数说明
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
verify_type|true|int|0扫码发放，1短信码发放
hash|true|string|对应活动
code_sig|false|string|扫码发放中，二维码的信息,`sig`
code|false|string|8位校验码

######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "24e027be-4336-11e5-b403-00163e0019f1", "code_sig": "164896e6a5fe4a0f93108c103cf0951a", 
	"verify_type": 0, "source": "7688b2a5d6bc27159cb251bb7c36b0e3", "t": 1439703956}' \
	http://api.koushaoapp.com/1.0/activity/welfare/verify
#####返回参数
参数 |说明
:----------- | :-----------: |
avatar|领取人头像
nickname|领取人昵称
activity_tilte|活动名称
welfare_title|福利的名称
welfare_item_title|福利项目的名称
mobile|福利领取人的手机号
type|0扫码 1短信
time|发放时间
admin|发放人

	
##福利发放统计
> 统计 验证发放,非验证发放,实物寄送

#####参数说明
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|对应活动
record_type|true|int|0全部,1非验证发放,2验证发放,3实物寄送
limit|true|int|查询限制数量，默认10
id|false|int|上次查询返回的id
type|false|int|0是取小于此id，1是取大于此id，默认最小
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "24e027be-4336-11e5-b403-00163e0019f1", "record_type": 2, 
	"source": "098470b43fb65f3f6ae4831d2f143c1b", "limit": 10, "t": 1439736503, "id": 2}' \
	http://api.koushaoapp.com/1.0/activity/welfare/verifylogs
#####返回参数
参数 |说明
:----------- | :-----------: |
admin|操作管理员名字
id|记录id
receiver|福利领取人的昵称
time|发放时间
welfare_item_title|福利项目的名称
welfare_title|福利的名称
welfare_type|发放的类型,0验证发放,1非验证发放,2实物寄送
`draw_count`|抽取数目
`verified_count`|验证发放数
#####返回

    {
      "error": {
        "errorno": 0, 
        "msg": "success"
      }, 
      "result": {
        "draw_count": 3, 
        "list": [
          {
            "admin": "操作管理员名字", 
            "id": 1, 
            "receiver": "洋柿子蛋汤", 
            "time": 1439703825, 
            "welfare_item_title": "30元现金卷", 
            "welfare_title": "欢天喜地赢大奖", 
            "welfare_type": 0
          }
        ], 
        "verified_count": 3
      }
    }
##福利发放统计-福利详情
######参数说明
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动hash
id|true|int|发放统计返回的id

 http://api.koushaoapp/1.0/activity/welfare/verifylogs/detail 
#####返回参数
参数 |说明
:----------- | :-----------: |
activity_title|活动名称
welfare_title|福利名称
welfare_item_title|福利内容
get_time|参与时间
receiver|接收账号
id|发放编号
verify_time|发放时间
welfare_item|发放人
delivery_info|快递信息(暂时没有)

##福利实物奖品列表

#####参数说明
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|对应活动
type|false|int|0是未发放,1是已经发放


######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "24e027be-4336-11e5-b403-00163e0019f1", "record_type": 2, 
	"source": "098470b43fb65f3f6ae4831d2f143c1b", "limit": 10, "t": 1439736503, "id": 2}' \
	http://api.koushaoapp.com/1.0/activity/welfare/award/list
	
#####返回参数
参数 |说明
:----------- | :-----------: |
id|详情id
welfare_name|奖品名称
receiver|接收人
time|操作时间
admin|操作人

##福利实物奖品详情

#####参数说明
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|对应活动
id|false|string|详情id


######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "24e027be-4336-11e5-b403-00163e0019f1", "id": "FL3821443257937570", 
	"source": "098470b43fb65f3f6ae4831d2f143c1b", "t": 1439736503}' \
	http://api.koushaoapp.com/1.0/activity/welfare/award/detail

#####返回参数
参数 |说明
:----------- | :-----------: |
id|详情id
welfare_name|奖品名称
receiver|接收人
time|操作时间
admin|操作人
name|收件人
phone|手机手机
address|地址
post|邮编


##确认发放

#####参数说明
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|对应活动
id|false|string|详情id
nu|true|str|快递单号
company|true|str|快递公司
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "24e027be-4336-11e5-b403-00163e0019f1", "id": "FL3821443257937570", 
	"source": "098470b43fb65f3f6ae4831d2f143c1b","t": 1439736503, "nu": "12345","company":"顺丰快递"}' \
	http://api.koushaoapp.com/1.0/activity/welfare/award/confirm

##主办方活动签到（扫描、短信码）
######参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动hash
type|true|int|类型，0是扫码，1是短信码
sig|true|string|票的sig
code|true|string|8位短信码
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"source": "37051a772a29a4e1b1aea1c20850f2d0", "code": "86015996",  "hash": "3072db78-2548-11e5-b111-b8e8563b581e",
	"sig": "368187fbdbebebc09e0c1d3c9e82b87f", "t": 1437667885}' \
	http://api.koushaoapp.com/1.0/activity/signin

#####已经被使用
    {
      "error": {
        "errorno": 323, 
        "msg": "ticket has been use"
      }, 
      "result": {
        "userinfo": {
          "name": "5", 
          "phone": "5", 
          "gender": "female", 
        }
      }
    }
      
##签到列表
######参数说明
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动hash

######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"source": "37051a772a29a4e1b1aea1c20850f2d0", "hash": "3072db78-2548-11e5-b111-b8e8563b581e", "t": 1437667885}' \
	http://api.koushaoapp.com/1.0/activity/signin/list

#####返回
参数 |说明
:----------- | :-----------: |
mobilePhone|购票/报名 账号
nickname|报名者名字
signin_admin|签到操作人
signin_time|签到时间
signin_type|0扫码 1短信 2主动
ticket_id|票号码

##签到列表-》详细信息
######参数说明
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动hash
ticket_id|true|票号码
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"source": "37051a772a29a4e1b1aea1c20850f2d0", "hash": "3072db78-2548-11e5-b111-b8e8563b581e", "t": 1437667885}' \
	http://api.koushaoapp.com/1.0/activity/signin/detail
#####返回
参数 |说明
:----------- | :-----------: |
avatar|头像地址
signup_name|签到人名字(报名表单)
signup_mobile|签到人手机号(报名表单)
gender|性别,0未知,1男,2女
activity_name|活动名称
signup_time|报名时间
signup_user|报名账号
ticket_id|报名编号
signin_type|签到方式 0扫码 1短信 2主动
signin_time|签到时间
signin_admin|签到执行操作人
custom_info|数组,自定义填写的表单信息
ticket_name|订单名称
ticket_price|订单金额
pay_channel|支付方式 0微信，1支付宝
    {
        "error": {
            "errorno": 0, 
            "msg": "success"
        }, 
        "result": {
            "activity_name": "七夕情人节", 
            "signin_admin": "我是帅哥", 
            "signin_time": 1439891154, 
            "signin_type": 1, 
            "signup_time": 1439880543, 
            "signup_user": "18679824092", 
            "ticket_id": "KS4111439880543403"
        }
    }

##获取咨询列表
######请求参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|活动的唯一hash
starttime|true|int|获取提问时间小于此时间的问题
limit|false|int|默认最新10条记录
reply_type|true|int|0是未回复,1是已经回复
t|true|int|当前时间戳
######回复参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
answer|true|string|回答的内容
question|true|string|问题的内容
user|false|string|提问人的昵称
create_time|true|int|问题创建时间
answer_time|true|int|问题回复时间
id|true|int|问题的id
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"limit": 1, "hash": "3072db78-2548-11e5-b111-b8e8563b581e", "t": 1437634685, "starttime": 1437634685, "source": "7702f55021a9ffc142584c749be0a6ca"}' \
	http://api.koushaoapp.com/1.0/question/list


#####成功返回
    {
      "error": {
        "errorno": 0, 
        "msg": "success"
      }, 
      "result": {
        "list": [
          {
          	"id":34,
            "answer": "", 
            "answer_time": 0, 
            "create_time": 1437631017, 
            "question": "问题:2", 
            "user": "猫帅"
          }
        ]
      }
    }
##回复咨询问题

######请求参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
id|true|string|问题的id
answer|true|string|回复的内容
t|true|int|当前时间戳
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"answer": "回复", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615, "id": 34}' \
	http://api.koushaoapp.com/1.0/question/reply


#####成功返回

    {
      "error": {
        "errorno": 0, 
        "msg": "success"
      }
    }
##删除回复
######请求参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
id|true|string|问题的id
del_type|true|string|0删除回复,1删除问题
t|true|int|当前时间戳
######请求
	curl -X DELETE \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"del_type": 1,id": 34,"source": "20fc6c56bf6906b213a568a0dfff538c"}' \
	http://api.koushaoapp.com/1.0/question/reply

#二维码
##生成活动签到二维码
######请求参数说明

参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
hash|true|string|对应活动
size|true|int|二维码黑色小块所占的像素点,size=1,所生成的大小是27*27
t|true|int|当前时间戳
######请求
	curl -X POST \
	-H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615, "size": 20}' \	
	http://api.koushaoapp.com/1.0/activity/qrcode
#####成功返回
	{
		"error": {
			"errorno": 0,
			"msg": "success"
		},
		"result": {
			"url": "http://image.koushaoapp.com//FsjIwORgfMPbrMFQDqLxnseOl4M0"
		}
	}

#统计数据
##我的统计
>举办了几次活动,访问人数，感兴趣人数，报名人数的统计

######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
t|true|int|当前时间戳
######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615}' \	
	http://api.koushaoapp.com/1.0/activity/qrcode
######返回

##我的金额
>金额统计的概况

######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
t|true|int|当前时间戳
######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"t": 1437638615' \	
	http://api.koushaoapp.com/1.0/analyse/moneyinfo
######返回
########返回参数
参数 |说明
:----------- | :-----------: |
applicant|当前可提现余额
cash|累计提取现金
obtain|累计获得金额
recharge|累计充值金额

  {
    "error": {
      "errorno": 0, 
      "msg": "success"
    }, 
    "result": {
      "applicant": 0, 
      "cash": 0, 
      "obtain": 0, 
      "recharge": 0
    }
  }

##我的金额-详细记录
######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
record_type|true|int|1获得、2提现、3充值
t|true|int|当前时间戳]
######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"record_type": 3, "t": 1439653077, "source": "07ff1392e4baa6909c26bea4f63ba16d"}' \	
	http://api.koushaoapp.com/1.0/analyse/moneyrecord
######返回
#######累计获得详情
########返回参数
参数 |说明
:----------- | :-----------: |
money|该活动金额
title|该活动名字
time|活动结束时间

	{
	  "error": {
	    "errorno": 0, 
	    "msg": "success"
	  }, 
	  "result": {
	    "list": [
	      {
	        "money": 0, 
	        "title": "测试活动", 
	        "time": 1442332778
	      }, 
	      {
	        "money": 0, 
	        "title": "发钱咯咯", 
	        "time": 1442332743
	      }
	    ], 
	    "record_type": 1
	  }
	}

#######累计提现详情
参数 |说明
:----------- | :-----------: |
status|0.提现审核  1.提现成功  2.提现失败
receiver|提现人账号
title|标题
money|发生金额
time|最后更新状态的时间


	{
	  "error": {
	    "errorno": 0, 
	    "msg": "success"
	  }, 
	  "result": {
	    "list": [
	      {
	        "money": 20000, 
	        "receiver": "15573489887", 
	        "status": 0, 
	        "time": 1439653077, 
	        "title": "微信-周凝"
	      }, 
	      {
	        "money": 30000, 
	        "receiver": "15573489887", 
	        "status": 1, 
	        "time": 1439653077, 
	        "title": "支付宝-周凝周凝周凝周凝周凝周凝"
	      }, 
	      {
	        "money": 40000, 
	        "receiver": "15573489887", 
	        "status": 2, 
	        "time": 1439653077, 
	        "title": "微信-周凝"
	      }
	    ], 
	    "record_type": 2
	  }
	}

#######累计充值详情
参数 |说明
:----------- | :-----------: |
welfare_name|福利名字
title|活动标题
money|充值金额
time|充值时间

    {
      "error": {
        "errorno": 0, 
        "msg": "success"
      }, 
      "result": {
        "list": [
          {
            "money": 10000, 
            "time": 1439653077, 
            "title": "我唱歌给你听，毕业了啊，的相亲大会", 
            "welfare_name": "幻听洗涤发大财"
          }, 
          {
            "money": 1000000, 
            "time": 1439653077, 
            "title": "快出门网络科技有限公司上市大喜", 
            "welfare_name": "现金抢光光"
          }
        ], 
        "record_type": 3
      }
    }

##活动主页面
>多少人看过,多少人报名

######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
t|true|int|当前时间戳
######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615, "size": 20}' \	
	http://api.koushaoapp.com/1.0/analyse/baseinfo
######返回

##浏览详情页面
>列表统计,多少人看过，多少人感兴趣。访问途径、城市分布，页面访问统计等。

######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
t|true|int|当前时间戳
######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615, "size": 20}' \	
	http://api.koushaoapp.com/1.0/analyse/visitsinfo
######返回

    {
        "result": {
            "city": {
                "常州市": 5,
                "广州市": 7,
                "其他": 90,
                "上海市": 12,
                "南昌市": 6,
                "北京市": 44
            },
            "app": {
                "weixin": 1,
                "weibo": 0,
                "other": 162,
                "QQ": 0,
                "Safari": 1
            },
            "interested": 148,
            "page": {
                "signin": {
                    "count": 2,
                    "time": 3
                },
                "question": {
                    "count": 4,
                    "time": 174
                },
                "detail": {
                    "count": 375,
                    "time": 8723
                },
                "welfare": {
                    "count": 0,
                    "time": 0
                }
            },
            "visits": 381
        },
        "error": {
            "errorno": 0,
            "msg": "success"
        }
    }

##报名详情页面
>多少人报名，收款的总数。售票价位的分布，性别的分布，年龄分布。

######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
t|true|int|当前时间戳
######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615, "size": 20}' \	
	http://api.koushaoapp.com/1.0/analyse/enrollinfo
######返回

##报名记录/售票 页面
>报名的记录列表，是否已经签到,100条记录

######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
t|true|int|当前时间戳
######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615, "size": 20}' \	
	http://api.koushaoapp.com/1.0/analyse/enrollrecord
######返回
参数 |说明
:----------- | :-----------: |
nickname|报名/购票者名字
signin|0没签到,1签到
ticket_id|报名编号
time|报名时间
    {
        "error": {
            "errorno": 0, 
            "msg": "success"
        }, 
        "result": [
            {
                "nickname": "我是帅哥", 
                "signin": 0, 
                "ticket_id": "KS6181439880295313", 
                "time": 1439880295
            }, 
            {
                "nickname": "我是帅哥", 
                "signin": 0, 
                "ticket_id": "KS4111439880543403", 
                "time": 1439880543
            }
        ]
    }
##报名详情-》报名/售票记录-》个人报名详情（售票没有）
>报名详情页面  内容分四部分
1. 性别 手机  这个是必须的
2. 公司名称 部门 职位 这三个是自定义的 可能都没有
3. 费用名称、金额  有的有 有的没有
4. 报名时间和签到状态 都有

######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
ticket_id|true|string|票id
hash|true|string|活动hash
t|true|int|当前时间戳

######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"ticket_id": "KS9621440425567167","hash": "3072db78-2548-11e5-b111-b8e8563b581e", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615}' \	
	http://api.koushaoapp.com/1.0/analyse/enrollrecord/detail
######返回
参数 |说明
:----------- | :-----------: |
gender|性别
mobilePhone|手机号
nickname|昵称
fee_name|费用名称
fee_price|费用价格
bsign|0没签到，1签到了
signup_time|签到时间

	{
	    "error": {
	        "errorno": 0, 
	        "msg": "success"
	    }, 
	    "result": {
	        "bsign": 1, 
	        "gender": "female", 
	        "mobilePhone": "13247804813", 
	        "nickname": "猫大王2", 
	        "signup_time": 1440425567, 
	        "custom_info":{
	        	"自定义1": "哦哦1", 
	        	"自定义2": "哦哦2"
	        }
	        
	    }
	}


#钱
##我要提现
>发起提现请求

######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
account|true|string|提现的支付宝账号
name|true|string|真实姓名
money|true|float|提现金额xx.xx
code|true|string|手机验证码
pic_1|true|string|身份证证明照片
pic_2|false|string|
t|true|int|当前时间戳
######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"hash": "3072db78-2548-11e5-b111-b8e8563b581e", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615, "size": 20}' \	
	http://api.koushaoapp.com/1.0/money/drawcash
######返回


##意见反馈
>用户提交反馈

######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
content|true|string|反馈内容
contact|true|string|联系方式
t|true|int|当前时间戳

######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"content": "内容", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615, "contact": "13213878999"}' \	
	http://api.koushaoapp.com/1.0/feedback
	
	
##获取网络图片
>分类1.2.3分别对应横、竖、方，三种类型

######参数
参数 | 必选 |类型|说明
:----------- | :-----------: | -----------:| -----------:
type|true|int|1.2.3分别对应横、竖、方，三种类型
t|true|int|当前时间戳

######请求
    curl -X POST \
    -H "X-Koushao-Session-Token: b18ecdcf26b1d5efd9336f860a13c696"
	-H "X-Koushao-Username: fe8e72eac162d2576bf2e948072f340f"
	-H "Content-Type: application/json" \
	-d '{"type": "1", "source": "20fc6c56bf6906b213a568a0dfff538c", "t": 1437638615}' \	
	http://api.koushaoapp.com/1.0/picture
#错误代码

代码 | 说明|
:-----------|:-----------: |
0| 成功
1| 服务器内部错误
2| 参数不能为空
3| 来源校验失败
4| 时间校验错误
200| 没有提供用户名或者用户名为空
201| 没有提供密码或者密码为空
202| 用户名已经被占用
203| 电子邮箱地址已经被占用
204| 没有提供电子邮箱地址
205| 找不到电子邮箱地址对应的用户
206| 没有提供session，无法修改用户信息
207| 只能通过注册创建用户，不允许第三方登录
208| 第三方帐号已经绑定到一个用户，不可绑定到其他用户
210| 用户名和密码不匹配
211| 找不到用户
212| 请提供手机号码
213| 手机号码对应的用户不存在
214| 手机号码已经被注册
215| 未验证的手机号码
216| 未验证的邮箱地址
217| 无效的access token
218| 不是有效的手机号
219| 该子账户已经存在
250| 连接的第三方账户没有返回用户唯一标示id
251| 无效的账户连接，一般是因为access token非法引起的。
253| token校验失败
254| token不存在(过期)
255| 参数校验失败
310| 创建活动失败
311| 不存在该活动
312| 修改活动失败
313| 活动已经结束
314| 活动进行中,不允许修改
315| 活动不是匿名活动
319| 咨询已经被回复
320| 该咨询不存在
321| 该订单不存在
322| 该订单未支付
323| 该订单的码已经签到
330| 该短信码不存在
331| 短信码已经被使用
332| 短信码没有被领取不能使用
333| 没有开启福利模块
340| 余额不足
403| 操作被禁止
502| 服务器维护中
503| 超过流量访问限制
601| 发送短信过于频繁
602| 发送短信验证码失败
603| 无效的短信验证码，通常是不匹配或者过期。
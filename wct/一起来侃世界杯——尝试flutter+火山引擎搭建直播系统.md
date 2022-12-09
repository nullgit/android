https://www.yuque.com/nullyuque/mkmaub/nhd91rc3nouom40n

## 简介
项目地址：[https://gitee.com/Feel_Again/android/tree/master/wct](https://gitee.com/Feel_Again/android/tree/master/wct) 或 [https://github.com/nullgit/android/tree/master/wct](https://github.com/nullgit/android/tree/master/wct)
安装包下载地址：[https://tmp-yunzen.oss-cn-shanghai.aliyuncs.com/%E7%8E%8B%E8%BF%90%E6%B3%BD-%E4%B8%80%E8%B5%B7%E6%9D%A5%E4%BE%83%E4%B8%96%E7%95%8C%E6%9D%AF.apk](https://tmp-yunzen.oss-cn-shanghai.aliyuncs.com/%E7%8E%8B%E8%BF%90%E6%B3%BD-%E4%B8%80%E8%B5%B7%E6%9D%A5%E4%BE%83%E4%B8%96%E7%95%8C%E6%9D%AF.apk)

使用的框架是Flutter，原因是相中了它跨平台的特点
> Flutter是谷歌公司开发的一款开源、免费的UI框架，可以让我们快速的在Android和iOS上构建高质量App。它最大的特点就是跨平台，以及高性能。目前 Flutter 已经支持 iOS、Android、Web、Windows、macOS、Linux等。


实现的基本功能：

- 用户登录
   - 输入房间号和密码后进入房间
- 音视频聊天
   - 支持同一房间内最多8人音视频聊天，每个人可选择是否开启摄像头、麦克风
- 文字聊天
   - 房间内的人可发送文本消息，并让其他人看到；实现了消息列表，展示房间内所有人发出的消息，支持滚动查看历史消息，收到新消息后自动在消息列表上展示
   - 全屏模式下，长时间没人聊天时，聊天列表消失
- 视频播放
   - 从手机里选择一个视频并播放，让房间内其他人可以看到；当开始播放视频时，摄像头停止采集，只推流本地视频❌
   - 进入房间后，直接有足球视频实时播放⭕
- 全屏模式
   - 沉浸式状态栏体验
## 展示
### 首页登录

- 获取拍摄照片和录制视频+录制音频的权限 

![0获取权限.jpg](https://cdn.nlark.com/yuque/0/2022/jpeg/22195492/1670557203509-e3dc3b89-1168-4a4c-895f-48c12cf3d9e7.jpeg#averageHue=%23949494&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=drop&id=u5eddd033&margin=%5Bobject%20Object%5D&name=0%E8%8E%B7%E5%8F%96%E6%9D%83%E9%99%90.jpg&originHeight=1600&originWidth=2560&originalType=binary&ratio=1&rotation=0&showTitle=false&size=245131&status=done&style=none&taskId=ua46eac56-907c-4caa-9ead-1d8ef6beb0a&title=)
可以改进为进入房间前再获取权限

- 进入到“加入房间页”

![Screenshot_20221209_105101_com.example.wct.jpg](https://cdn.nlark.com/yuque/0/2022/jpeg/22195492/1670557203562-efdade0e-9562-4fa9-ba00-fb516d78c648.jpeg#averageHue=%23f7f7f7&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=drop&id=ua39dfca5&margin=%5Bobject%20Object%5D&name=Screenshot_20221209_105101_com.example.wct.jpg&originHeight=1600&originWidth=2560&originalType=binary&ratio=1&rotation=0&showTitle=false&size=218238&status=done&style=none&taskId=u77865492-ba32-421a-821e-45fbc4d5bb2&title=)
首页本来想做成竖屏的，但是Flutter框架的横竖屏切换功能有bug，所以都是横屏的。

- 可以通过下面一排的按钮来选择进入房间前是否开视频等

![Screenshot_20221209_105239_com.example.wct.jpg](https://cdn.nlark.com/yuque/0/2022/jpeg/22195492/1670557203826-f75fa766-c87e-481e-948d-5797f9c69b34.jpeg#averageHue=%235b564a&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=drop&id=u418d85b2&margin=%5Bobject%20Object%5D&name=Screenshot_20221209_105239_com.example.wct.jpg&originHeight=1600&originWidth=2560&originalType=binary&ratio=1&rotation=0&showTitle=false&size=546376&status=done&style=none&taskId=u32ceb160-eb89-48f6-ac94-3c8a18f89ac&title=)

- 首行展示了用户的头像和昵称，头像和昵称都可以更改。

![Screenshot_20221209_105344_com.example.wct.jpg](https://cdn.nlark.com/yuque/0/2022/jpeg/22195492/1670557203862-451c139f-2045-4b6c-a7a1-d9c3b8413152.jpeg#averageHue=%236b6b6b&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=drop&id=u2ac2ea2b&margin=%5Bobject%20Object%5D&name=Screenshot_20221209_105344_com.example.wct.jpg&originHeight=1600&originWidth=2560&originalType=binary&ratio=1&rotation=0&showTitle=false&size=354934&status=done&style=none&taskId=u67ee34ad-9f02-47fd-b842-58be73ee101&title=)
输入房间号和密码后即可进入房间，密码默认就是房间号。。
目前1、2、3、4号房间都有频道~

### 进入房间

- 左边是视频播放频道和一排控制按钮，右边是视频或聊天，默认是视频卡片

![Screenshot_20221209_112830_com.example.wct.jpg](https://cdn.nlark.com/yuque/0/2022/jpeg/22195492/1670557205215-4752b046-fd76-4332-ba40-9aaa159b4f22.jpeg#averageHue=%237ea052&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=drop&id=ud0584a79&margin=%5Bobject%20Object%5D&name=Screenshot_20221209_112830_com.example.wct.jpg&originHeight=1600&originWidth=2560&originalType=binary&ratio=1&rotation=0&showTitle=false&size=892640&status=done&style=none&taskId=u16551ad6-c49b-4c1d-b0d9-927d0de7089&title=)
如果用户关闭了远程视频，默认展示空白，可以优化为展示头像；远程视频下是用户id，优化为展示用户昵称。

- 点击聊天会展示历史聊天列表；点击“发出聊天”，输入聊天内容，确认后会发出聊天

![Screenshot_20221209_112947_com.example.wct.jpg](https://cdn.nlark.com/yuque/0/2022/jpeg/22195492/1670557205135-27a0ca47-4d13-4c62-9074-ad73e4a422cc.jpeg#averageHue=%23686767&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=drop&id=u34c85ffa&margin=%5Bobject%20Object%5D&name=Screenshot_20221209_112947_com.example.wct.jpg&originHeight=1600&originWidth=2560&originalType=binary&ratio=1&rotation=0&showTitle=false&size=469078&status=done&style=none&taskId=udf62b68f-bbb3-4767-ab2f-2fdccd97028&title=)
发出聊天的Dialog在小屏幕上展示不佳，输入法会把输入框挤掉。。
![Screenshot_20221209_112954_com.example.wct.jpg](https://cdn.nlark.com/yuque/0/2022/jpeg/22195492/1670557205360-aa6be66e-4d33-4460-9b6c-bb826690989c.jpeg#averageHue=%2373914d&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=drop&id=u4ca12326&margin=%5Bobject%20Object%5D&name=Screenshot_20221209_112954_com.example.wct.jpg&originHeight=1600&originWidth=2560&originalType=binary&ratio=1&rotation=0&showTitle=false&size=850584&status=done&style=none&taskId=u9fe52ad1-b3a8-4829-a0f2-92424effe36&title=)
聊天列表的uid也应该变为用户昵称，而且可以加些气泡等样式。
### 全屏模式

- 点击“全屏”进入全屏模式，此时系统状态栏和底栏隐藏；10s内的聊天记录会展示在左上角

![Screenshot_20221209_113107_com.example.wct.jpg](https://cdn.nlark.com/yuque/0/2022/jpeg/22195492/1670557206512-a76fffc2-1292-4e1f-9505-1323213d7009.jpeg#averageHue=%23678d47&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=drop&id=u368b0d2f&margin=%5Bobject%20Object%5D&name=Screenshot_20221209_113107_com.example.wct.jpg&originHeight=1600&originWidth=2560&originalType=binary&ratio=1&rotation=0&showTitle=false&size=798474&status=done&style=none&taskId=u4f3f443d-87aa-48df-be7f-850fbc938e7&title=)
![Screenshot_20221209_113111_com.example.wct.jpg](https://cdn.nlark.com/yuque/0/2022/jpeg/22195492/1670557207477-8ce8f859-a81a-4c25-80c7-69b06ff349e0.jpeg#averageHue=%232c6790&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=drop&id=u5b1feef3&margin=%5Bobject%20Object%5D&name=Screenshot_20221209_113111_com.example.wct.jpg&originHeight=1600&originWidth=2560&originalType=binary&ratio=1&rotation=0&showTitle=false&size=1095201&status=done&style=none&taskId=uc67452c4-a6a9-4579-b4ee-a3e8641e818&title=)
消失的时候可以添加动画
点击左上角的返回按钮才会返回到刚刚全屏前的页面，按系统返回键会返回到主页。。
## 设计
### 服务端以及与客户端的交互
服务端使用的框架是SpringBoot，语言是Kotlin（主要）+Java（生成token的代码），使用的中间件是数据库MySQL。
MVC模式：
![image.png](https://cdn.nlark.com/yuque/0/2022/png/22195492/1670560192134-089ba06e-d745-4f53-b996-3ceb649a5d14.png#averageHue=%23313234&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=689&id=u3f080829&margin=%5Bobject%20Object%5D&name=image.png&originHeight=1516&originWidth=418&originalType=binary&ratio=1&rotation=0&showTitle=false&size=116901&status=done&style=none&taskId=u3a40dcf9-cef2-4449-b6eb-3018c99b7c6&title=&width=189.999995881861)
服务端提供的功能：

- 登录和进入房间
- 聊天
- 存储视频（阿里云）
- 实时音视频（火山引擎）

登录和进入房间：

```plantuml
@startuml
note over client : 刚刚登录，没有uid
client -> server : /login/createUser
server -> client : uid和初始随机名字

note over client : 设置用户名
client -> server : /setting/renameUser
server -> client

note over client : 填写房间号
client -> server : /login/joinRoom
note over server : 房间号没有，就创建房间
server -> client : 房间号、进入这个房间的token

@enduml
```

进入房间后：
```plantuml
@startuml
' note over client : 刚刚登录，没有uid
client -> Vol : 带token等信息进入房间
Vol -> client :

client -> AliyunOSS : 视频地址
AliyunOSS -> client : 视频

client -> server : /chat/list
server -> client : 该房间所有的聊天信息
note over client : 每隔3秒获取一次聊天信息，并清除10s前的信息

client -> server : /chat/send
server -> client
@enduml
```
聊天服务端的一种更好的方案：客户端进入房间后，与服务端建立websocket；消息来后服务端通过websocket推送给客户端。
我在使用火山引擎的屏幕分享功能的时候遇到的错误:(，

所以直播功能我采用了其他的思路。视频的起始播放时间，根据当前系统时间计算而来。达成的效果是只要用户的时间是一致的，就能看到相同的画面。
### 页面
Flutter的写法类似HTML+CSS的组合，即结构和样式写在了一起；一个Widget就是一个组件
![image.png](https://cdn.nlark.com/yuque/0/2022/png/22195492/1670559306604-fa403cec-efb5-4447-9bd0-52a9f896e909.png#averageHue=%2320201f&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=288&id=u2780d357&margin=%5Bobject%20Object%5D&name=image.png&originHeight=634&originWidth=1548&originalType=binary&ratio=1&rotation=0&showTitle=false&size=108117&status=done&style=none&taskId=ue24c364c-5fbc-45b6-bae8-e4af4f61ec8&title=&width=703.6363483854565)
容易形成很多层的嵌套。。比如想要居中要用`Center`包裹Widget，鄙人更喜欢将样式作为设置项
所以拆成了很多方法：
![image.png](https://cdn.nlark.com/yuque/0/2022/png/22195492/1670559759285-ffc814fd-983e-4b27-b55e-a98b4cf2a746.png#averageHue=%23383839&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=221&id=u8f72b645&margin=%5Bobject%20Object%5D&name=image.png&originHeight=486&originWidth=760&originalType=binary&ratio=1&rotation=0&showTitle=false&size=104822&status=done&style=none&taskId=u9cb7ba43-3a88-486a-b669-5779421effb&title=&width=345.45453796702)

使用了一个状态管理库GetX：
![image.png](https://cdn.nlark.com/yuque/0/2022/png/22195492/1670559656477-6a86bdbf-b4e6-4c37-a47e-623e14da63fa.png#averageHue=%2321201f&clientId=u7325ab73-4f94-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=65&id=ub4907cc2&margin=%5Bobject%20Object%5D&name=image.png&originHeight=144&originWidth=962&originalType=binary&ratio=1&rotation=0&showTitle=false&size=25518&status=done&style=none&taskId=u10e595b3-397b-4638-adec-b1447294570&title=&width=437.27271779509636)
> GetX不仅有状态管理，还有路由管理、主题管理、网络请求、数据验证等功能，功能强大并且高性能


Flutter适用于：

- 需要跨端的、小型的App
- SDK支持Flutter

不然还需要写很多原生开发代码来适配，最后并不比直接原生开发省心省力。。
## 总结与展望
### 收获
尝试使用跨平台移动端框架Flutter和火山引擎搭建了一个简单的实时音视频+文字聊天+直播系统，在编写Flutter代码过程中从另一个视角体会客户端开发。
要点：

- 学习Dart语言和Flutter框架
- GetX状态管理、路由、Dialog等组件的使用
- logger打日志、vedio_player库播放视频、get_storage 本地存储、camera 调用摄像机、auto_orientation 旋转屏幕、image_picker 选取图片
- Kotlin写SpringBoot
### 展望
解决使用Flutter框架的问题：横竖屏切换、屏幕分享等
新功能：发送动画表情
优化页面：输入弹窗不被输入法挤掉、聊天列表添加气泡、状态变化添加动画等
发掘火山引擎的其他功能：美颜等
将代码打包应用于其他平台：IOS、**Web**、PC等（看起来Web端能通过浏览器屏蔽掉很多平台差异，而且火山引擎支持更好）

由于要写毕业论文且没多大用处就不做了。。


/// appId 使用SDK前需要为自己的应用申请一个AppId，详情参见: https://www.volcengine.com/docs/6348/69865
String appId = '635511442adebe01979a1fc2';

/// token 加入房间的时候需要使用token完成鉴权，详情参见: https://www.volcengine.com/docs/6348/70121
String token = '001635511442adebe01979a1fc2PAAl5CgDgRFVYwFMXmMDAHJpZAMAdWlkBgAAAAFMXmMBAAFMXmMCAAFMXmMDAAFMXmMEAAFMXmMFAAFMXmMgAFCBA006/tL5FMgGii2LP5gMNNWJGQHaMIycgx9fqF96';

/// inputRegexp SDK 对房间名、用户名的限制是：非空且最大长度不超过128位的数字、大小写字母、@ . _ -
String inputRegexp = r'^[a-zA-Z0-9@._-]{1,128}$';

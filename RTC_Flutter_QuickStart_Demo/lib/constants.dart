/// appId 使用SDK前需要为自己的应用申请一个AppId，详情参见: https://www.volcengine.com/docs/6348/69865
String appId = '634ab9922d98950165aefa4d';

/// token 加入房间的时候需要使用token完成鉴权，详情参见: https://www.volcengine.com/docs/6348/70121
String token = '001634ab9922d98950165aefa4dPADpcJwC18BKY1f7U2MDADEyMwMAMTIzBgAAAFf7U2MBAFf7U2MCAFf7U2MDAFf7U2MEAFf7U2MFAFf7U2MgANnSgj9g5IQYtgLrxVHacaSX8WlSd25UY3XYi1UU7YaR';

/// inputRegexp SDK 对房间名、用户名的限制是：非空且最大长度不超过128位的数字、大小写字母、@ . _ -
String inputRegexp = r'^[a-zA-Z0-9@._-]{1,128}$';

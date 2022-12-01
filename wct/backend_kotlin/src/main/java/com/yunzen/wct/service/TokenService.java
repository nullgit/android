/*
 * Ant Group
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.yunzen.wct.service;

import com.yunzen.wct.model.AccessToken;
import com.yunzen.wct.util.Utils;
import org.springframework.stereotype.Service;

/**
 * @author fanque
 * @version TokenService.java, v 0.1 2022年10月25日 10:16 fanque
 */
@Service
public class TokenService {

    public String getToken(String rid, String uid) {
        AccessToken token = new AccessToken("635511442adebe01979a1fc2", "995a9dd571c1486fa3286127fc318d4e", rid, uid);
        token.ExpireTime(Utils.getTimestamp() + 36000); // 10小时过期
        token.AddPrivilege(AccessToken.Privileges.PrivSubscribeStream, Utils.getTimestamp() + 36000);
        token.AddPrivilege(AccessToken.Privileges.PrivPublishStream, Utils.getTimestamp() + 36000);
        String s = token.Serialize();
        // AccessToken t = AccessToken.Parse(s);
        // System.out.println(t.Verify("app key"));
        return s;
    }

}
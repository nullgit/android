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
        AccessToken token = new AccessToken("634ab9922d98950165aefa4d", "e214cf178f894c1f886a8a901fadf2e9", rid, uid);
        token.ExpireTime(Utils.getTimestamp() + 36000);
        token.AddPrivilege(AccessToken.Privileges.PrivSubscribeStream, 0);
        token.AddPrivilege(AccessToken.Privileges.PrivPublishStream, Utils.getTimestamp() + 36000);
        String s = token.Serialize();
        // AccessToken t = AccessToken.Parse(s);
        // System.out.println(t.Verify("app key"));
        return s;
    }

}
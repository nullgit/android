/*
 * Ant Group
 * Copyright (c) 2004-2022 All Rights Reserved.
 */
package com.yunzen.backend.service;

import com.yunzen.backend.model.AccessToken;
import com.yunzen.backend.util.Utils;
import org.springframework.stereotype.Service;

/**
 * @author fanque
 * @version TokenService.java, v 0.1 2022年10月23日 18:54 fanque
 */
@Service
public class TokenService {

    public static void main(String[] args) {
        System.out.println(new TokenService().getToken());
    }

    public String getToken() {
        AccessToken token = new AccessToken("123456781234567812345678", "app key", "new room", "new user id");
        token.ExpireTime(Utils.getTimestamp() + 3600);
        token.AddPrivilege(AccessToken.Privileges.PrivSubscribeStream, 0);
        token.AddPrivilege(AccessToken.Privileges.PrivPublishStream, Utils.getTimestamp() + 3600);


        String s = token.Serialize();
        System.out.println(s);

        System.out.println(token);

        AccessToken t = AccessToken.Parse(s);
        System.out.println(t);

        System.out.println(t.Verify("app key"));

        return s;
    }
}

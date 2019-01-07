public with sharing class CortellisApi {

    public class Authv2TokenResponse {
        public String realm { get; set; }
        public String nonce { get; set; }
    }

    public static Authv2TokenResponse newAuthv2TokenResponse(HttpResponse res) {
        
        // Initialize the more practical API response
        Authv2TokenResponse apiRes = new Authv2TokenResponse();

        // Read the header info
        String wwwAuthenticateHeader =
                res.getHeader(HttpUtil.WWW_AUTHENTICATE_HEADER);
        
        // Find the realm
        apiRes.realm = HttpUtil.getDigestHeaderValue(
            wwwAuthenticateHeader,
            'realm'
        );

        // Find the nonce
        apiRes.nonce = HttpUtil.getDigestHeaderValue(
            wwwAuthenticateHeader,
            'nonce'
        );

        // Return the API response
        return apiRes;
    }
}

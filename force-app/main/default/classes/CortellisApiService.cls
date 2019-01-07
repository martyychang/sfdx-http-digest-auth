public with sharing class CortellisApiService {

    public static final String AUTHV2_TOKEN_PATH =
            '/api-ws/ws/rs/auth-v2/token';

    public static final String DEFAULT_BASE_URL = 'https://api.cortellis.com';

    private String apiAccountName { get; set; }

    private String apiKey { get; set; }

    private String baseUrl { get; set; }

    /**
     * @param apiAccountName
     *            The API Account Name received from Cortellis Labs
     *
     * @param apiKey
     *            The API Key received from Cortellis Labs
     */
    public CortellisApiService(String apiAccountName, String apiKey) {
        this.apiAccountName = apiAccountName;
        this.apiKey = apiKey;
        this.baseUrl = DEFAULT_BASE_URL;
    }

    public CortellisApi.Authv2TokenResponse authorize() {

        // Make an empty call to get the realm and nonce
        CortellisApi.Authv2TokenResponse firstApiRes = this.authv2Token();

        // Return the second call which should have the token
        return this.authv2Token(
            firstApiRes.realm,
            firstApiRes.nonce
        );
    }

    public CortellisApi.Authv2TokenResponse authv2Token() {

        // Construct the HttpRequest
        HttpRequest req = new HttpRequest();
        req.setMethod(HttpUtil.GET_METHOD);
        req.setEndpoint(this.baseUrl + AUTHV2_TOKEN_PATH);

        // Send the request
        HttpResponse res = new Http().send(req);

        // Assume we will get an HTTP 401 response with the realm and nonce
        System.assertEquals(401, res.getStatusCode());

        // Return the API response
        CortellisApi.Authv2TokenResponse apiRes =
                CortellisApi.newAuthv2TokenResponse(res);
        
        return apiRes;
    }

    public CortellisApi.Authv2TokenResponse authv2Token(
        String realm,
        String nonce
    ) {

        // Construct the request
        HttpRequest req = new HttpRequest();
        req.setMethod(HttpUtil.GET_METHOD);
        req.setEndpoint(this.baseUrl + AUTHV2_TOKEN_PATH);

        // Add the authorization header
        req.setHeader(
            HttpUtil.AUTHORIZATION_HEADER,
            HttpDigestUtil.newAuthorizationHeader(
                HttpDigestUtil.getResponse(
                    this.apiAccountName,
                    realm,
                    this.apiKey,
                    HttpUtil.GET_METHOD,
                    AUTHV2_TOKEN_PATH,
                    nonce
                ),
                this.apiAccountName,
                realm,
                AUTHV2_TOKEN_PATH,
                nonce,
                HttpDigestUtil.MD5_ALGORITHM
            )
        );

        // Send the request
        HttpResponse res = new Http().send(req);

        // Return the API response
        CortellisApi.Authv2TokenResponse apiRes =
                CortellisApi.newAuthv2TokenResponse(res);
        
        return apiRes;
    }

    public static CortellisApiService getInstance(
        String apiAccountName,
        String apiKey
    ) {
        return new CortellisApiService(apiAccountName, apiKey);
    }
}

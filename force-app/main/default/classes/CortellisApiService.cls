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
        
        System.debug('apiRes: ' + apiRes);
        return apiRes;
    }

    public static CortellisApiService getInstance(
        String apiAccountName,
        String apiKey
    ) {
        return new CortellisApiService(apiAccountName, apiKey);
    }
}

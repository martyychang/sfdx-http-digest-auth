public with sharing class CortellisApi {

    public class Authv2TokenResponse {
        public Datetime expires { get; set; }
        public String nonce { get; set; }
        public String realm { get; set; }
        public String token { get; set; }
    }

    public static Authv2TokenResponse newAuthv2TokenResponse(HttpResponse res) {
        
        // Initialize the more practical API response
        Authv2TokenResponse apiRes = new Authv2TokenResponse();

        // Parse the response based on the HTTP status code
        if (res.getStatusCode() == 401) {

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
        }
        else if (res.getStatusCode() == 200) {

            // Assume the response came back as XML content
            Dom.Document doc = new Dom.Document();
            doc.load(res.getBody());

            // Get a handle on the root for convenience
            Dom.XmlNode root = doc.getRootElement();

            // Read the expires element
            apiRes.expires = Datetime.valueOf(
                root.getChildElement(
                    'expires',
                    null
                ).getText().replace('T', ' ')
            );

            // Read the token element
            apiRes.token = root.getChildElement('token', null).getText();
        }
        else {
            /* TODO: Handle unexpected error */ 
        }

        // Return the API response
        return apiRes;
    }
}
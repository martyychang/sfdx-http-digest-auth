public class HttpDigestUtil {
    
    public static String MD5_ALGORITHM = 'MD5';
    
    public static String getHa1(
        String username,
        String realm,
        String password
    ) {
        String inputString = username + ':' + realm + ':' + password;
        Blob inputBlob = Blob.valueOf(inputString);
        Blob ha1Blob = Crypto.generateDigest(
            MD5_ALGORITHM,
            inputBlob
        );
        
        //return ha1Blob.toString();
        return EncodingUtil.convertToHex(ha1Blob);
    }
    
    public static String getHa2(
        String method,
        String digestUri
    ) {
        String inputString = method + ':' + digestUri;
        Blob inputBlob = Blob.valueOf(inputString);
        Blob ha2Blob = Crypto.generateDigest(
            MD5_ALGORITHM,
            inputBlob
        );
        
        //return ha2Blob.toString();
        return EncodingUtil.convertToHex(ha2Blob);
    }
    
    public static String getResponse(
        String username,
        String realm,
        String password,
        String method,
        String digestUri,
        String nonce
    ) {
        
        // Get the HA1
        String ha1 = getHa1(username, realm, password);
        
        // Get the HA2
        String ha2 = getHa2(method, digestUri);
        
        // Construct the blob
        String responseContentString = ha1 + ':' + nonce + ':' + ha2;
        Blob responseContentBlob = Blob.valueOf(responseContentString);
        Blob responseBlob = Crypto.generateDigest(
            MD5_ALGORITHM,
            responseContentBlob
        );
        
        //return responseBlob.toString();
        return EncodingUtil.convertToHex(responseBlob);
    }

    public static String newAuthorizationHeader(
        String response,
        String username,
        String realm,
        String uri,
        String nonce,
        String algorithm
    ) {

        // Define the list of items to join
        List<String> items = new List<String> {
            'Digest',
            'response="' + response + '"',
            'username="' + username + '"',
            'realm="' + realm + '"',
            'uri="' + uri + '"',
            'nonce="' + nonce + '"',
            'algorithm="' + algorithm + '"'
        };

        // Return the concatenated list of items
        return String.join(items, ' ');
    }
}
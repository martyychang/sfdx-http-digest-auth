public class HttpUtil {

    public static final String AUTHORIZATION_HEADER = 'Authorization';

    public static final String GET_METHOD = 'GET';

    public static final String WWW_AUTHENTICATE_HEADER = 'WWW-Authenticate';

    public static String getDigestHeaderValue(String headerValue, String name) {
        
        // Construct the pattern and matcher
        Pattern namePattern = Pattern.compile(name + '="(.*?)"');
        Matcher nameMatcher = namePattern.matcher(headerValue);

        // Return the found value or null otherwise
        return nameMatcher.find() ? nameMatcher.group(1) : null;
    }
}
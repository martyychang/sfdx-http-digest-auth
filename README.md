# SFDX  App

## Dev, Build and Test

Create a new scratch org and push the source from this repo to the org

### Sample token in XML response body

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<tokenOutput>
    <expires>2019-01-07T06:05:28.496Z</expires>
    <token>10d8ee93-5627-419c-805e-a66695d77360</token>
</tokenOutput>
```

### Sample Apex script to test the API service

```java
String apiAccountName = 'your API account name';
String apiKey = 'your API key';

CortellisApiService theApi =
    CortellisApiService.getInstance(apiAccountName, apiKey);

CortellisApi.Authv2TokenResponse firstApiRes = theApi.authv2Token();

CortellisApi.Authv2TokenResponse secondApiRes = theApi.authv2Token(
    firstApiRes.realm,
    firstApiRes.nonce
);
```

## Resources


## Description of Files and Directories


## Issues



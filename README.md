![CocOAuth_Logo_262x2632](http://cocoauth.marko-seifert.de/presskit/CocOAuth_Logo_262x262.png)


#{in progress} CocOAuth#

CocOAuth is an OAuth2 frameworks for iOS written in Swift 2.0.


- Security
- Enterprise
- Easy to use

## Usage ##

### Integration ###

- CocoaPods

```
pod 'CocOAuth', :git => 'https://github.com/CocOAuth/CocOAuth.git', :branch => 'development'
or file based
pod 'CocOAuth', :path => '../CocOAuth'
```
- Import
```swift
import CocOAuth
```

### Configuration ###
```swift
let conf = OAuth2Config(
	tokenURL: NSURL(string:"<YOUR OAuth2 Identity Provider>")!, 
	clientID: "<YOUR_CLIENT_ID>", 
	clientSecret: "<YOUR_CLIENT_SECRET>")

let authenticator = Authenticator(config: config)

```
### Authentication ###
```swift
@IBAction func login() {
    
    authenticator.authenticateWithUsername(username, password: password) {success, errorMessage in
      if(success){
        self.message.text = "success"
      }else{
        self.message.text = errorMessage
      }
    }
}
```
### Retrive the Access Token ###

### User Info ###

### Invalidate the Token ###

### Sign off ###

### Persistence ###

### Notification ###

### Error handling ###

OAuth 2 specific Error Types 
https://tools.ietf.org/html/rfc6749#section-5.2

Error | Description | Mapping
------|------------ |--------
invalid_request | The request is missing a required parameter, includes an unsupported parameter value (other than grant type), repeats a parameter, includes multiple credentials,utilizes more than one mechanism for authenticating the client, or is otherwise malformed.|
invalid_client|Client authentication failed (e.g., unknown client, no client authentication included, or unsupported authentication method). The authorization server MAY return an HTTP 401 (Unauthorized) status code to indicate which HTTP authentication schemes are supported. If the client attempted to authenticate via the "Authorization" request header field, the authorization server MUST respond with an HTTP 401 (Unauthorized) status code and include the "WWW-Authenticate" response header field matching the authentication scheme used by the client.|
invalid_callback|The redirect-uri sent from the client to the server is not valid.|
invalid_grant|The provided authorization grant (e.g., authorization code, resource owner credentials) or refresh token is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.|
unauthorized_client|The authenticated client is not authorized to use this authorization grant type.|
unsupported_grant_type|The authorization grant type is not supported by the authorization server.|
invalid_scope|The requested scope is invalid, unknown, malformed, or exceeds the scope granted by the resource owner.|
access_denied|The resource owner or authorization server denied the request.|
unsupported_response_type|The authorization server does not support obtaining an authorization code using this method.|
server_error|The authorization server encountered an unexpected condition that prevented it from fulfilling the request. (This error code is needed because a 500 Internal Server Error HTTP status code cannot be returned to the client via an HTTP redirect.)|
temporarily_unavailable|The authorization server is currently unable to handle the request due to a temporary overloading or maintenance of the server. (This error code is needed because a 503 Service Unavailable HTTP status code cannot be returned to the client via an HTTP redirect.)|

## Security considerations ##

## Licence ##

This code is released under the [_Apache 2.0 license_](LICENSE).


[sample]: https://github.com/p2/OAuth2App
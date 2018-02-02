![CocOAuth_Logo_262x2632](http://cocoauth.marko-seifert.de/presskit/CocOAuth_Logo_262x262.png)


# {in progress} CocOAuth #

CocOAuth is an OAuth2 frameworks for iOS written in Swift 4.0.

[![Build Status](https://www.bitrise.io/app/0ed7d6755181ac63/status.svg?token=qYQIga23cV3OqMQiZyQ5qQ&branch=master)](https://www.bitrise.io/app/0ed7d6755181ac63)
[![Badge w/ Platform](https://img.shields.io/cocoapods/v/CocOAuth.svg?style=flat)](https://cocoadocs.org/docsets/NSStringMask)

- Security
- Enterprise
- Easy to use

## Usage ##

### Integration ###

- CocoaPods

```
pod 'CocOAuth', '~> 0.1.4'
```
### The main concept: The Authenticator ###
An Authenticator encapsulates one OAuth2 identity. This means one user or device in the context of one tenant.
You can create as many authenticators you want. We are using this in an Identity Card App. Each Identity Card has its own authenticator. With own OAuth2 Server or tenant on a shared platform.

![Authenticator Big Picture](/BigPicture.png?raw=true)


### Configuration ###

Before you make any authentication request using the CocOAuth library in your app, you will need to configure it.

```swift
let config = OAuth2Config(
  tokenURL: URL(string: <YOUR OAuth2 Identity Provider Token URL>)!, 
  clientID: <YOUR_CLIENT_ID>, 
  clientSecret: <YOUR_CLIENT_SECRET>)

let authenticator = Authenticator(config: config)

```
You can create and configure as many authenticators you want. We are using this in an Identity Card App. Each Identity Card has its own authenticator. With own OAuth2 Server or tenant on a shared platform.

### Authentication ###
The Authenticator API provides:

- authenticateWithClientCredentials
- authenticateWithUsername

```swift
  if let username = username.text, let password = password.text {
    authenticator.authenticateWithUsername(username, password: password) {success, error in
      if(success){
        self.message.text = "success"
      }else{
        if let err = error{
          self.message.text = err.localizedDescription
        }
      }
    }
  }
```
In case of "authenticateWithClientCredentials" the client credentials will be stored in the CredentialsStore and will be reused automatically if the token is expired. In the other case (authenticateWithUsername), in addition, the OAuth2 refresh token will be stored and reused.

### Retrive the Access Token ###

This method returns the OAuth2 access token. The token will automatically renewed if expired.

```swift
  authenticator.retrieveAccessToken(handler: { (token, error) in
    if let accessToken = token{
      let token = accessToken
    }else if let e = error{
      self.message.text = e.localizedDescription
    }
  })
```

### Persistence ###
The inbuilt credentials store is a simple in-memory store.
You can implement and configure your own store. E.g. using the iOS keychain to store the credentials.

- implement the CredentialsStore protocol
  
```swift
  public protocol CredentialsStore{
    
    func storeCredentials(_ credentials:Credentials)
    func loadCredentials() -> Credentials?
    
  }
  
  import CocOAuth
  import KeychainAccess

  class KeychainCredentialsStore: CredentialsStore {
    
      var keychain: Keychain!
    
      init(storeName: String, userAuth: Bool=true ) {
          keychain = Keychain(service: storeName).accessibility(.whenUnlocked)
          if userAuth {
              keychain = self.keychain.accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence).authenticationPrompt("Authenticate to update your access token")
          }   
      }
      ...
  }
```

- set your own store in the config

```swift
  config.credentialsStore = KeychainCredentialsStore(storeName: tenantID, userAuth: userAuth)
```

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
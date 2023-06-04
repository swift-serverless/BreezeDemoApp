# BreezeDemoApp

BrezeDemoApp is a demo application to show how to use the swift Breeze framework to build a full stack application with an AWS Serverless backend.
The application is a simple CRUD app that manages a list of forms.

## Getting Started

The code is organized in two folders: 

- `BreezeDemoApp`: Demo iOS app in Swift/SwiftUI
- `Serverless`: Serverless Backend in Swift using the Breeze framework.

## Serverless Backend

The backend is a CRUD REST API that exposes 5 endpoints.
The API is authorized using Sign in with Apple.

To build the backend we need to install Docker and the Serverless Framework.

Before the deployment, it's required to update the `audience` property in the `serverless.yml` and `serverless-x86_64.yml` files with your app bundle identifier.

```yml
authorizers:
      appleJWT:
        identitySource: $request.header.Authorization
        issuerUrl: https://appleid.apple.com
        type: jwt
        audience:
        - com.andreascuderi.BreezeDemoApp # <- Update this with your app bundle identifier
```

You can follow the instructions in the [Serverless README](Serverless/README.md) to build and deploy it.

## iOS Breeze Demo App

The iOS app needs to be configured using the PRODUCT_BUNDLE_IDENTIFIER belonging to your team.
This needs to be the same replaced in `audience` property used in the backend configuration.

Once you build and deploy the backend, it's required to gather the base URL produced by the Serverless framework of the API Gateway and update the `baseURL` property in the `BreezeDemoApp/Services/FormService.swift` file.


```swift
struct APIEnvironment {
    static func dev() throws -> APIClientEnv {
        try APIClientEnv(session: URLSession.shared, baseURL: "<API Gateway URL>")
    }
}
```

Note:
Sign In With Apple requires a real device to work, so you need to run the app on a real device.

# Contributing

Contributions are more than welcome! Follow this [guide](https://github.com/swift-sprinter/BreezeDemoApp/blob/main/CONTRIBUTING.md) to contribute.
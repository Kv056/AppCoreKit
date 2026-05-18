# AppCoreKit README.md

````md
# AppCoreKit

A scalable reusable iOS base architecture for UIKit and SwiftUI projects.

Supports:
- UIKit
- SwiftUI
- MVC
- MVVM
- Async/Await
- TDD
- Generic Networking
- Token Refresh Flow
- Retry Mechanism
- Multipart Upload
- SSL Pinning
- Pagination
- CoreData
- SQLite
- Secure Cache
- Keychain
- API Logging
- Network Monitoring
- Request Interceptor
- Dependency Injection
- Offline Ready Architecture

---

# Features

## Networking
- Generic APIClient
- Request interceptor
- Retry mechanism
- Token refresh flow
- SSL pinning
- Multipart upload
- Pagination support
- API logging
- Network monitoring

## Database
- CoreData manager
- SQLite wrapper
- Secure cache manager

## Security
- Keychain manager
- Session timeout handling
- Token expiration validation

## Architecture
- UIKit MVC support
- UIKit MVVM support
- SwiftUI MVVM support
- Lightweight dependency injection
- TDD-ready structure

---

# Folder Structure

```text
AppCoreKit
├── Application
│
├── Core
│   ├── Networking
│   ├── Security
│   ├── Database
│   ├── Logging
│   ├── Utilities
│   ├── Extensions
│   └── Configuration
│
├── Shared
│
├── Modules
│   ├── Home
│   ├── Auth
│   └── Profile
│
├── Resources
│
└── Tests
```

---

# Requirements

- iOS 15+
- Xcode 15+
- Swift 5.9+

---

# Installation

Clone repository:

```bash
git clone https://github.com/yourusername/AppCoreKit.git
```

Open:

```bash
AppCoreKit.xcodeproj
```

---

````md
---

# Endpoint

`Endpoint` is used to define API configuration in a clean reusable way.

Instead of manually creating `URLRequest` everywhere, each API is declared as an `Endpoint`.

# How To Create Endpoint

Each API module can have its own endpoint file.

Recommended structure:

```text
Modules
├── Auth
│   └── Endpoints
│       └── AuthEndpoint.swift
│
├── User
│   └── Endpoints
│       └── UserEndpoint.swift
```

---

# Example 1 — GET API

## UserEndpoint.swift

```swift
import Foundation

enum UserEndpoint:
    Endpoint {

    case users

    var path: String {

        switch self {

        case .users:

            return "/users"
        }
    }

    var method:
        HTTPMethod {

        switch self {

        case .users:
            return .GET
        }
    }

    var headers:
        [String : String]? {

        nil
    }

    var queryItems:
        [URLQueryItem]? {

        nil
    }

    var body: Data? {

        nil
    }
}
```

---

# How To Use Endpoint

```swift
let users: [User] =

    try await APIClient()
        .request(
            UserEndpoint.users,
            responseType:
                [User].self
        )
```

---

# Example 2 — GET API With Query Parameters

## ProductEndpoint.swift

```swift
import Foundation

enum ProductEndpoint:
    Endpoint {

    case products(
        page: Int
    )

    var path: String {

        "/products"
    }

    var method:
        HTTPMethod {

        .GET
    }

    var headers:
        [String : String]? {

        nil
    }

    var queryItems:
        [URLQueryItem]? {

        switch self {

        case .products(let page):

            return [

                URLQueryItem(
                    name: "page",
                    value:
                        "\\(page)"
                )
            ]
        }
    }

    var body: Data? {

        nil
    }
}
```

---

# Usage

```swift
let response:
    PaginatedResponse<Product> =

    try await APIClient()
        .request(
            ProductEndpoint
                .products(page: 1),
            responseType:
                PaginatedResponse<Product>.self
        )
```

---

# Example 3 — POST API

## LoginRequest.swift

```swift
import Foundation

struct LoginRequest:
    Encodable {

    let email: String

    let password: String
}
```

---

# AuthEndpoint.swift

```swift
import Foundation

enum AuthEndpoint:
    Endpoint {

    case login(
        request:
            LoginRequest
    )

    var path: String {

        switch self {

        case .login:

            return "/login"
        }
    }

    var method:
        HTTPMethod {

        switch self {

        case .login:

            return .POST
        }
    }

    var headers:
        [String : String]? {

        [

            "Content-Type":
                "application/json"
        ]
    }

    var queryItems:
        [URLQueryItem]? {

        nil
    }

    var body: Data? {

        switch self {

        case .login(let request):

            return try? JSONEncoder()
                .encode(request)
        }
    }
}
```

---

# Usage

```swift
let request =
    LoginRequest(

        email:
            "test@gmail.com",

        password:
            "123456"
    )

let response:
    LoginResponse =

    try await APIClient()
        .request(
            AuthEndpoint
                .login(
                    request: request
                ),
            responseType:
                LoginResponse.self
        )
```

---

# Recommended Best Practices

- Create separate endpoint file per module
- Keep endpoint logic lightweight
- Avoid adding business logic inside endpoints
- Use request models for POST/PUT APIs
- Use queryItems for query parameters
- Keep API paths centralized

---

# Recommended Endpoint Structure

```text
Modules
├── Auth
│   ├── Models
│   ├── Endpoints
│   ├── Repository
│   └── ViewModel
│
├── User
│   ├── Models
│   ├── Endpoints
│   ├── Repository
│   └── ViewModel
```



# UIKit MVC Example

## ViewController

```swift
import UIKit

final class HomeViewController:
    UIViewController {

    private let apiClient =
        APIClient()

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUsers()
    }

    private func fetchUsers() {

        Task {

            do {

                let users:
                    [User] = try await apiClient
                        .request(
                            UserEndpoint.users,
                            responseType:
                                [User].self
                        )

                print(users)

            } catch {

                print(error)
            }
        }
    }
}
```

---

# UIKit MVVM Example

## ViewModel

```swift
import Foundation

@MainActor
final class HomeViewModel {

    private let apiClient =
        APIClient()

    var users: [User] = []

    func fetchUsers() async {

        do {

            users = try await apiClient
                .request(
                    UserEndpoint.users,
                    responseType:
                        [User].self
                )

        } catch {

            print(error)
        }
    }
}
```

## ViewController

```swift
import UIKit

final class HomeViewController:
    UIViewController {

    private let viewModel =
        HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {

            await viewModel
                .fetchUsers()

            print(
                viewModel.users
            )
        }
    }
}
```

---

# SwiftUI MVVM Example

## ViewModel

```swift
import Foundation

@MainActor
final class HomeViewModel:
    ObservableObject {

    @Published var users:
        [User] = []

    private let apiClient =
        APIClient()

    func fetchUsers() async {

        do {

            users = try await apiClient
                .request(
                    UserEndpoint.users,
                    responseType:
                        [User].self
                )

        } catch {

            print(error)
        }
    }
}
```

## View

```swift
import SwiftUI

struct HomeView: View {

    @StateObject
    private var viewModel =
        HomeViewModel()

    var body: some View {

        List(viewModel.users) {

            user in

            Text(user.name)
        }
        .task {

            await viewModel
                .fetchUsers()
        }
    }
}
```

---

# APIClient

Generic reusable networking layer.

## Features
- Async/Await
- Retry logic
- Token refresh
- Logging
- Interceptor support
- SSL pinning

## Example

```swift
let users: [User] =
    try await apiClient.request(
        UserEndpoint.users,
        responseType:
            [User].self
    )
```

---

# RetryManager

Automatically retries failed requests.

## Retries
- Timeout
- Network lost
- DNS failure

## Example

```swift
let users = try await
    RetryManager.retry {

        try await apiClient
            .request(
                endpoint,
                responseType:
                    [User].self
            )
    }
```

---

# TokenManager

Handles:
- Access token
- Refresh token
- Session timeout
- Background refresh
- Logout
- Token expiration

## Save Token

```swift
await TokenManager.shared
    .saveAccessToken(
        "token"
    )
```

## Get Token

```swift
let token =
    await TokenManager.shared
        .getAccessToken()
```

## Refresh Token

```swift
try await TokenManager.shared
    .refreshToken()
```

## Logout

```swift
await TokenManager.shared
    .logout()
```

---

# MultipartUploader

Uploads images/files using multipart/form-data.

## Example

```swift
try await MultipartUploader()
    .upload(
        url: url,
        imageData: imageData
    )
```

---

# PaginationManager

Reusable pagination handler.

## Example

```swift
let paginationManager =
    PaginationManager<User>()

paginationManager.append(
    newItems: users,
    totalPages: 10
)
```

---

# NetworkMonitor

Monitors internet connection.

## Start Monitoring

```swift
NetworkMonitor.shared
    .startMonitoring()
```

## Check Connection

```swift
if NetworkMonitor.shared
    .isConnected {

    print("Connected")
}
```

---

# APILogger

Logs requests and responses.

## Example

```swift
APILogger.logRequest(
    request
)

APILogger.logResponse(
    response,
    data: data
)
```

---

# KeychainManager

Secure token storage.

## Save

```swift
KeychainManager.shared
    .save(
        key: "token",
        value: "abc123"
    )
```

## Read

```swift
let token =
    KeychainManager.shared
        .read(
            key: "token"
        )
```

## Delete

```swift
KeychainManager.shared
    .delete(
        key: "token"
    )
```

---

# CoreDataManager

Generic CoreData helper.

## Save Context

```swift
try CoreDataManager.shared
    .save()
```

---

# SQLiteManager

Generic SQLite wrapper.

## Open Database

```swift
SQLiteManager.shared
    .openDatabase(
        named: "app.db"
    )
```

---

# SecureCacheManager

In-memory secure cache.

## Save

```swift
SecureCacheManager.shared
    .save(
        data: data,
        key: "profile"
    )
```

## Get

```swift
let data =
    SecureCacheManager.shared
        .get(
            key: "profile"
        )
```

---



---

# TDD

Supports:
- XCTest
- Mock repositories
- Mock APIClient
- Mock URLProtocol

## Example

```swift
final class UserTests:
    XCTestCase {

    func testFetchUsers()
    async throws {

        let vm =
            HomeViewModel()

        await vm.fetchUsers()

        XCTAssertFalse(
            vm.users.isEmpty
        )
    }
}
```

---

# Recommended Architecture

## UIKit MVC

Best for:
- Small apps
- Simple projects

## UIKit MVVM

Best for:
- Medium/Large apps
- Testable architecture

## SwiftUI MVVM

Best for:
- Modern iOS apps
- Reactive UI


# Best Practices

- Use MVVM for scalability
- Use async/await
- Avoid massive ViewControllers
- Avoid singleton overuse
- Write unit tests
- Keep modules isolated
- Use protocols for abstractions


# License

MIT License
````

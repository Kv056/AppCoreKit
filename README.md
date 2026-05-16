# AppCoreKit README.md


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

# WellnessActivity


The application demonstrates the use of modern libraries and frameworks such as RxSwift, RxCocoa, Realm, and Moya (with RxMoya extensions) to provide a reactive, persistent, and networked solution while maintaining a clear separation of concerns.

---

## Table of Contents
- [Overview](#overview)
- [Architecture](#architecture)
  - [Domain Layer](#domain-layer)
  - [Data Layer](#data-layer)
  - [Presentation Layer](#presentation-layer)
- [Features](#features)
- [Setup Instructions](#setup-instructions)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

**WellnessActivity** helps Hanako GmbH manage and promote corporate wellness activities. The app enables users to:
- View a list of wellness activities.
- Add new activities.
- Toggle the completion status of activities.
- Delete activities.

The app synchronizes data between local storage (using Realm) and a remote API (using Moya) while using RxSwift/RxCocoa to manage asynchronous operations and bindings.

---

## Architecture

The project follows a **Clean Architecture** approach separated into three main layers:

### Domain Layer

- **Entities:**  
  The primary domain model is the `Activity` (subclass of Realm's `Object`). It holds details such as `id`, `title`, `isCompleted`, and an optional `details` field.
  
- **Data Transfer Objects (DTOs):**  
  The `ActivityDTO` struct is used to transfer data from or to the remote API.
  
- **Protocols:**  
  The `ActivityRepositoryProtocol` defines the CRUD operations (fetch, add, update, delete) for the activity data.

### Data Layer

- **Local Repository:**  
  - **RealmActivityRepository:** Implements `ActivityRepositoryProtocol` using Realm for local data persistence.
  
- **Remote Repository:**  
  - **MoyaActivityRepository:** Implements `ActivityRepositoryProtocol` using Moya (and its Rx extensions) to perform network operations. API endpoints, HTTP methods, and JSON encoding are configured here.
  
- **Composite (Sync) Repository:**  
  - **SyncActivityRepository:** Combines local and remote repository implementations. It first emits the locally stored data, then updates local data with the remote results (by sequencing update operations) and emits the updated list.

### Presentation Layer

- **View Model:**  
  - **ActivityListViewModel:** Uses RxSwift/RxCocoa for binding input actions (like adding, toggling, and deleting an activity) to repository operations. It exposes an observable list of activities along with error events.
  
- **View Controller:**  
  - **ActivityListViewController:** Provides the user interface. Uses RxCocoa to bind UI elements (text fields, table views, buttons) to the view model’s inputs and outputs.

---

## Features

- **Reactive Programming:**  
  Uses RxSwift and RxCocoa to create an asynchronous data flow and binding between the data layer and UI components.

- **Local Persistence:**  
  Employs Realm for efficient on-device storage and real-time updates.

- **Network Layer:**  
  Uses Moya (with RxMoya) to handle network requests, enabling synchronization between a remote API and local data storage.

- **Clean Architecture & SOLID Principles:**  
  The separation of concerns across Domain, Data, and Presentation layers simplifies maintenance, enhances testability, and eases future modifications.

---

## Setup Instructions

1. **Clone the Repository:**

   ```bash
   git clone git@github.com:aymenafia/WellnessActivity.git
   cd WellnessActivity

# Nubli 📝📱

_Nubli is a minimalist notes and lists application designed to capture ideas quickly and organize everyday information without friction._

_The name comes from the French expression "N'oublie pas" ("don't forget"), reflecting the core goal of the app: helping you remember what matters._

_Nubli focuses on clarity, speed and simplicity, turning the entire screen into a distraction-free writing space — similar to modern note-taking apps._

## ✨ Features

### Current Features

- ⏰ Create and manage Notes

- ☑️ Create and manage Lists

- 🔐 Authentication system (Sign up / Sign in / Sign out)

- 🚧 Form validation and error handling

- 🔄 State management with **BLoC**

- ⚡️ **Supabase** implementation

- 🛢️ Repository pattern implementation

- 🎨 Minimalist UI focused on writing and checking lists

- 🧩 Custom styled inputs and components with Responsive UI

## 🛠 Tech Stack

### Frontend --> 📱 Flutter

### Data Base --> ⚡️ Supabase

### 🧱Architecture

**Feature-based Clean Architecture with BLoC**

The project follows a scalable architecture pattern:

```
lib
├── 🫀 core
│ │
│ ├── 🕹️ app
│ │ ├── drawer.dart
│ │ └── gate_app.dart
│ │
│ ├── ⚠️ error
│ │
│ ├── 🤖/🍎 platform
│ │
│ ├── 🎨 theme
│ │ └── styles_utils.dart
│ │
│ └── 🛠️ utils
│ ├── helper_utils.dart
│ ├── routes_utils.dart
│ └── widgets_utils.dart
│
│
├── ⚙️ features
│ │
│ │
│ └── 🔐 auth
│ │
│ ├── 🛢️ data
│ │ ├── datasources
│ │ │ └── auth_remote_datasource.dart
│ │ └── repositories
│ │ └── auth_repository_impl.dart
│ │
│ ├── 🧮 domain
│ │ ├── repositories
│ │ │ └── auth_repository.dart
│ │ └── usecases
│ │ ├── sign_in.dart
│ │ ├── sign_out.dart
│ │ └── sign_up.dart
│ │
│ └── 🖥 presentation
│ ├── bloc
│ │ ├── auth_bloc.dart
│ │ ├── auth_event.dart
│ │ └── auth_state.dart
│ └── pages
│ └── login_page.dart
│
│
└── 🗒️ entry
│ │
│ ├── 🛢️ data
│ │ ├── datasources
│ │ │ └── entry_local_datasource.dart
│ │ │ └── entry_remote_datasource_impl.dart
│ │ │ └── entry_remote_datasource.dart
│ │ │ └── in_memory_entry_datasource.dart
│ │ └── models
│ │ │ └── entry_model.dart
│ │ │ └── list_entry_model.dart
│ │ │ └── list_item_model.dart
│ │ │ └── reminder_entry_model.dart
│ │ └── repositories
│ │ │ └── entry_local_repository_impl.dart
│ │ │ └── entry_remote_repository_impl.dart
│ │
│ ├── 🧮 domain
│ │ ├── entities
│ │ │ └── category_entity.dart
│ │ │ └── entry_entity.dart
│ │ │ └── entry_form_model_entity.dart
│ │ │ └── entry_type_entity.dart
│ │ │ └── reminder_entry_entity.dart
│ │ │ └── list_entry_entity.dart
│ │ │ └── list_item_entity.dart
│ │ │ └── priority_entity.dart
│ │ │ └── recurrence_entity.dart
│ │ ├── repositories
│ │ │ └── entry_repository.dart
│ │ └── usecases
│ │ │ └── add_item_to_list.dart
│ │ │ └── create_list_entry.dart
│ │ │ └── create_reminder_entry.dart
│ │ │ └── toggle_list_item.dart
│ │ │
│ └── 🖥 presentation
│ ├── bloc
│ │ ├── entry_bloc.dart
│ │ ├── entry_event.dart
│ │ └── entry_state.dart
│ └── pages
│ └── home_page.dart
│ └── create_entry_page.dart
│ └── widgets
│ └── simple_widgets.dart
│
└── main.dart
```

```
🖥 Presentation (UI + BLoC)
↓
Domain
🧮 (UseCases + Entities)
↓
Data
🛢️ (API / DB / Models)
```

**State management** is handled with:

- BLoC Pattern

- Other design principles used:

- Separation of concerns

- Reusable UI components

- Scalable folder structure

## 🎨 Design Philosophy

Nubli was designed with a writing-first approach.

Instead of small input boxes, the main editor expands to occupy most of the screen, giving the feeling of writing on a digital document.

Color is used subtly to distinguish content types:

⏰ Notes
☑️ Lists

The interface avoids unnecessary visual noise to keep the focus on capturing thoughts quickly.

## 🚀 Roadmap

Nubli is currently in active development. Upcoming features include:

🔄 Real-time synchronization (Sockets)

🔔 Push Notifications

👥 Multi-user collaboration

☁️ Cloud sync

📱 Offline-first support

🏷 Tags and advanced filtering

🔍 Search functionality

🎨 Theme customization

## 📌 Project Status

This project is currently in Phase 1 of development.

The focus has been on:

- Core UI

- Authentication

- Notes and lists structure

- Base architecture

- Future iterations will introduce real-time collaboration and cloud synchronization.

## ⚙️ Getting Started

Clone the repository:

git clone https://github.com/yourusername/nubli.git

Install dependencies:
flutter pub get

Run the project:
flutter run

## 📄 License

This project is released under the MIT License.

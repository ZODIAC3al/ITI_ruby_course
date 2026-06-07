# ITI Ruby Course Repository

Welcome to the **ITI Ruby Course** repository. This workspace contains all the projects and assignments completed during the course, structured day-by-day.

---

## 📂 Repository Structure

| Directory | Topic / Project | Description | Tech/Features |
| :--- | :--- | :--- | :--- |
| **[day1](file:///c:/Projects/Ruby/Ruby_Course/day1)** | CSV Inventory Manager | A CLI application for managing library books inventory. | CSV Parsing, File I/O, Objects |
| **[day2](file:///c:/Projects/Ruby/Ruby_Course/day2)** | Bank Simulation System | A CLI application simulating bank transactions, users, and actions. | Classes, Logging, User Authentication |
| **[store](file:///c:/Projects/Ruby/Ruby_Course/store)** | Rails Web Store | A full-stack Rails web application for managing products with built-in authentication. | Rails 8, Active Record, SQLite, Authentication, CRUD views |

---

## 🚀 Getting Started & How to Run

### Day 1: CSV Inventory Manager
A command-line script to view and manage an inventory of books stored in a CSV file.
1. Navigate to the `day1` directory:
   ```bash
   cd day1
   ```
2. Run the program:
   ```bash
   ruby main.rb
   ```

### Day 2: Bank Simulation System
A simulation of a banking system tracking user transactions and credentials with action logging.
1. Navigate to the `day2` directory:
   ```bash
   cd day2
   ```
2. Run the application:
   ```bash
   ruby main.rb
   ```

### Day 3+: Rails Web Store
A complete Ruby on Rails web store showcasing product management (CRUD) and secure user authentication.
1. Navigate to the `store` directory:
   ```bash
   cd store
   ```
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Run database migrations:
   ```bash
   rails db:migrate
   ```
4. Start the Rails server:
   ```bash
   rails server
   ```
5. Open your browser and navigate to `http://localhost:3000`.

---

## 🛠️ Requirements
* **Ruby**: `^3.0` or higher (tested on Ruby `4.0.0`)
* **Rails**: `^8.1.3`
* **SQLite3**

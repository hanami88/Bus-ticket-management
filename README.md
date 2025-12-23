# 🚌 Bus Ticket Management System

A digital transformation solution for bus ticket booking, enabling efficient and modern connectivity between passengers and bus operators.

---

## 🛠 Tech Stack
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)
![Servlet](https://img.shields.io/badge/Servlet-007396?style=for-the-badge&logo=java&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

---

## 📝 Project Overview

### Background and Problem
Currently, bus ticket booking still relies heavily on manual methods such as phone calls or purchasing tickets directly at ticket counters, which causes many inconveniences.

**From the Customer’s Perspective:**
* 🔍 Difficulty in searching for route information and schedules.
* ⚖️ Hard to compare ticket prices between different bus operators.
* ⏳ Time-consuming travel and long waiting times at ticket offices.

**From the Bus Operator’s Perspective:**
* 📂 Complicated ticket management processes.
* 📊 Difficulty in tracking passenger numbers.
* 📉 Challenges in revenue reporting and statistics.
* ⚠️ High risk of human errors.

> **Solution:** The development of an online bus ticket booking system is an optimal solution to address these issues, aligning with the digital transformation trend and significantly improving user experience.

---

## 🏗 System Architecture & Design

### 🔹 Use Case Diagram
<img width="501" alt="Use Case Diagram" src="https://github.com/user-attachments/assets/03e70fbf-fb35-4a23-aefc-c1ae0ffeb808" />

### 🔹 Entity-Relationship Diagram (ERD)
<img width="624" alt="ERD" src="https://github.com/user-attachments/assets/1f1e0f2c-aada-453c-8d5b-2c688b16995a" />

---

## 💻 Key Features

### 1. Validation and Security
* **Comprehensive Validation:** Implemented on both **client-side** (JavaScript) and **server-side** (Java) to ensure data integrity.
* **SQL Injection Prevention:** Utilizes `PreparedStatement` to ensure secure database queries.
* **Session Management:** Features automatic **session timeout** for enhanced user security.
* **Role-Based Access Control (RBAC):** Strict permission management for different roles (**User** vs. **Admin**).

### 2. Business Logic
* **Real-time Availability:** Verification of available seats before allowing a booking.
* **Automatic Seat Updates:** System automatically updates the seat count immediately after a successful reservation.
* **Automated Price Calculation:** Total fare is calculated automatically based on ticket quantity and pricing rules.
* **Smart Trip Filtering:** Display only upcoming trips (automatically hides past trips based on the current date).

---

## 🖼 User Interface Gallery

| Page | Preview |
| :--- | :--- |
| **Login (with validation)** | <img src="https://github.com/user-attachments/assets/74f02696-df43-4113-a42d-856045e2743e" width="600"/> |
| **Register (with validation)** | <img src="https://github.com/user-attachments/assets/a0e3f3a1-be15-4793-8ab9-d1da79b91cc6" width="600"/> |
| **Search & Trip Listing** | <img src="https://github.com/user-attachments/assets/ac884b73-df0a-45e4-91e4-ad61642bee69" width="600"/> |
| **Booking Details Form** | <img src="https://github.com/user-attachments/assets/c54eff7d-65f5-4e56-81a5-830cf5430ecc" width="600"/> |
| **Payment & Confirmation** | <img src="https://github.com/user-attachments/assets/bb8fdb42-c28a-4e7b-af39-4cf00850bcef" width="600"/> |
| **Admin Dashboard** | <img src="https://github.com/user-attachments/assets/8708922f-1a19-47d1-8416-b1aaff981b48" width="600"/> |

---
## 🙏 Thank You

Thank you for taking the time to review my project.  
I appreciate your attention and welcome any feedback or suggestions

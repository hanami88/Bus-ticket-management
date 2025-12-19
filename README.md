## Bus Ticket Management

### Background and Problem

Currently, bus ticket booking still relies heavily on manual methods such as phone calls or purchasing tickets directly at ticket counters, which causes many inconveniences.

**From the customer’s perspective:**
- Difficulty in searching for route information and schedules  
- Hard to compare ticket prices between different bus operators  
- Time-consuming travel and long waiting times at ticket offices  

**From the bus operator’s perspective:**
- Complicated ticket management processes  
- Difficulty in tracking passenger numbers  
- Challenges in revenue reporting and statistics  
- High risk of human errors  

The development of an online bus ticket booking system is an optimal solution to address these issues, aligning with the digital transformation trend and significantly improving user experience.

**Use Case**

<img width="501" height="456" alt="Ảnh màn hình 2025-12-18 lúc 22 45 41" src="https://github.com/user-attachments/assets/03e70fbf-fb35-4a23-aefc-c1ae0ffeb808" />

**Entity-Relationship Diagram**

<img width="624" height="329" alt="Ảnh màn hình 2025-12-18 lúc 22 45 15" src="https://github.com/user-attachments/assets/1f1e0f2c-aada-453c-8d5b-2c688b16995a" />

**Login page with form validation**

<img width="903" height="509" alt="Ảnh màn hình 2025-12-18 lúc 22 52 59" src="https://github.com/user-attachments/assets/74f02696-df43-4113-a42d-856045e2743e" />

**Register page with form validation**

<img width="904" height="510" alt="Ảnh màn hình 2025-12-19 lúc 10 25 51" src="https://github.com/user-attachments/assets/a0e3f3a1-be15-4793-8ab9-d1da79b91cc6" />

**Search & Trip Listing Page**

<img width="900" height="509" alt="Ảnh màn hình 2025-12-19 lúc 10 26 09" src="https://github.com/user-attachments/assets/ac884b73-df0a-45e4-91e4-ad61642bee69" />

**Booking Page with Detailed Form**

<img width="902" height="507" alt="Ảnh màn hình 2025-12-19 lúc 10 26 22" src="https://github.com/user-attachments/assets/c54eff7d-65f5-4e56-81a5-830cf5430ecc" />

**Payment & Confirmation Page**

<img width="792" height="536" alt="Ảnh màn hình 2025-12-19 lúc 10 30 43" src="https://github.com/user-attachments/assets/bb8fdb42-c28a-4e7b-af39-4cf00850bcef" />

**Admin Dashboard with General Statistics**

<img width="872" height="490" alt="Ảnh màn hình 2025-12-19 lúc 10 30 55" src="https://github.com/user-attachments/assets/8708922f-1a19-47d1-8416-b1aaff981b48" />

### 3.3.4. Special Features

#### 1. Validation and Security
* **Input Validation:** Comprehensive validation implemented on both **client-side** (JavaScript) and **server-side** (Java).
* **SQL Injection Prevention:** Utilizes `PreparedStatement` to ensure secure database queries.
* **Session Management:** Features automatic **session timeout** for enhanced user security.
* **Role-Based Access Control (RBAC):** Strict permission management for different roles (e.g., **User** vs. **Admin**).

#### 2. Business Logic
* **Seat Availability Check:** Real-time verification of available seats before allowing a booking.
* **Automatic Seat Updates:** The system automatically decrements/updates the seat count immediately after a successful reservation.
* **Automated Price Calculation:** Total fare is calculated automatically based on ticket quantity and pricing rules.
* **Smart Trip Filtering:** Advanced filtering logic to display only upcoming trips (automatically hides past trips based on the current date).

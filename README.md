# 🏨 Hotel Booking Business Intelligence & Data Mining

<p align="center">
  <img src="https://img.shields.io/badge/Python-3.8+-blue.svg?style=for-the-badge&logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/SQL-Data_Extraction-orange.svg?style=for-the-badge&logo=mysql&logoColor=white" alt="SQL">
  <img src="https://img.shields.io/badge/Orange-Data_Mining-green.svg?style=for-the-badge&logo=target&logoColor=white" alt="Orange">
  <img src="https://img.shields.io/badge/Status-Completed-brightgreen.svg?style=for-the-badge" alt="Status">
</p>

---

## 📌 Project Overview
This project provides a **comprehensive end-to-end analysis** of hotel booking data. Our goal was to address high cancellation rates and optimize revenue management using a multi-tool approach.

> **Business Impact:** Identified key behavioral triggers that predict cancellations with high accuracy, allowing for better overbooking strategies and resource allocation.

---

## 🛠️ Tech Stack & Tools
| Category | Tools |
| :--- | :--- |
| **Database Design** | ERD Modeling (Database Schema) |
| **Data Engineering** | SQL (Complex Queries, Cleaning, Transformation) |
| **Data Analysis** | Python (Pandas, Seaborn, Matplotlib) |
| **Data Mining** | Orange Data Mining (Workflow-based modeling & Clustering) |
| **Reporting** | Microsoft PowerPoint & Professional PDF Reports |

---

## 📂 Project Structure
```bash
├── 📁 Design/          # ERD.pdf (Database Architecture)
├── 📁 SQL/             # database_queries.sql (Data manipulation scripts)
├── 📁 Notebooks/       # hotel_data_analysis.ipynb (EDA & Python Modeling)
├── 📁 Workflows/       # orange_project_workflow.ows (Visual Data Mining)
├── 📁 Reports/         # Final_Report.pdf & Presentation.pptx
└── 📄 README.md        # Project Documentation
```
## 🚀 Key Project Phases

<details>
<summary><b>🗄️ Phase 1: Database & SQL Foundation (Click to expand)</b></summary>
<br>

* **ERD Design:** Established a robust schema ensuring data integrity across Guests, Rooms, and Reservations.
* **Data Refinement:** Cleaned 100k+ records using SQL, handling NULLs in columns like `agent` and `company`.
* **Advanced Querying:** Created views for Housekeeping performance and Invoice aging.
</details>

<details>
<summary><b>📊 Phase 2: Exploratory Data Analysis (EDA)</b></summary>
<br>

* **Seasonality:** Identified peak booking months (August/July) vs. low periods.
* **Lead Time Analysis:** Discovered that lead time is a primary driver for cancellations.
* **Anomaly Detection:** Identified and removed invalid records (e.g., zero guests or negative ADR).
</details>

<details>
<summary><b>🤖 Phase 3: Data Mining (Orange Workflow)</b></summary>
<br>

* **Visual Pipeline:** Built a workflow for automated cleaning and feature selection.
* **Predictive Modeling:** Implemented Classification models to flag high-risk bookings.
* **Evaluation:** Used Confusion Matrices and ROC Curves to validate model performance.
</details>

---

## 📈 Key Insights (Business Impact)

* 🚩 **Cancellation Predictor:** Bookings with long **Lead Times** and **Non-Refund** deposits show a significantly higher risk of cancellation (reaching 99% in specific segments).
* 💰 **Revenue Driver:** **City Hotels** generate higher overall revenue, but **Resort Hotels** dominate during the summer season (July-August).
* 👥 **Customer Behavior:** Guests with "Special Requests" or "Parking Needs" are statistically less likely to cancel, indicating higher commitment.
* 🛠️ **Data Quality:** Handled 94% missing data in the `company` field and removed outlier ADR values (>€500) to ensure analysis accuracy.

---

## ⚙️ How to Explore the Project

| File Type | Action | Path |
| :--- | :--- | :--- |
| **🗄️ Database** | Review Schema | `Design/ERD.pdf` |
| **💻 SQL** | Run Transformation | `SQL/database_queries.sql` |
| **🐍 Python** | Deep Dive Analysis | `Notebooks/hotel_data_analysis.ipynb` |
| **🍊 Orange** | Visual Modeling | `Workflows/orange_project_workflow.ows` |

---

## 👤 Author Group

<div align="center">

### **Mahmoud Ahmed Rashad**
### **Mostafa Shafea Ahmed**
### **Ahmed Alaa Aboelfadl**
### **Mostafa Abdullah Shawkey**
### **Mostafa Hassan Abdulaziz**

> **Data Analyst | Business Intelligence Enthusiast**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](رابط_لينكد_إن_هنا)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:ايميلك_هنا)
[![Portfolio](https://img.shields.io/badge/Portfolio-000000?style=for-the-badge&logo=About.me&logoColor=white)](رابط_بورتفوليو_أو_جيت_هاب)

---


</div>

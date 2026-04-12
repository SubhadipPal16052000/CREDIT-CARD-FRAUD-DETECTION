# 💳 Transactional Fraud Detection System

![](image_cover.jpg)
![](image_cover.jpg)
![](image_cover.jpg)

> 🚀 End-to-end Machine Learning + Data Engineering + Analytics project developed at **Infyntrek Systèmes** for real-time fraud detection and business insights.

---

## 📌 Overview

Financial fraud is a major challenge in digital transactions. Fraudulent activities are rare but highly impactful, making detection difficult.

This project builds a **complete fraud detection system** that:

- 🤖 Detects fraudulent transactions using Machine Learning  
- 🗄️ Processes and manages data using PostgreSQL  
- 📊 Generates business insights using SQL analytics  
- 🌐 Provides real-time predictions via Streamlit  
- 📈 Visualizes fraud trends using Power BI dashboards  

---

## 🎯 Problem Statement

Fraudulent transactions are hidden within millions of legitimate ones. The key challenges are:

- Handling highly **imbalanced datasets**  
- Minimizing **false negatives (missed fraud cases)**  
- Enabling **real-time fraud detection systems**  

---

## 🏗️ System Architecture

> Raw Data → Data Cleaning → PostgreSQL → SQL Analytics → ML Model → Streamlit App → Power BI Dashboard


---

## ⚙️ Tech Stack

| Category        | Tools Used |
|----------------|-----------|
| Language       | Python |
| Libraries      | Pandas, NumPy, Scikit-learn, XGBoost |
| Database       | PostgreSQL |
| Visualization  | Plotly, Power BI |
| Web App        | Streamlit |
| Tools          | SQLAlchemy, Joblib |

---

## 🔍 Key Features

### 🔹 Data Engineering
- Data cleaning and preprocessing  
- Duplicate removal and missing value handling  
- Optimized database queries  

### 🔹 SQL Analytics
- 21+ business queries  
- Fraud percentage calculation  
- Peak fraud hour detection  
- Risk-based transaction analysis  

### 🔹 Machine Learning
- Classification model  
- Probability-based prediction (`predict_proba`)  
- Threshold tuning for imbalanced data  

### 🔹 Streamlit Application
- Real-time fraud prediction  
- KPI dashboard  
- Business insights  

### 🔹 Power BI Dashboard
- Fraud trend visualization  
- Time-based analysis  
- Risk segmentation  

---

## 📊 Key Insights

- Fraud transactions are extremely rare (~0.17%)  
- High-value transactions show higher fraud risk  
- Fraud activity peaks during specific time intervals  
- Patterns indicate possible automated fraud behavior  

---

## 📈 Business Impact

- 💰 Prevents financial losses  
- ⚡ Enables real-time decision-making  
- 🤖 Reduces manual investigation  
- 🏦 Improves customer trust  

---

## 🧠 Key Learnings

- Handling imbalanced datasets effectively  
- Importance of threshold tuning  
- Combining SQL + ML + dashboards  
- Building end-to-end systems  

---

## 🚧 Challenges

- Highly imbalanced data distribution  
- Reducing false negatives  
- Maintaining real-time performance  
- Feature consistency during prediction  

---

## 🔮 Future Enhancements

- Real-time streaming (Kafka)  
- Explainable AI (SHAP, LIME)  
- API deployment (FastAPI)  
- Advanced ML models  

---

## ▶️ How to Run

```bash
# Clone repository
git clone https://github.com/SubhadipPal16052000/CREDIT-CARD-FRAUD-DETECTION

# Navigate to folder
cd CREDIT-CARD-FRAUD-DETECTION

# Create virtual environment
python -m venv .venv

# Activate environment (Windows)
.venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run application
streamlit run app.py

```
---
## 📂 Project Structure
```bash
├── app.py
├── utils.py
├── models/
│   ├── fraud_model.pkl
│   ├── features.pkl
│   ├── threshold.pkl
├── data/
├── sql/
│   ├── create_tables.sql
│   ├── analysis_queries.sql
├── requirements.txt

```
## 🔗 Live Demo
- 🌐 Streamlit App
https://credit-card-fraud-detection-yjkbqvthtpkambdbaekovf.streamlit.app/
- 📊 Power BI Dashboard
https://app.powerbi.com/view?r=eyJrIjoiYTAzYjE5MjAtZmVlZC00OTg0LThjNGItZDU1ZGMyYzZjNjI0IiwidCI6IjlhOTkzMjZhLTliZjQtNGYwNS04MmFmLWVkNWMwOTZhMjQ1OSJ9&pageName=7e36062a4875fee878bd

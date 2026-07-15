# 📊 E-Commerce Data Cleaning & Exploratory Data Analysis (EDA) Pipeline

[![Python](https://img.shields.io/badge/Python-3.8%2B-blue.svg)](https://www.python.org/)
[![Pandas](https://img.shields.io/badge/Pandas-v2.0%2B-darkblue.svg)](https://pandas.pydata.org/)
[![Data-Cleaning](https://img.shields.io/badge/Pipeline-Data%20Cleaning-orange.svg)]()
[![EDA](https://img.shields.io/badge/Analysis-Exploratory%20Data%20Analysis-green.svg)]()

An end-to-end data preparation, cleaning, and exploratory analysis pipeline designed to turn raw, messy transactional e-commerce data into structured, business-ready insights. This project demonstrates clean coding practices, programmatic outlier detection, and strategic business translation.

---

## 📌 Project Overview & Business Problem
Raw operational datasets are rarely ready for direct modeling or BI dashboarding. They suffer from structural inconsistencies, missing labels, corrupted formats, and anomalous entries that skew key metrics like average order value (AOV) and customer lifetime value (CLV).

This project acts as a robust **Data Cleaning & Diagnostics Pipeline**. Working with a raw transaction dataset containing 1,200 records, the script systematically diagnoses quality issues, executes targeted cleansing steps, performs statistical outlier identification, and renders descriptive executive findings.

---

## 🛠️ Tech Stack & Dependencies
The analysis was built within a Jupyter environment utilizing core Python data science libraries:
* **Pandas**: High-performance data manipulation, type casting, and index alignment.
* **NumPy**: Vectorized operations and missing value representation.
* **Matplotlib & Seaborn**: Customized statistical plotting (distribution charts, time-series lines, and scatter plots).
* **IPython.display**: Dynamic markdown formatting for human-readable reporting.

---

## 📂 Dataset Profile
The initial raw dataset representing e-commerce operations contains **1,200 entries** across **14 analytical columns**:

| Column Name | Description | Key Issues Handled |
| :--- | :--- | :--- |
| **OrderID** | Unique transaction ID | Checked for duplicates |
| **Date** | Date of transaction | Loaded as text; required datetime parsing |
| **CustomerID** | Unique customer identifier | Checked integrity |
| **Product** | Categorical name of the item sold | Inconsistent whitespace padding |
| **Category** | Product macro-grouping | String standardisation |
| **Quantity** | Volume of products purchased | Outlier detection |
| **UnitPrice** | Unit price per item | Verified logical range ($ > 0) |
| **TotalPrice** | Net pricing computed for the transactions | Derived value consistency checks |
| **PaymentMethod** | Gateway used (e.g., Credit Card, PayPal) | Whitespace trimming |
| **OrderStatus** | Order progress (Delivered, Cancelled, Returned) | Categorical alignment |
| **DiscountCode** | Code applied at checkout | Massive null percentage (imputed) |
| **ReferralSource**| Marketing channel of origin | Null entries standardisation |
| **ItemsInCart** | Count of items left in cart | Range validation |
| **CustomerRating**| Score given by the user (1.0 to 5.0) | Null entries imputed via median |

---

## 🧹 The Data Cleaning Pipeline
The cleaning processes are structured sequentially in the `EDA.ipynb` notebook:

### 1. Integrity Verification
* Executed duplicate record verification across all analytical features.
* *Result:* Found and eliminated duplicate records to ensure data uniqueness.

### 2. Missing Value Strategy
* **`DiscountCode`**: `309` null entries were identified. Instead of dropping rows (which loses valuable sales data), missing entries were strategically imputed as `"None"` representing transactions completed at standard retail price.
* **`CustomerRating`**: Missing reviews were imputed using the dataset's **Median** value to preserve overall distributional characteristics without being skewed by extreme scores.
* **`ReferralSource`**: Missing pathways were classified under `"Unknown"` to avoid misattributing organic traffic metrics.

### 3. Whitespace Standardisation
* Many categorical records had leading or trailing space paddings (e.g., `" Mechanical Keyboard "` vs `"Mechanical Keyboard"`).
* Applied vectorized `.str.strip()` operations to standardize categorization across `Product`, `PaymentMethod`, `OrderStatus`, and `ReferralSource`.

### 4. Schema Formatting
* Converted the `Date` column from raw string types into unified Pandas `datetime64[ns]` formats, enabling seamless time-series grouping, indexing, and seasonal evaluations.

### 5. Final Asset Export
* Wrote the fully sanitized dataframe into `clean_data.csv` to protect raw inputs and preserve a reproducible analytical workflow.

---

## 📊 Analytical Deep Dive: Outlier Detection
To prevent exceptional, non-representative transactions from skewing the mean order value, we implemented a robust statistical outlier filter using the **Interquartile Range (IQR)** method on the `TotalPrice` variable:

$$\text{IQR} = Q_3 - Q_1$$
$$\text{Upper Bound} = Q_3 + (1.5 \times \text{IQR})$$

### 📈 Scatter Plot Vizualization
Our diagnostic script segments transactions and displays outliers as distinct red marks, making them instantly recognizable to operational teams.

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Calculate IQR to identify outlier thresholds
Q1 = clean_data['TotalPrice'].quantile(0.25)
Q3 = clean_data['TotalPrice'].quantile(0.75)
IQR = Q3 - Q1
upper_bound = Q3 + (1.5 * IQR)

# Segment the dataset
outliers = clean_data[clean_data['TotalPrice'] > upper_bound]
normal_data = clean_data[clean_data['TotalPrice'] <= upper_bound]

# Plot
plt.figure(figsize=(11, 6))
plt.scatter(normal_data.index, normal_data['TotalPrice'], color='steelblue', alpha=0.5, s=25, label='Normal Orders')
plt.scatter(outliers.index, outliers['TotalPrice'], color='red', marker='x', s=70, linewidths=2, label=f'Outliers (> ${upper_bound:.2f})')
plt.axhline(y=upper_bound, color='orangered', linestyle='--', linewidth=1.5, label=f'Threshold Boundary (${upper_bound:.2f})')

plt.title('Distribution of Order Prices with Identified Outliers', fontsize=14, fontweight='bold', pad=15)
plt.xlabel('Order Sequence / Row Index', fontsize=11)
plt.ylabel('Total Transaction Value ($)', fontsize=11)
plt.grid(True, linestyle=':', alpha=0.6)
plt.legend(loc='upper right')
plt.tight_layout()
plt.show()

# Objectives

The primary objective was to analyze the COVID-19 death statistics dataset to understand the impact of the pandemic across different countries and regions. Specific goals included:
Calculating the likelihood of dying from COVID-19 in different locations.
Determining the percentage of the population infected in various countries.
Identifying countries and continents with the highest infection and death rates.
Analyzing the global death percentage over time.
Evaluating the progress of vaccination campaigns across different locations.

# Methodology:
The analysis was performed using SQL, a powerful language for querying and manipulating large datasets. The following steps were taken:
Data Exploration: The dataset was explored by selecting and inspecting sample rows from the coviddeaths and covidvaccinations tables to understand the structure and contents.
Data Cleaning and Preprocessing: Relevant columns were selected, and filters were applied to remove null or irrelevant data (e.g., excluding rows where the continent is null).
Calculation of Key Metrics: SQL queries were written to calculate various metrics, such as death percentage, percentage of population infected, highest infection count, death count by country and continent, and global death percentage over time.
Use of Analytical Techniques: Techniques like aggregation (SUM, MAX), filtering (WHERE), joining tables (JOIN), and window functions (OVER PARTITION BY) were employed to derive insights from the data.
Creation of Views and Temporary Tables: Views and temporary tables were created to store intermediate results and facilitate further analysis and visualization.
Data Visualization: The processed data was exported or accessed from the created views to build visualizations and dashboards in Tableau, allowing for interactive exploration and presentation of the findings.

# Size of the Dataset:
The dataset contained 336,044 rows, which is considered a large dataset for analysis purposes. Working with such a large volume of data required efficient querying techniques and the use of appropriate data structures (e.g., views and temporary tables) to manage and process the information effectively.

# Conclusions:
Through the analysis of the COVID-19 death statistics dataset, valuable insights were gained, including:
The likelihood of dying from COVID-19 in different countries and regions, which could inform public health policies and resource allocation. I identified that the continent with the highest death count was North America.  
The extent of the pandemic's spread across populations, highlighting the need for preventive measures and healthcare preparedness.
Identification of hotspots and regions with high infection and death rates, enabling targeted interventions and support.
Understanding the global death percentage trends over time, which could be used to evaluate the effectiveness of mitigation strategies.
These conclusions could be further explored and visualized using the created views and the Tableau dashboard, allowing others to make informed decisions based on the data-driven insights.

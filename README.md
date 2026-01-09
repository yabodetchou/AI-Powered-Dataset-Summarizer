# AI-Powered-Dataset-Summarizer

An AI-powered web application that performs automatic dataset analysis and summarization, helping users quickly understand the structure, statistics, and insights of tabular data.
This project is designed to reduce the time spent on exploratory data analysis (EDA) by combining basic statistical analysis with AI-generated summaries.


## Features
	•	Automatic summary of:
	•	Dataset shape (rows, columns)
	•	Column names and data types
	•	Missing values
	•	Simple web-based interface
	•	Backend–frontend separation for scalability

  
## Project Structure

AI-Powered-Dataset-Summarizer/
│
├── backend/        # Data processing and analysis logic
├── frontend/       # User interface
├── data/           # Sample datasets
├── .gitignore
└── README.md


## How It Works
	- The backend processes the dataset and computes summary statistics
	-	An AI component generates a human-readable explanation of the dataset
  - Results are returned and displayed in the frontend
  
  
  ## Tech Stack
	•	Backend:  R (basic statistical analysis)
	•	Frontend: HTML, CSS, JavaScript
	•	Data Handling: CSV files
	•	AI: Gemini API




## Installation & Setup

1. Clone the repository

git clone https://github.com/yabodetchou/AI-Powered-Dataset-Summarizer.git
cd AI-Powered-Dataset-Summarizer

add your own API key in .env

2. Run the backend
cd backend
source("analysis.R")


3. Frontend
cd frontend
python3 -m http.server 8080

Open http://localhost:8080 in the browser.



## Example Use Cases
	•	Quickly exploring unfamiliar datasets
	•	Supporting data science workflows
	•	Automating exploratory data analysis
	•	Educational projects and demos

  

## Future Improvements
	•	Upload files CSV and TXT for analysis
	•	More advanced AI summariES
	•	Data visualization (charts & graphs)
	•	Authentication and dataset history
	

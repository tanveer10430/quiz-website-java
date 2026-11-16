# Online Quiz Application

A beginner-friendly, complete Java Web Application for college projects built with **Java Servlets**, **JSP**, **JDBC**, **MySQL**, **HTML5**, and **CSS3**, deployed on **Apache Tomcat**.

---

## 1. Features

- **Direct Home Page Access**: Two clear sections (Student and Admin) accessible right from the landing page.
- **Admin Section (No Admin Login Required)**:
  - Add quiz questions with four options and a designated correct answer.
  - Review all existing questions in a structured list/table.
  - Set a **Student Joining Password**.
  - **Publish Quiz**: Prevents publishing empty quizzes or publishing without a joining password.
  - Unpublish or manage questions at any time.
- **Student Section**:
  - Enter student name and joining password.
  - Verification ensures the quiz is published and password matches.
  - Clear error feedback if unpublished or if password is incorrect.
  - Take the quiz with 4 radio-button options per question (can leave unanswered).
  - Submit answers together.
- **Security & Evaluation**:
  - **Password Hashing**: Student joining password is saved securely using **SHA-256**.
  - **Zero Answer Leakage**: Correct answers are stored on MySQL and never exposed in the student quiz HTML/JSP.
  - **Server-Side Scoring**: Evaluates answers on the server and displays total questions, correct answers, incorrect/unanswered count, and final score.
  - Results are saved into the `results` table.

---

## 2. Project Directory Structure

```text
oopj project/
│
├── database/
│   └── schema.sql                  # MySQL database script
│
├── src/
│   └── com/
│       └── quiz/
│           ├── model/
│           │   └── Question.java   # Question model
│           ├── util/
│           │   └── DBConnection.java # Database connection & SHA-256 hashing
│           └── servlet/
│               ├── AddQuestionServlet.java   # /addQuestion
│               ├── PublishQuizServlet.java   # /publishQuiz
│               ├── DeleteQuestionServlet.java # /deleteQuestion
│               ├── JoinQuizServlet.java      # /joinQuiz
│               ├── QuizServlet.java          # /quiz
│               └── ResultServlet.java        # /submitQuiz
│
├── webapp/
│   ├── index.jsp                   # Home page (Admin & Student cards)
│   ├── admin.jsp                   # Admin dashboard (Add, view, publish)
│   ├── student.jsp                 # Student login & password portal
│   ├── quiz.jsp                    # Student quiz interface
│   ├── result.jsp                  # Score and evaluation report
│   ├── css/
│   │   └── style.css               # Clean, responsive styles
│   └── WEB-INF/
│       └── web.xml                 # Web descriptor & servlet mappings
│
└── README.md                       # Project documentation & execution guide
```

---

## 3. Database Setup (MySQL)

1. Open your MySQL client (MySQL Workbench, MySQL Command Line Client, or phpMyAdmin).
2. Execute the script in `database/schema.sql` or run the following commands:

```sql
CREATE DATABASE IF NOT EXISTS online_quiz;
USE online_quiz;

-- Table: questions
CREATE TABLE IF NOT EXISTS questions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT NOT NULL,
    option1 VARCHAR(255) NOT NULL,
    option2 VARCHAR(255) NOT NULL,
    option3 VARCHAR(255) NOT NULL,
    option4 VARCHAR(255) NOT NULL,
    answer INT NOT NULL
);

-- Table: results
CREATE TABLE IF NOT EXISTS results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    score INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: quiz_settings
CREATE TABLE IF NOT EXISTS quiz_settings (
    id INT PRIMARY KEY,
    joining_password VARCHAR(255) DEFAULT '',
    is_published BOOLEAN DEFAULT FALSE
);

-- Initialize default settings row (id = 1)
INSERT INTO quiz_settings (id, joining_password, is_published)
VALUES (1, '', FALSE)
ON DUPLICATE KEY UPDATE id=1;
```

---

## 4. Database Configuration

Edit `src/com/quiz/util/DBConnection.java` to match your local MySQL credentials:

```java
private static final String JDBC_URL = "jdbc:mysql://localhost:3306/online_quiz?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
private static final String DB_USER = "root";       // Change if your MySQL username is different
private static final String DB_PASSWORD = "root";   // Change to your MySQL password
```

---

## 5. Dependencies

- **Java JDK**: 8, 11, 17, or 21.
- **Servlet Container**: Apache Tomcat 9.x (recommended for standard `javax.servlet` college curriculum) or Tomcat 8.5.x.
- **MySQL JDBC Driver**: `mysql-connector-j-8.x.x.jar` (or `mysql-connector-java-5.1.x.jar`).
  - Place `mysql-connector-j-*.jar` into Apache Tomcat's `lib/` directory OR into your project's `webapp/WEB-INF/lib/` directory.

---

## 6. How to Run

### Method A: Using Eclipse IDE for Java EE Developers
1. Open Eclipse -> **File** -> **New** -> **Dynamic Web Project**.
2. Name the project `OnlineQuiz`. Select Apache Tomcat 9 as the Target Runtime.
3. Copy the Java source files from `src/` to Eclipse's `src` folder.
4. Copy the contents of `webapp/` into Eclipse's `WebContent` (or `src/main/webapp`).
5. Copy `mysql-connector-j.jar` into `WEB-INF/lib/`.
6. Right click on `index.jsp` -> **Run As** -> **Run on Server** -> Select Tomcat.

### Method B: Using NetBeans IDE
1. Open NetBeans -> **File** -> **New Project** -> **Java Web** -> **Web Application**.
2. Set Apache Tomcat as the server.
3. Place `src` files in Source Packages and `webapp` files in Web Pages.
4. Add the MySQL JDBC Driver to Project Libraries.
5. Click **Run Project**.

### Method C: Deploying directly to Apache Tomcat (WAR file or directory)
1. Compile your Java files into `webapp/WEB-INF/classes/`:
   ```bash
   javac -cp "C:\path\to\tomcat\lib\servlet-api.jar;C:\path\to\mysql-connector-j.jar" -d webapp/WEB-INF/classes src/com/quiz/model/*.java src/com/quiz/util/*.java src/com/quiz/servlet/*.java
   ```
2. Copy `mysql-connector-j-*.jar` into `webapp/WEB-INF/lib/`.
3. Copy the `webapp` folder into your Tomcat `webapps/` directory and rename it to `OnlineQuiz`.
4. Start Tomcat (`bin/startup.bat`).
5. Open your browser and visit: `http://localhost:8080/OnlineQuiz/`

---

## 7. How to Test the Application

1. **Visit Home Page**: `http://localhost:8080/OnlineQuiz/`
2. **Go to Admin Section**:
   - Add 2-3 questions with 4 options each and choose the correct answer.
   - You will see the questions listed below.
   - Enter a joining password (e.g. `quiz123`) in the **Publish Quiz** box and click **Publish Quiz**.
3. **Go to Student Section**:
   - Enter student name (e.g. `Alex`) and the joining password (`quiz123`).
   - Click **Join Quiz**.
   - Select your answers and click **Submit Quiz**.
4. **View Score**:
   - The result page immediately displays your score (e.g. `Score: 3 / 3 (100%)`).

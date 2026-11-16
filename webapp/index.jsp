<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Quiz Application - Home</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- Header Navigation -->
    <header class="navbar">
        <a href="index.jsp" class="nav-brand">
            <span>&#128218;</span> Online Quiz Portal
        </a>
        <nav class="nav-links">
            <a href="index.jsp" class="nav-link active">Home</a>
            <a href="student.jsp" class="nav-link">Student</a>
            <a href="admin.jsp" class="nav-link">Admin</a>
        </nav>
    </header>

    <!-- Main Content Container -->
    <main class="container">
        <div class="page-header">
            <h1 class="page-title">Welcome to the Online Quiz Portal</h1>
            <p class="page-subtitle">A simple and secure platform for conducting online assessments</p>
        </div>

        <!-- Two Main Sections: Admin and Student -->
        <div class="portal-grid">
            
            <!-- Student Portal Card -->
            <div class="portal-card">
                <div class="portal-icon student-icon">
                    <span>&#127891;</span>
                </div>
                <h2 class="portal-title">Student Section</h2>
                <p class="portal-desc">
                    Attempt the published quiz by entering your name and the joining password provided by the instructor.
                </p>
                <a href="student.jsp" class="btn btn-primary btn-block">Enter Student Portal</a>
            </div>

            <!-- Admin Portal Card -->
            <div class="portal-card">
                <div class="portal-icon admin-icon">
                    <span>&#9881;</span>
                </div>
                <h2 class="portal-title">Admin Section</h2>
                <p class="portal-desc">
                    Direct access to create questions, set joining passwords, manage the question bank, and publish quizzes.
                </p>
                <a href="admin.jsp" class="btn btn-secondary btn-block">Enter Admin Section</a>
            </div>

        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <p>Online Quiz Application &copy; 2026 | Built with Java Servlets, JSP & MySQL</p>
    </footer>

</body>
</html>

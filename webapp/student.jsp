<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Section - Online Quiz</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- Header Navigation -->
    <header class="navbar">
        <a href="index.jsp" class="nav-brand">
            <span>&#128218;</span> Online Quiz Portal
        </a>
        <nav class="nav-links">
            <a href="index.jsp" class="nav-link">Home</a>
            <a href="student.jsp" class="nav-link active">Student</a>
            <a href="admin.jsp" class="nav-link">Admin</a>
        </nav>
    </header>

    <main class="container">
        
        <div class="page-header">
            <h1 class="page-title">Student Quiz Portal</h1>
            <p class="page-subtitle">Enter your name and the quiz joining password to begin your test</p>
        </div>

        <div style="max-width: 480px; margin: 0 auto;">
            
            <!-- Error message banner if authentication fails or quiz not published -->
            <%
                String errorMsg = (String) request.getAttribute("errorMessage");
                if (errorMsg == null) {
                    errorMsg = (String) session.getAttribute("errorMessage");
                    session.removeAttribute("errorMessage");
                }
                if (errorMsg != null) {
            %>
                <div class="alert alert-danger">
                    <span>&#9888;</span> <%= errorMsg %>
                </div>
            <%
                }
            %>

            <!-- Student Login / Join Card -->
            <div class="card">
                <div style="text-align: center; margin-bottom: 1.5rem;">
                    <div class="portal-icon student-icon" style="margin: 0 auto 1rem auto;">
                        <span>&#127891;</span>
                    </div>
                    <h2 style="font-size: 1.35rem; color: var(--text-main);">Join Active Quiz</h2>
                    <p style="color: var(--text-muted); font-size: 0.9rem;">
                        Make sure you have the joining password from your instructor.
                    </p>
                </div>

                <form action="joinQuiz" method="post">
                    
                    <div class="form-group">
                        <label class="form-label" for="studentName">Your Full Name *</label>
                        <input type="text" class="form-input" id="studentName" name="studentName" placeholder="e.g. John Doe" required autofocus>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="joiningPassword">Quiz Joining Password *</label>
                        <input type="password" class="form-input" id="joiningPassword" name="joiningPassword" placeholder="Enter joining password" required>
                    </div>

                    <div style="margin-top: 1.5rem;">
                        <button type="submit" class="btn btn-primary btn-block">Join Quiz &rarr;</button>
                    </div>
                </form>

                <div style="text-align: center; margin-top: 1.25rem;">
                    <a href="index.jsp" style="color: var(--text-muted); text-decoration: none; font-size: 0.85rem;">
                        &larr; Back to Home
                    </a>
                </div>
            </div>

        </div>

    </main>

    <footer class="footer">
        <p>Online Quiz Application &copy; 2026 | Student Assessment</p>
    </footer>

</body>
</html>

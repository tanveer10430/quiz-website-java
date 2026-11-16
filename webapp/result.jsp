<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String studentName = (String) request.getAttribute("studentName");
    Integer totalQuestions = (Integer) request.getAttribute("totalQuestions");
    Integer correctAnswers = (Integer) request.getAttribute("correctAnswers");
    Integer incorrectOrUnanswered = (Integer) request.getAttribute("incorrectOrUnanswered");
    Integer score = (Integer) request.getAttribute("score");

    // Fallback if page is accessed directly without submitting
    if (totalQuestions == null || score == null) {
        response.sendRedirect("student.jsp");
        return;
    }

    int percentage = (totalQuestions > 0) ? (int) Math.round(((double) score / totalQuestions) * 100) : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Results - Online Quiz Application</title>
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
            <a href="student.jsp" class="nav-link">Student</a>
            <a href="admin.jsp" class="nav-link">Admin</a>
        </nav>
    </header>

    <main class="container">
        
        <div class="result-card">
            
            <div style="font-size: 2.5rem; margin-bottom: 0.5rem;">&#127881;</div>
            <h1 style="font-size: 1.8rem; color: var(--text-main); margin-bottom: 0.25rem;">Quiz Completed!</h1>
            <p style="color: var(--text-muted); font-size: 1rem;">
                Assessment report for candidate: <strong><%= studentName %></strong>
            </p>

            <!-- Circular Score Display -->
            <div class="score-circle">
                <span class="score-number"><%= score %></span>
                <span class="score-label">OUT OF <%= totalQuestions %></span>
            </div>

            <div style="font-size: 1.1rem; font-weight: 600; color: <%= (percentage >= 50) ? "var(--success)" : "var(--danger)" %>; margin-bottom: 1.5rem;">
                Score: <%= score %> / <%= totalQuestions %> (<%= percentage %>%)
            </div>

            <!-- Detailed Metrics Grid -->
            <div class="stat-grid">
                <div class="stat-item">
                    <div class="stat-val"><%= totalQuestions %></div>
                    <div class="stat-label">Total Questions</div>
                </div>

                <div class="stat-item">
                    <div class="stat-val" style="color: var(--success);"><%= correctAnswers %></div>
                    <div class="stat-label">Correct Answers</div>
                </div>

                <div class="stat-item">
                    <div class="stat-val" style="color: var(--danger);"><%= incorrectOrUnanswered %></div>
                    <div class="stat-label">Incorrect / Unanswered</div>
                </div>
            </div>

            <!-- Navigation Actions -->
            <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                <a href="student.jsp" class="btn btn-secondary">Student Section</a>
                <a href="index.jsp" class="btn btn-primary">Return to Home</a>
            </div>

        </div>

    </main>

    <footer class="footer">
        <p>Online Quiz Application &copy; 2026 | Results Evaluation Module</p>
    </footer>

</body>
</html>

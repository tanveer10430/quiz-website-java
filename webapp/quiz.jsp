<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.quiz.model.Question" %>
<%
    // Ensure student is authorized to view quiz
    Boolean isAuthorized = (Boolean) session.getAttribute("isQuizAuthorized");
    if (isAuthorized == null || !isAuthorized) {
        response.sendRedirect("student.jsp");
        return;
    }

    String studentName = (String) session.getAttribute("studentName");
    List<Question> questions = (List<Question>) request.getAttribute("questions");

    // If directly accessed without hitting QuizServlet, forward to servlet
    if (questions == null) {
        response.sendRedirect("quiz");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Active Quiz - Online Quiz Application</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <!-- Header Navigation -->
    <header class="navbar">
        <a href="index.jsp" class="nav-brand">
            <span>&#128218;</span> Online Quiz Portal
        </a>
        <div style="font-weight: 500; font-size: 0.95rem; color: var(--text-main);">
            Candidate: <strong><%= studentName %></strong>
        </div>
    </header>

    <main class="container">
        
        <div class="page-header" style="text-align: left; margin-bottom: 1.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: baseline; flex-wrap: wrap;">
                <div>
                    <h1 class="page-title" style="font-size: 1.75rem;">Online Assessment</h1>
                    <p class="page-subtitle">Answer the questions below. You may leave questions unanswered if unsure.</p>
                </div>
                <div class="badge badge-success" style="font-size: 0.9rem; padding: 0.4rem 0.9rem;">
                    Total Questions: <%= questions.size() %>
                </div>
            </div>
        </div>

        <% if (questions.isEmpty()) { %>
            <div class="card" style="text-align: center; padding: 3rem;">
                <h2>No Questions Available</h2>
                <p style="color: var(--text-muted); margin: 1rem 0;">The instructor has not added questions to this quiz yet.</p>
                <a href="student.jsp" class="btn btn-secondary">Return to Student Portal</a>
            </div>
        <% } else { %>

            <form action="submitQuiz" method="post" id="quizForm">
                
                <%
                    int qIndex = 1;
                    for (Question q : questions) {
                %>
                
                <div class="quiz-question-card">
                    <div class="question-number">Question <%= qIndex %> of <%= questions.size() %></div>
                    <div class="question-text"><%= q.getQuestion() %></div>

                    <div class="option-group">
                        <label class="option-label">
                            <input type="radio" name="q_<%= q.getId() %>" value="1">
                            <span><strong>A.</strong> <%= q.getOption1() %></span>
                        </label>

                        <label class="option-label">
                            <input type="radio" name="q_<%= q.getId() %>" value="2">
                            <span><strong>B.</strong> <%= q.getOption2() %></span>
                        </label>

                        <label class="option-label">
                            <input type="radio" name="q_<%= q.getId() %>" value="3">
                            <span><strong>C.</strong> <%= q.getOption3() %></span>
                        </label>

                        <label class="option-label">
                            <input type="radio" name="q_<%= q.getId() %>" value="4">
                            <span><strong>D.</strong> <%= q.getOption4() %></span>
                        </label>
                    </div>
                </div>

                <%
                        qIndex++;
                    }
                %>

                <!-- Submission Controls -->
                <div class="card" style="text-align: center; padding: 2rem; margin-top: 2rem;">
                    <p style="color: var(--text-muted); margin-bottom: 1.25rem;">
                        Review your answers carefully. Once submitted, your score will be calculated and saved immediately.
                    </p>
                    <button type="submit" class="btn btn-primary btn-block" style="max-width: 320px; margin: 0 auto; font-size: 1.1rem; padding: 0.85rem;" onclick="return confirm('Are you sure you want to submit your quiz?');">
                        Submit Quiz &rarr;
                    </button>
                </div>

            </form>

        <% } %>

    </main>

    <footer class="footer">
        <p>Online Quiz Application &copy; 2026 | Candidate: <%= studentName %></p>
    </footer>

</body>
</html>

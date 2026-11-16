<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.quiz.util.DBConnection, com.quiz.model.Question" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Section - Online Quiz</title>
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
            <a href="admin.jsp" class="nav-link active">Admin</a>
        </nav>
    </header>

    <main class="container">
        
        <div class="page-header">
            <h1 class="page-title">Admin Dashboard</h1>
            <p class="page-subtitle">Add quiz questions, set the student joining password, and publish the quiz</p>
        </div>

        <!-- Success/Error Feedback Messages -->
        <%
            String successMsg = (String) session.getAttribute("successMessage");
            String errorMsg = (String) session.getAttribute("errorMessage");
            session.removeAttribute("successMessage");
            session.removeAttribute("errorMessage");

            if (successMsg != null) {
        %>
            <div class="alert alert-success">
                <span>&#10004;</span> <%= successMsg %>
            </div>
        <%
            }
            if (errorMsg != null) {
        %>
            <div class="alert alert-danger">
                <span>&#9888;</span> <%= errorMsg %>
            </div>
        <%
            }
        %>

        <%
            // Fetch quiz status and questions directly from the database
            boolean isPublished = false;
            int totalQuestions = 0;
            List<Question> questionList = new ArrayList<>();

            try (Connection conn = DBConnection.getConnection()) {
                // Fetch settings
                String settingsSql = "SELECT is_published FROM quiz_settings WHERE id = 1";
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery(settingsSql)) {
                    if (rs.next()) {
                        isPublished = rs.getBoolean("is_published");
                    }
                }

                // Fetch questions
                String questionsSql = "SELECT id, question, option1, option2, option3, option4, answer FROM questions ORDER BY id ASC";
                try (Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery(questionsSql)) {
                    while (rs.next()) {
                        Question q = new Question(
                            rs.getInt("id"),
                            rs.getString("question"),
                            rs.getString("option1"),
                            rs.getString("option2"),
                            rs.getString("option3"),
                            rs.getString("option4"),
                            rs.getInt("answer")
                        );
                        questionList.add(q);
                    }
                }
                totalQuestions = questionList.size();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Database Error: " + e.getMessage() + "</div>");
            }
        %>

        <!-- Status Overview Card -->
        <div class="card" style="margin-bottom: 1.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: gap: 10px;">
                <div>
                    <strong>Total Questions Added:</strong> <%= totalQuestions %> &nbsp;|&nbsp;
                    <strong>Current Quiz Status:</strong> 
                    <% if (isPublished) { %>
                        <span class="badge badge-success">&#9679; Published & Active</span>
                    <% } else { %>
                        <span class="badge badge-warning">&#9679; Draft / Unpublished</span>
                    <% } %>
                </div>
                <% if (isPublished) { %>
                    <form action="publishQuiz" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="unpublish">
                        <button type="submit" class="btn btn-sm btn-secondary" onclick="return confirm('Are you sure you want to unpublish the quiz?');">Unpublish Quiz</button>
                    </form>
                <% } %>
            </div>
        </div>

        <!-- Section 1: Add New Question Form -->
        <div class="card">
            <h2 class="card-title">Add New Question</h2>
            
            <form action="addQuestion" method="post">
                <div class="form-group">
                    <label class="form-label" for="question">Question Text *</label>
                    <textarea class="form-textarea" id="question" name="question" placeholder="Enter your question here..." required></textarea>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="option1">Option 1 *</label>
                        <input type="text" class="form-input" id="option1" name="option1" placeholder="Enter option 1" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="option2">Option 2 *</label>
                        <input type="text" class="form-input" id="option2" name="option2" placeholder="Enter option 2" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label" for="option3">Option 3 *</label>
                        <input type="text" class="form-input" id="option3" name="option3" placeholder="Enter option 3" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="option4">Option 4 *</label>
                        <input type="text" class="form-input" id="option4" name="option4" placeholder="Enter option 4" required>
                    </div>
                </div>

                <div class="form-row" style="align-items: flex-end;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="answer">Select Correct Answer *</label>
                        <select class="form-select" id="answer" name="answer" required>
                            <option value="">-- Choose correct option --</option>
                            <option value="1">Option 1</option>
                            <option value="2">Option 2</option>
                            <option value="3">Option 3</option>
                            <option value="4">Option 4</option>
                        </select>
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <button type="submit" class="btn btn-primary btn-block">+ Add Question</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Section 2: View Questions Already Added -->
        <div class="card">
            <h2 class="card-title">Questions in Current Quiz (<%= totalQuestions %>)</h2>

            <% if (questionList.isEmpty()) { %>
                <p style="color: var(--text-muted); text-align: center; padding: 1.5rem;">No questions added yet. Use the form above to add your first question.</p>
            <% } else { %>
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 5%;">#</th>
                                <th style="width: 40%;">Question</th>
                                <th style="width: 40%;">Options</th>
                                <th style="width: 10%;">Correct</th>
                                <th style="width: 5%;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int idx = 1;
                                for (Question q : questionList) {
                            %>
                            <tr>
                                <td><%= idx++ %></td>
                                <td><strong><%= q.getQuestion() %></strong></td>
                                <td>
                                    <div>1: <%= q.getOption1() %></div>
                                    <div>2: <%= q.getOption2() %></div>
                                    <div>3: <%= q.getOption3() %></div>
                                    <div>4: <%= q.getOption4() %></div>
                                </td>
                                <td>
                                    <span class="badge badge-success">Option <%= q.getAnswer() %></span>
                                </td>
                                <td>
                                    <form action="deleteQuestion" method="post" style="display:inline;" onsubmit="return confirm('Delete this question?');">
                                        <input type="hidden" name="id" value="<%= q.getId() %>">
                                        <button type="submit" class="btn btn-sm btn-danger">&#128465;</button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

        <!-- Section 3: Set Joining Password & Publish Quiz -->
        <div class="card" style="border-top: 4px solid var(--success);">
            <h2 class="card-title">Publish Quiz for Students</h2>
            <p style="color: var(--text-muted); margin-bottom: 1.25rem;">
                Set a joining password that students will need to enter to attempt this quiz. Once published, students can immediately take the quiz.
            </p>

            <form action="publishQuiz" method="post">
                <div class="form-row" style="align-items: flex-end;">
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label" for="joiningPassword">Student Joining Password *</label>
                        <input type="password" class="form-input" id="joiningPassword" name="joiningPassword" placeholder="Set a joining password for students" required>
                    </div>

                    <div class="form-group" style="margin-bottom: 0;">
                        <button type="submit" class="btn btn-success btn-block" <%= questionList.isEmpty() ? "disabled title='Add at least one question first'" : "" %>>
                            &#128640; Publish Quiz
                        </button>
                    </div>
                </div>
                <% if (questionList.isEmpty()) { %>
                    <p style="color: var(--danger); font-size: 0.85rem; margin-top: 0.5rem;">
                        Note: You must add at least one question before you can publish the quiz.
                    </p>
                <% } %>
            </form>
        </div>

    </main>

    <footer class="footer">
        <p>Online Quiz Application &copy; 2026 | Admin Management</p>
    </footer>

</body>
</html>

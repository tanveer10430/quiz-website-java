package com.quiz.servlet;

import com.quiz.util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/submitQuiz")
public class ResultServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        // Security check: verify student session
        if (session == null || session.getAttribute("isQuizAuthorized") == null ||
            !(Boolean) session.getAttribute("isQuizAuthorized")) {
            response.sendRedirect("student.jsp");
            return;
        }

        String studentName = (String) session.getAttribute("studentName");
        if (studentName == null || studentName.trim().isEmpty()) {
            studentName = "Anonymous Student";
        }

        int totalQuestions = 0;
        int correctAnswers = 0;

        // Query the database to retrieve true correct answers for evaluation
        String fetchAnswersSql = "SELECT id, answer FROM questions ORDER BY id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(fetchAnswersSql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                totalQuestions++;
                int questionId = rs.getInt("id");
                int correctAnswer = rs.getInt("answer");

                // Get the student's selected answer from the submitted form
                String selectedOptionStr = request.getParameter("q_" + questionId);
                if (selectedOptionStr != null && !selectedOptionStr.trim().isEmpty()) {
                    try {
                        int selectedOption = Integer.parseInt(selectedOptionStr.trim());
                        if (selectedOption == correctAnswer) {
                            correctAnswers++;
                        }
                    } catch (NumberFormatException ignored) {
                    }
                }
            }

            int incorrectOrUnanswered = totalQuestions - correctAnswers;
            int score = correctAnswers;

            // Save student score into results table
            String saveResultSql = "INSERT INTO results (student_name, score) VALUES (?, ?)";
            try (PreparedStatement saveStmt = conn.prepareStatement(saveResultSql)) {
                saveStmt.setString(1, studentName);
                saveStmt.setInt(2, score);
                saveStmt.executeUpdate();
            }

            // Remove quiz authorization so test cannot be re-submitted without re-joining
            session.removeAttribute("isQuizAuthorized");

            // Pass results to JSP
            request.setAttribute("studentName", studentName);
            request.setAttribute("totalQuestions", totalQuestions);
            request.setAttribute("correctAnswers", correctAnswers);
            request.setAttribute("incorrectOrUnanswered", incorrectOrUnanswered);
            request.setAttribute("score", score);

            request.getRequestDispatcher("result.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error evaluating quiz submission: " + e.getMessage());
            request.getRequestDispatcher("student.jsp").forward(request, response);
        }
    }
}

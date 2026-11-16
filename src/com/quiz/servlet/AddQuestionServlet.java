package com.quiz.servlet;

import com.quiz.util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/addQuestion")
public class AddQuestionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String question = request.getParameter("question");
        String option1 = request.getParameter("option1");
        String option2 = request.getParameter("option2");
        String option3 = request.getParameter("option3");
        String option4 = request.getParameter("option4");
        String answerStr = request.getParameter("answer");

        // Server-side validation
        if (question == null || question.trim().isEmpty() ||
            option1 == null || option1.trim().isEmpty() ||
            option2 == null || option2.trim().isEmpty() ||
            option3 == null || option3.trim().isEmpty() ||
            option4 == null || option4.trim().isEmpty() ||
            answerStr == null || answerStr.trim().isEmpty()) {

            request.getSession().setAttribute("errorMessage", "All fields are required. Please fill in the complete question details.");
            response.sendRedirect("admin.jsp");
            return;
        }

        int answer;
        try {
            answer = Integer.parseInt(answerStr.trim());
            if (answer < 1 || answer > 4) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Please select a valid correct answer option (1-4).");
            response.sendRedirect("admin.jsp");
            return;
        }

        // Insert into database using prepared statement
        String sql = "INSERT INTO questions (question, option1, option2, option3, option4, answer) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, question.trim());
            stmt.setString(2, option1.trim());
            stmt.setString(3, option2.trim());
            stmt.setString(4, option3.trim());
            stmt.setString(5, option4.trim());
            stmt.setInt(6, answer);

            stmt.executeUpdate();

            request.getSession().setAttribute("successMessage", "Question added successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Database error while adding question: " + e.getMessage());
        }

        response.sendRedirect("admin.jsp");
    }
}

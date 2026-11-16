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

@WebServlet("/joinQuiz")
public class JoinQuizServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String studentName = request.getParameter("studentName");
        String joiningPassword = request.getParameter("joiningPassword");

        // Validate student name
        if (studentName == null || studentName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter your name to proceed.");
            request.getRequestDispatcher("student.jsp").forward(request, response);
            return;
        }

        // Validate joining password
        if (joiningPassword == null || joiningPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter the quiz joining password.");
            request.getRequestDispatcher("student.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT joining_password, is_published FROM quiz_settings WHERE id = 1";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {
                    boolean isPublished = rs.getBoolean("is_published");
                    String storedHashedPassword = rs.getString("joining_password");

                    // 1. Check if quiz is published
                    if (!isPublished) {
                        request.setAttribute("errorMessage", "The quiz is not available yet. Please check back later.");
                        request.getRequestDispatcher("student.jsp").forward(request, response);
                        return;
                    }

                    // 2. Check if password matches
                    String hashedInput = DBConnection.hashPassword(joiningPassword.trim());
                    if (!hashedInput.equals(storedHashedPassword)) {
                        request.setAttribute("errorMessage", "Incorrect joining password. Please try again.");
                        request.getRequestDispatcher("student.jsp").forward(request, response);
                        return;
                    }

                    // Store student in session and mark as authorized for this quiz
                    HttpSession session = request.getSession();
                    session.setAttribute("studentName", studentName.trim());
                    session.setAttribute("isQuizAuthorized", true);

                    // Redirect to quiz servlet
                    response.sendRedirect("quiz");
                    return;
                } else {
                    request.setAttribute("errorMessage", "Quiz is not configured yet. Please contact the administrator.");
                    request.getRequestDispatcher("student.jsp").forward(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database connection error: " + e.getMessage());
            request.getRequestDispatcher("student.jsp").forward(request, response);
        }
    }
}

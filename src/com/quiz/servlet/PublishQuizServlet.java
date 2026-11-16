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

@WebServlet("/publishQuiz")
public class PublishQuizServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // Allow unpublishing if admin chooses to unpublish
        if ("unpublish".equalsIgnoreCase(action)) {
            String unpublishSql = "UPDATE quiz_settings SET is_published = FALSE WHERE id = 1";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(unpublishSql)) {
                stmt.executeUpdate();
                request.getSession().setAttribute("successMessage", "Quiz has been unpublished successfully.");
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMessage", "Error unpublishing quiz: " + e.getMessage());
            }
            response.sendRedirect("admin.jsp");
            return;
        }

        String joiningPassword = request.getParameter("joiningPassword");

        // Server-side validation: Password cannot be empty
        if (joiningPassword == null || joiningPassword.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Joining password cannot be empty. Please set a password.");
            response.sendRedirect("admin.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // Check if at least one question exists
            String countSql = "SELECT COUNT(*) AS total FROM questions";
            try (PreparedStatement countStmt = conn.prepareStatement(countSql);
                 ResultSet rs = countStmt.executeQuery()) {
                if (rs.next() && rs.getInt("total") == 0) {
                    request.getSession().setAttribute("errorMessage", "Cannot publish an empty quiz. Please add at least one question first.");
                    response.sendRedirect("admin.jsp");
                    return;
                }
            }

            // Hash joining password securely with SHA-256
            String hashedPassword = DBConnection.hashPassword(joiningPassword.trim());

            // Save or update settings in quiz_settings table
            String updateSql = "INSERT INTO quiz_settings (id, joining_password, is_published) VALUES (1, ?, TRUE) "
                    + "ON DUPLICATE KEY UPDATE joining_password = VALUES(joining_password), is_published = TRUE";

            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setString(1, hashedPassword);
                updateStmt.executeUpdate();
            }

            request.getSession().setAttribute("successMessage", "Quiz published successfully! Students can now join with the password.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Database error while publishing quiz: " + e.getMessage());
        }

        response.sendRedirect("admin.jsp");
    }
}

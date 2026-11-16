package com.quiz.servlet;

import com.quiz.model.Question;
import com.quiz.util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Security check: ensure student entered name and correct password
        if (session == null || session.getAttribute("isQuizAuthorized") == null ||
            !(Boolean) session.getAttribute("isQuizAuthorized")) {
            response.sendRedirect("student.jsp");
            return;
        }

        List<Question> questionList = new ArrayList<>();

        // Load all questions without exposing correct answers
        String sql = "SELECT id, question, option1, option2, option3, option4 FROM questions ORDER BY id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("id"));
                q.setQuestion(rs.getString("question"));
                q.setOption1(rs.getString("option1"));
                q.setOption2(rs.getString("option2"));
                q.setOption3(rs.getString("option3"));
                q.setOption4(rs.getString("option4"));
                // Notice: answer is deliberately not retrieved or set here
                questionList.add(q);
            }

            request.setAttribute("questions", questionList);
            request.getRequestDispatcher("quiz.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading quiz questions: " + e.getMessage());
            request.getRequestDispatcher("student.jsp").forward(request, response);
        }
    }
}

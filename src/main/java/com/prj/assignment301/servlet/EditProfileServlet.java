/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.UserDAO;
import com.prj.assignment301.javabean.EditUserErrors;
import com.prj.assignment301.javabean.Notification;
import com.prj.assignment301.model.User;
import com.prj.assignment301.utils.AppPaths;
import com.prj.assignment301.utils.Constants;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author LAPTOP
 */
@MultipartConfig
public class EditProfileServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher(AppPaths.EDIT_USER_JSP);
        rd.forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve updated user information from request parameters
        String name = request.getParameter("name");
        String password = request.getParameter("newPassword");
        String retypePassword = request.getParameter("retypePassword");

        // Retrieve user object from session
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        EditUserErrors errorObj = new EditUserErrors();
        RequestDispatcher dispatcher = null;
        Notification notification = null;

        // Validate name
        if (name == null || name.trim().isEmpty()) {
            errorObj.setNameErr("Name is required");
        }
        errorObj.setName(name);

        // Validate password and retype password
        if (password != null && !password.trim().isEmpty()) {
            if (password.length() < 6) {
                errorObj.setPasswordErr("Password must be at least 6 characters long");
            }

            if (retypePassword == null || retypePassword.trim().isEmpty()) {
                errorObj.setRetypePasswordErr("Retype password is required");
            } else if (!retypePassword.equals(password)) {
                errorObj.setRetypePasswordErr("Passwords do not match");
            }
        }

        // If there is an error, forward error back to the page
        if (errorObj.getNameErr() != null || errorObj.getPasswordErr() != null || errorObj.getRetypePasswordErr() != null) {
            request.setAttribute("ERRORS", errorObj);
            dispatcher = request.getRequestDispatcher(AppPaths.EDIT_USER_JSP);
            dispatcher.forward(request, response);
            return;
        }

        if (user != null) {
            // Update user in database
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updateUser(name, password != null && !password.trim().isEmpty() ? password : user.getPassword(), user);

            if (success) {
                // Update succeed

                // Update session data
                String pw = password != null && !password.trim().isEmpty() ? password : user.getPassword();
                user.setName(name);
                user.setPassword(pw);

                notification = new Notification("Success", "Update successfully", "success");
                request.setAttribute("notifications", notification);
                dispatcher = request.getRequestDispatcher(AppPaths.EDIT_USER_JSP);
                dispatcher.forward(request, response);
            } else {
                // Update failed
                notification = new Notification("Error", "Something went wrong. Please try again", "error");
                request.setAttribute("notifications", notification);
                dispatcher = request.getRequestDispatcher(AppPaths.EDIT_USER_JSP);
                dispatcher.forward(request, response);
            }
        } else {
            // Handle user not found in session
            notification = new Notification("Error", "User is not authorized", "error");
            request.setAttribute("notifications", notification);
            dispatcher = request.getRequestDispatcher(AppPaths.EDIT_USER_JSP);
            dispatcher.forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}

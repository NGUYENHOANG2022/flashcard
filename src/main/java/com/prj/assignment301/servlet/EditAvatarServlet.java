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
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author LAPTOP
 */
public class EditAvatarServlet extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");

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
        RequestDispatcher rd = request.getRequestDispatcher(AppPaths.EDIT_AVATAR_JSP);
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
        // Get the request dispatcher and the avatar parameter
        RequestDispatcher rd = request.getRequestDispatcher(AppPaths.EDIT_AVATAR_JSP);
        String avatar = request.getParameter("avatar");

        // Get the user object from the session and the UserDAO object
        UserDAO userDao = new UserDAO();
        User user = (User) request.getSession(false).getAttribute(Constants.SESSION_USER);

        // Check if the avatar parameter is null or empty
        if (avatar == null || avatar.trim().isEmpty()) {

            // Generate the default avatar URL using the user's name
            String defaultAvatar = "https://api.dicebear.com/5.x/adventurer/svg?seed=" + user.getName();

            // Update the user's avatar URL in the database
            userDao.updateUserAvatar(user.getUserId(), defaultAvatar);

            // Update the user's avatar URL in the current session
            user.setAvatar(defaultAvatar);

            // Set a notification indicating that the default avatar was used
            request.setAttribute("notifications", new Notification("Success", "Using default avatar.", "success"));

            // Forward the request and response to the edit avatar JSP
            rd.forward(request, response);
            return;
        }

        // Check if the avatar parameter is a valid URL
        String regex = "^(http|https)://[a-zA-Z0-9\\-\\.]+(\\.[a-zA-Z]{2,})(:[0-9]+)?(/[\\w\\-./?%&=]*)?$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(avatar);

        if (matcher.matches()) {
            // The avatar is a valid URL

            // Update the user's avatar URL in the database
            boolean success = userDao.updateUserAvatar(user.getUserId(), avatar);

            if (success) {
                // Update the user's avatar URL in the current session
                user.setAvatar(avatar);

                // Set a notification indicating that the avatar was updated successfully
                request.setAttribute("notifications", new Notification("Success", "Update avatar successfully.", "success"));
            } else {
                // Set a notification indicating that the update failed
                request.setAttribute("notifications", new Notification("Error", "Something went wrong. Please try again", "error"));
            }
        } else {
            // The avatar is not a valid URL

            // Set an EditUserErrors object with an error message for the avatar parameter
            EditUserErrors errObj = new EditUserErrors();
            errObj.setAvatarErr("Invalid url pattern! Please follow the instruction.");
            errObj.setAvatar(avatar);
            request.setAttribute("ERRORS", errObj);
        }

        // Forward the request and response to the edit avatar JSP
        rd.forward(request, response);
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

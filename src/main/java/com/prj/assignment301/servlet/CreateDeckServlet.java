/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.DeckDAO;
import com.prj.assignment301.javabean.Notification;
import com.prj.assignment301.model.Deck;
import com.prj.assignment301.model.User;
import com.prj.assignment301.utils.AppPaths;
import com.prj.assignment301.utils.Constants;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author LAPTOP
 */
public class CreateDeckServlet extends HttpServlet {

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
        processRequest(request, response);
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
    String name = request.getParameter("name");
    String description = request.getParameter("description");
    String visibility = request.getParameter("visibility");
    int privateDeck = 0;
    HttpSession session = request.getSession(false);
    User user = null;
    RequestDispatcher rd = request.getRequestDispatcher(AppPaths.CREATE_DECK_JSP);

    if (visibility.equals("private")) {
        privateDeck = 1;
    }

    if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
        user = (User) session.getAttribute(Constants.SESSION_USER);
    }

    if (name.isEmpty()) {
        Notification e = new Notification("Error", "Name can't be left blank!", "error");
        request.setAttribute("notifications", e);
        rd.forward(request, response);
        return;
    }

    if (name.length() > 40) {
        Notification e = new Notification("Error", "Name can only contain up to 40 characters", "error");
        request.setAttribute("notifications", e);
        rd.forward(request, response);
        return;
    }

    if (description.length() > 200) {
        Notification e = new Notification("Error", "Description can only contain up to 200 characters", "error");
        request.setAttribute("notifications", e);
        rd.forward(request, response);
        return;
    }

    DeckDAO decksDAO = new DeckDAO();
    Deck newDeck = decksDAO.createDeck(name, description, privateDeck, user);

    if (newDeck != null) {
        response.sendRedirect(request.getContextPath() + AppPaths.HOME + "?success=Create deck successfully");
    } else {
        Notification e = new Notification("Error", "Create deck error!", "error");
        request.setAttribute("notifications", e);
        rd.forward(request, response);
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

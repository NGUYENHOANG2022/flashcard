/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.CardDAO;
import com.prj.assignment301.javabean.CardMeta;
import com.prj.assignment301.javabean.Notification;
import com.prj.assignment301.model.User;
import com.prj.assignment301.utils.AppPaths;
import com.prj.assignment301.utils.Constants;
import java.io.IOException;
import java.io.PrintWriter;
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
public class EditCardServlet extends HttpServlet {

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

        HttpSession session = request.getSession(false);
        Notification n = null;
        RequestDispatcher rd = null;

        if (session == null || session.getAttribute(Constants.SESSION_USER) == null) {
            n = new Notification("Error", "Invalid request", "error");
            request.setAttribute("notifications", n);
            rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
            rd.forward(request, response);
            return;
        }

        User user = (User) session.getAttribute(Constants.SESSION_USER);

        String front = request.getParameter("card-front");
        String back = request.getParameter("card-back");
        String tags = request.getParameter("tags");
        String cId = request.getParameter("cardId");
        String dId = request.getParameter("deckId");
        String deckName = request.getParameter("deckName");
        String privateD = request.getParameter("privateDeck");

        CardMeta cardInfo = new CardMeta();

        cardInfo.setCardId(isNotNull(cId) ? Integer.parseInt(cId) : 0);
        cardInfo.setFront(isNotNull(front) ? front : "");
        cardInfo.setBack(isNotNull(back) ? back : "");
        cardInfo.setTags(isNotNull(tags) ? tags : "");
        cardInfo.setDeckId(isNotNull(dId) ? Integer.parseInt(dId) : 0);
        cardInfo.setDeckName(isNotNull(deckName) ? deckName : "");
        cardInfo.setPrivateDeck(isNotNull(privateD) ? Integer.parseInt(privateD) : 0);

        if (!isNotNull(front)
                || !isNotNull(back)
                || !isNotNull(dId)
                || !isNotNull(deckName)
                || !isNotNull(privateD)
                || !isNotNull(cId)) {

            n = new Notification("Error", "Please fill in all the fields", "error");
            request.setAttribute("notifications", n);
            request.setAttribute("cardInfo", cardInfo);
            rd = request.getRequestDispatcher(AppPaths.EDIT_CARD_JSP);
            rd.forward(request, response);
            return;
        }

        CardDAO cardDao = new CardDAO();
        boolean success = cardDao.updateCard(cardInfo.getFront(), cardInfo.getBack(), cardInfo.getTags(), cardInfo.getCardId(), user.getUserId());

        if (!success) {
            n = new Notification("Error", "Deck not found or you are not the owner of the deck", "error");
            request.setAttribute("notifications", n);
            request.setAttribute("cardInfo", cardInfo);
            rd = request.getRequestDispatcher(AppPaths.EDIT_CARD_JSP);
            rd.forward(request, response);
            return;
        }

        response.sendRedirect(String.format("%s%s?id=%d&success=Card updated successfully",
                request.getContextPath(), AppPaths.EDIT_CARD, cardInfo.getCardId()));
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

        String cId = request.getParameter("id");
        RequestDispatcher rd = null;
        CardDAO cardDao = new CardDAO();

        HttpSession session = request.getSession(false);
        User user = null;

        if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
            user = (User) session.getAttribute(Constants.SESSION_USER);
        }

        if (cId != null && !cId.trim().isEmpty() && user != null) {
            int cardId = Integer.parseInt(cId);
            CardMeta cardInfo = cardDao.getCard(cardId, user.getUserId());

            if (cardInfo != null) {
                request.setAttribute("cardInfo", cardInfo);
                rd = request.getRequestDispatcher(AppPaths.EDIT_CARD_JSP);
                rd.forward(request, response);
                return;
            }
        }

        // If the request does not contain a cId parameter 
        // Or user not found in db then response with a 404 page
        rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
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
        processRequest(request, response);
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

    public boolean isNotNull(String param) {
        return !(param == null || param.trim().isEmpty());
    }

}

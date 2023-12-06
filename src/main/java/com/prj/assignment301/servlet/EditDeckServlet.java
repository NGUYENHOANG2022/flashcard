/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.CardDAO;
import com.prj.assignment301.DAO.DeckDAO;
import com.prj.assignment301.javabean.DeckDetailsBean;
import com.prj.assignment301.javabean.Notification;
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
 * @author hieunghia
 */
public class EditDeckServlet extends HttpServlet {

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
		String currentPage = request.getParameter("page"); // currentPage
		String pPage = request.getParameter("perPage");
		String dId = request.getParameter("id");
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.EDIT_DECK_JSP);
		DeckDAO deckDao = new DeckDAO();
		CardDAO cardDao = new CardDAO();
		int curPage, perPage, deckId = 0;
		HttpSession session = request.getSession(false);
		int userId = 0;

		try {
			curPage = Integer.parseInt(currentPage == null || currentPage.trim().isEmpty() ? "1" : currentPage);
			perPage = Integer.parseInt(pPage == null || pPage.trim().isEmpty() ? "5" : pPage);
			deckId = Integer.parseInt(dId == null || dId.trim().isEmpty() ? "0" : dId);
		} catch (NumberFormatException e) {
			curPage = 1;
			perPage = 5;
		}

		// If deck's Id is not provided
		if (deckId < 1) {
			rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
			rd.forward(request, response);
			return;
		}

		if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
			User user = (User) session.getAttribute(Constants.SESSION_USER);
			userId = user.getUserId();
		}

		// Only allow logged in user
		if (userId < 1) {
			rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
			rd.forward(request, response);
			return;
		}

		DeckDetailsBean deck = deckDao.getDeckInfoByUserId(deckId, userId);

		// Only deck's owner can edit deck info
		if (deck == null || deck.getOwnerId() != userId) {
			rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
			rd.forward(request, response);
			return;
		}

		deck.setCardsList(cardDao.getCardsPagination(deckId, curPage, perPage));

		request.setAttribute("deckInfo", deck);
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
		String dId = request.getParameter("id");
		String name = request.getParameter("name");
		String description = request.getParameter("description");
		String visibility = request.getParameter("visibility");
		String pPage = request.getParameter("perPage");
		String currentPage = request.getParameter("page");
		int privateDeck;
		HttpSession session = request.getSession(false);
		User user = null;

		if (visibility.equals("private")) {
			privateDeck = 1;
		} else {
			privateDeck = 0;
		}

		if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
			user = (User) session.getAttribute(Constants.SESSION_USER);
		}

		DeckDAO deckDao = new DeckDAO();
		CardDAO cardDao = new CardDAO();
		Notification n;
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);

		int curPage, perPage, deckId = 0;
		try {
			curPage = Integer.parseInt(currentPage == null || currentPage.trim().isEmpty() ? "1" : currentPage);
			perPage = Integer.parseInt(pPage == null || pPage.trim().isEmpty() ? "5" : pPage);
			deckId = Integer.parseInt(dId == null || dId.trim().isEmpty() ? "0" : dId);
		} catch (NumberFormatException e) {
			curPage = 1;
			perPage = 5;
		}

		if (user == null) {
			n = new Notification("Error", "Invalid request", "error");
			request.setAttribute("notifications", n);
			rd.forward(request, response);
			return;
		}

		// If deck's Id is not provided
		if (deckId < 1) {
			n = new Notification("Error", "Invalid request", "error");
			request.setAttribute("notifications", n);
			rd.forward(request, response);
			return;
		}

		DeckDetailsBean deck = deckDao.getDeckInfoByOwnerId(deckId, user.getUserId());

		if (deck == null) {
			n = new Notification("Error", "Deck not found or you are not the owner of the deck", "error");
			request.setAttribute("notifications", n);
			rd.forward(request, response);
			return;
		}

		deck.setCardsList(cardDao.getCardsPagination(deckId, curPage, perPage));
		rd = request.getRequestDispatcher(AppPaths.EDIT_DECK_JSP);
		request.setAttribute("deckInfo", deck);

		if (!isNotNull(name)) {
			n = new Notification("Error", "Name can't be left blank!", "error");
			request.setAttribute("notifications", n);
			rd.forward(request, response);
			return;
		}

		if (name.length() > 40) {
			n = new Notification("Error", "Name can only contain up to 40 characters", "error");
			request.setAttribute("notifications", n);
			rd.forward(request, response);
			return;
		}

		if (description.length() > 200) {
			n = new Notification("Error", "Description can only contain up to 200 characters", "error");
			request.setAttribute("notifications", n);
			rd.forward(request, response);
			return;
		}

		boolean success = deckDao.updateDeck(deckId, name, description, privateDeck, user.getUserId());

		if (success) {
			response.sendRedirect(request.getContextPath() + AppPaths.DECK_DETAILS + "?id=" + deck.getDeckId() + "&success=Update deck successfully");
		} else {
			Notification e = new Notification("Error", "Update deck error! Try again later", "error");
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

	public boolean isNotNull(String param) {
		return !(param == null || param.trim().isEmpty());
	}
}

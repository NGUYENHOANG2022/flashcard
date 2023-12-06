/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.CardDAO;
import com.prj.assignment301.DAO.DeckDAO;
import com.prj.assignment301.javabean.DeckDetailsBean;
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
 * @author Admin
 */
public class DeckDetails extends HttpServlet {

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
		String currentPage = request.getParameter("page"); // currentPage
		String pPage = request.getParameter("perPage");
		String dId = request.getParameter("id");
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.DECK_DETAILS_JSP);
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

		DeckDetailsBean deck = deckDao.getDeckInfoByUserId(deckId, userId);

		if (deck == null) {
			rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
			rd.forward(request, response);
			return;
		}

		deck.setCardsList(cardDao.getCardsPagination(deckId, curPage, perPage));

		request.setAttribute("deckInfo", deck);
		rd.forward(request, response);
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
//		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.DECK_DETAILS_JSP);
//		rd.forward(request, response);
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

}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.CardDAO;
import com.prj.assignment301.javabean.BrowseBean;
import com.prj.assignment301.javabean.CardMeta;
import com.prj.assignment301.javabean.Notification;
import com.prj.assignment301.model.User;
import com.prj.assignment301.utils.AppPaths;
import com.prj.assignment301.utils.Constants;
import java.io.IOException;
import java.util.List;
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
public class BrowseServlet extends HttpServlet {

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

		String searchStr = request.getParameter("search");
		String searchBy = request.getParameter("searchBy");

		if (searchStr == null) {
			searchStr = "";
		}

		if (searchBy == null) {
			searchBy = "cardname";
		}

		int curPage = getParameterAsInt(request.getParameter("page"), 1);
		int perPage = getParameterAsInt(request.getParameter("perPage"), 10);

		RequestDispatcher rd;
		HttpSession session = request.getSession(false);

		if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
			User user = (User) session.getAttribute(Constants.SESSION_USER);

			List<CardMeta> cards = getCards(user.getUserId(), searchStr, searchBy, curPage, perPage);

			rd = request.getRequestDispatcher(AppPaths.BROWSE_JSP);

			BrowseBean browse = new BrowseBean();
			browse.setCards(cards);
			browse.setTotalCards(getCardCount(user.getUserId(), searchStr, searchBy));

			request.setAttribute("browse", browse);
		} else {
			rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
			request.setAttribute("notifications", new Notification("Error", "Invalid request", "error"));
		}

		rd.forward(request, response);
	}

	private int getParameterAsInt(String param, int defaultValue) {
		try {
			return Integer.parseInt(param);
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	private List<CardMeta> getCards(int userId, String searchStr, String searchBy, int curPage, int perPage) {
		CardDAO cardDao = new CardDAO();

		switch (searchBy.toLowerCase()) {
			case "tagname":
				return cardDao.getCardsSearchByTagName(userId, searchStr, curPage, perPage);
			case "deckname":
				return cardDao.getCardsSearchByDeckName(userId, searchStr, curPage, perPage);
			default:
				return cardDao.getCardsSearchByCardName(userId, searchStr, curPage, perPage);
		}
	}

	private int getCardCount(int userId, String searchStr, String searchBy) {
		CardDAO cardDao = new CardDAO();

		switch (searchBy.toLowerCase()) {
			case "tagname":
				return cardDao.getTotalCardsSearchByTagName(userId, searchStr);
			case "deckname":
				return cardDao.getTotalCardsSearchByDeckName(userId, searchStr);
			default:
				return cardDao.getTotalCardsSearchByCardName(userId, searchStr);
		}
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

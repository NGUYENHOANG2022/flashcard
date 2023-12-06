/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.DeckDAO;
import com.prj.assignment301.model.Deck;
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
public class DecksServlet extends HttpServlet {

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
		boolean othersDeck = Boolean.parseBoolean(request.getParameter("od"));
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.HOME_JSP);
		DeckDAO deckDao = new DeckDAO();
		HttpSession session = request.getSession(false);

		String s = searchStr == null || searchStr.trim().isEmpty() ? "" : searchStr;
		if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
			// if user logged in then return user's decks and shared decks. And recent decks
			User user = (User) session.getAttribute(Constants.SESSION_USER);
			List<Deck> decks = null;

			if (!othersDeck) {
				decks = deckDao.getDecksByUserIdWithSearch(user.getUserId(), s);
			} else {
				decks = deckDao.getPublicDecksWithSearch(s);
			}
			if (s.isEmpty() && !othersDeck) {
				List<Deck> recentDecks = deckDao.getRecentDecks(user.getUserId());
				request.setAttribute("recentDecks", recentDecks);
			}
			request.setAttribute("decks", decks);
		} else {
			// if user not logged in then return public decks
			List<Deck> decks = deckDao.getPublicDecksWithSearch(s);
			request.setAttribute("decks", decks);
		}
		request.setAttribute("search", s);
		request.setAttribute("othersDecks", othersDeck);
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
		return "Decks | Home";
	}// </editor-fold>

}

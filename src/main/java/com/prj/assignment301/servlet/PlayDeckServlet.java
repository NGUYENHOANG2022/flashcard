/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.google.gson.Gson;
import com.prj.assignment301.DAO.CardDAO;
import com.prj.assignment301.DAO.DeckDAO;
import com.prj.assignment301.model.Card;
import com.prj.assignment301.model.User;
import com.prj.assignment301.utils.AppPaths;
import com.prj.assignment301.utils.Constants;
import java.io.IOException;
import java.io.PrintWriter;
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
public class PlayDeckServlet extends HttpServlet {

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
		response.setHeader("Access-Control-Allow-Origin", "*");

		// Allow requests with these HTTP methods
		response.setHeader("Access-Control-Allow-Methods", "POST, GET, PUT, DELETE, OPTIONS");

		// Allow these headers to be sent by the client
		response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, Accept, X-Requested-With");

		// Allow session credentials to be sent by the client-side
		response.setHeader("Access-Control-Allow-Credentials", "true");

		response.setContentType("application/json");

		PrintWriter out = response.getWriter();
		String dId = request.getParameter("id");
		String uId = request.getParameter("user_id");

		// check if deck's id is not provided
		if (!isNotNull(dId)) {
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			out.println("Invalid deck ID or user ID");
			out.close();
			return;
		}

		CardDAO cardDao = new CardDAO();
		int deckId, userId;
		try {
			deckId = Integer.parseInt(dId);
			userId = isNotNull(uId) ? Integer.parseInt(uId) : 0;
		} catch (NumberFormatException e) {
			deckId = 0;
			userId = 0;
		}

		List<Card> cards = cardDao.getCardsForFlashCards(deckId, userId);

		Gson gson = new Gson();
		response.setStatus(HttpServletResponse.SC_OK);
		out.println(gson.toJson(cards));
		out.close();
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
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.PLAY_DECK_JSP);
		String dId = request.getParameter("id");
		HttpSession session = request.getSession(false);

		if (!isNotNull(dId)) {
			rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
			rd.forward(request, response);
			return;
		}

		User user = null;
		if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
			user = (User) session.getAttribute(Constants.SESSION_USER);
		}

		int deckId;
		try {
			deckId = Integer.parseInt(dId);
		} catch (NumberFormatException e) {
			deckId = 0;
		}

		DeckDAO deckDao = new DeckDAO();
		String deckName = deckDao.getDeckName(deckId, user != null ? user.getUserId() : 0);

		if (deckName.isEmpty()) {
			rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
			rd.forward(request, response);
			return;
		}
		request.setAttribute("deckName", deckName);
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

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.DeckDAO;
import com.prj.assignment301.model.User;
import com.prj.assignment301.utils.AppPaths;
import com.prj.assignment301.utils.Constants;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
public class DeleteDeckServlet extends HttpServlet {

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
		DeckDAO deckDao = new DeckDAO();
		String dId = request.getParameter("id");
		int deckId;

		try {
			deckId = Integer.parseInt(dId == null || dId.trim().isEmpty() ? "0" : dId);
		} catch (NumberFormatException e) {
			deckId = 0;
		}

		if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
			boolean success = deckDao.deleteDeck(deckId, ((User) session.getAttribute(Constants.SESSION_USER)).getUserId());
			if (success) {
				response.sendRedirect(request.getContextPath() + AppPaths.HOME + "?success=Delete deck successfully");
			} else {
				response.sendRedirect(request.getContextPath() + AppPaths.HOME + "?error=Invalid request");
			}
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

	public boolean isNotNull(String param) {
		return !(param == null || param.trim().isEmpty());
	}
}

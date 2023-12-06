/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.google.gson.Gson;
import com.prj.assignment301.DAO.DeckDAO;
import com.prj.assignment301.DAO.UserDAO;
import com.prj.assignment301.javabean.UsersDecksOverTime;
import com.prj.assignment301.utils.AppPaths;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
public class AdminDashboardServlet extends HttpServlet {

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
		Gson gson = new Gson();
		UserDAO userDao = new UserDAO();
		DeckDAO deckDao = new DeckDAO();
		
		int numOfNewUsers = userDao.getNumOfNewUsersToday();
		int numOfNewDecks = deckDao.getNumOfNewDecksToday();
		int numOfDecksStudies = deckDao.getNumOfDecksStudiesToday();
		List<UsersDecksOverTime> usersDecksOverTime = userDao.getNewUsersAndDecksOverTime();

		request.setAttribute("newUsersNum", numOfNewUsers);
		request.setAttribute("newDecksNum", numOfNewDecks);
		request.setAttribute("decksStudiesNum", numOfDecksStudies);
		request.setAttribute("chartData", gson.toJson(usersDecksOverTime));

		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.ADMIN_DASHBOARD_JSP);
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
		return "Short description";
	}// </editor-fold>

}

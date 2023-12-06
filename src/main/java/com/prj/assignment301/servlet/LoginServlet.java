/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.AdminDAO;
import com.prj.assignment301.DAO.UserDAO;
import com.prj.assignment301.javabean.LoginErrors;
import com.prj.assignment301.model.Admin;
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
 * @author nguye
 */
public class LoginServlet extends HttpServlet {

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
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
					throws ServletException, IOException {
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.LOGIN_JSP);
		rd.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
					throws ServletException, IOException {
		String email = request.getParameter("email");
		String password = request.getParameter("password");

		LoginErrors errObj = new LoginErrors();
		AdminDAO adminDAO = new AdminDAO();
		UserDAO userDAO = new UserDAO();

		// Check if email is existed in database
		if (!adminDAO.isAdminExist(email) && !userDAO.isUserExist(email)) {
			errObj.setEmailErrs("Email not exist!");
			request.setAttribute("ERRORS", errObj);
			RequestDispatcher rd = request.getRequestDispatcher(AppPaths.LOGIN_JSP);
			rd.forward(request, response);
			return;
		}

		Admin admin = adminDAO.login(email, password);
		User user = userDAO.login(email, password);

		HttpSession session = request.getSession();

		if (admin != null) {
			session.setAttribute(Constants.SESSION_ADMIN, admin);
			response.sendRedirect(request.getContextPath() + AppPaths.ADMIN);

		} else if (user != null) {
			session.setAttribute(Constants.SESSION_USER, user);
			response.sendRedirect(request.getContextPath() + AppPaths.HOME);

		} else {
			errObj.setEmail(email);
			errObj.setPasswordErrs("Incorrect password!");
			request.setAttribute("ERRORS", errObj);
			RequestDispatcher rd = request.getRequestDispatcher(AppPaths.LOGIN_JSP);
			rd.forward(request, response);
		}
	}

	@Override
	public String getServletInfo() {
		return "Login";
	}// </editor-fold>
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.UserDAO;
import com.prj.assignment301.javabean.Notification;
import com.prj.assignment301.model.User;
import com.prj.assignment301.utils.AppPaths;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AdminUsersServlet extends HttpServlet {

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
		String id = request.getParameter("id");
		String deleteAccount = request.getParameter("delete");

		try {
			int userId = Integer.parseInt(id == null || id.trim().isEmpty() ? "0" : id);
			UserDAO userDAO = new UserDAO();

			// if 'delete' parameter is provided then delete user with the 'id' provided
			if (deleteAccount != null && deleteAccount.trim().equalsIgnoreCase("true")) {
				boolean deleteUser = userDAO.deleteUser(userId);

				if (deleteUser) {
					Notification n = new Notification("Success", "User deleted successfully!", "success");
					request.setAttribute("notifications", n);
				} else {
					Notification e = new Notification("Error", "Failed to delete user!", "error");
					request.setAttribute("notifications", e);
				}
			}

			List<User> userList = userDAO.getUserList();
			request.setAttribute("userList", userList);

			// if user's id provided then send user's info to the client
			if (userId > 0) {
				User userInfo = userDAO.getUserInfo(userId);
				request.setAttribute("userInfo", userInfo);
			}

			RequestDispatcher rd = request.getRequestDispatcher(AppPaths.ADMIN_USERS_JSP);
			rd.forward(request, response);

		} catch (NumberFormatException e) {
			// handle invalid number format exception
		}
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
		String id = request.getParameter("id");
		String newPassword = request.getParameter("newPassword");
		String reEnterPassword = request.getParameter("retypePassword");

		try {
			int userId = id == null || id.trim().isEmpty() ? 0 : Integer.parseInt(id.trim());
			UserDAO userDAO = new UserDAO();

			if (newPassword.isEmpty()) {
				Notification e = new Notification("Error", "New password cannot be left blank", "error");
				request.setAttribute("notifications", e);

			} else if (!reEnterPassword.equals(newPassword)) {
				Notification e = new Notification("Error", "Re-enter password must match the new password", "error");
				request.setAttribute("notifications", e);

			} else {
				boolean passChanged = userDAO.changePassword(userId, newPassword);

				if (passChanged) {
					Notification n = new Notification("Success", "Password changed successfully!", "success");
					request.setAttribute("notifications", n);

				} else {
					Notification e = new Notification("Error", "Failed to change password", "error");
					request.setAttribute("notifications", e);
				}
			}

			List<User> userList = userDAO.getUserList();
			request.setAttribute("userList", userList);

			User userInfo = userDAO.getUserInfo(userId);
			request.setAttribute("userInfo", userInfo);

			request.getRequestDispatcher(AppPaths.ADMIN_USERS_JSP).forward(request, response);

		} catch (NumberFormatException e) {
			// handle invalid number format exception
		}
	}

	/**
	 * Returns a short description of the servlet.
	 *
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "Admin Users";
	}// </editor-fold>

}

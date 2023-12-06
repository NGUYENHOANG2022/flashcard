/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.SupportTicketDAO;
import com.prj.assignment301.javabean.Notification;
import com.prj.assignment301.model.SupportTicket;
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
public class ContactServlet extends HttpServlet {

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
//        processRequest(request, response);
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.CONTACT_JSP);
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
		String email = request.getParameter("email");
		String name = request.getParameter("name");
		String message = request.getParameter("message");
		HttpSession session = request.getSession(false);
		User user = null;

		if (session != null) {
			user = (User) session.getAttribute(Constants.SESSION_USER);
		}

		if (email.isEmpty() || name.isEmpty() || message.isEmpty()) {
			Notification error = new Notification("Error", "Please fill in all the fields!", "error");
			request.setAttribute("notifications", error);
		} else {
			SupportTicketDAO supportTicketDAO = new SupportTicketDAO();
			SupportTicket newTicket = supportTicketDAO.addTicket(email, name, message, user);

			if (newTicket != null) {
				Notification success = new Notification("Success", "Message sent successfully!", "success");
				request.setAttribute("notifications", success);
			} else {
				Notification error = new Notification("Error", "Something went wrong, please try again later!", "error");
				request.setAttribute("notifications", error);
			}
		}

		request.getRequestDispatcher(AppPaths.CONTACT_JSP).forward(request, response);

	}

	/**
	 * Returns a short description of the servlet.
	 *
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "Contact";
	}// </editor-fold>

}

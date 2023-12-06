    /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.servlet;

import com.prj.assignment301.DAO.SupportTicketDAO;
import com.prj.assignment301.javabean.Notification;
import com.prj.assignment301.model.SupportTicket;
import com.prj.assignment301.utils.AppPaths;
import com.prj.assignment301.utils.TicketStatus;
import java.io.IOException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AdminSupportTicketServlet extends HttpServlet {

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
		String tId = request.getParameter("ticket_id");
		String deleteParam = request.getParameter("delete_ticket");

		try {
			int ticketId = Integer.parseInt(tId == null || tId.trim().isEmpty() ? "0" : tId);
			SupportTicketDAO stDAO = new SupportTicketDAO();

			if (ticketId > 0) {
				SupportTicket ticket = stDAO.getTicketInfo(ticketId);
				request.setAttribute("ticketDetails", ticket);
			}

			if (deleteParam != null && deleteParam.trim().equalsIgnoreCase("true")) {
				boolean deleted = stDAO.deleteTicket(ticketId);

				if (deleted) {
					request.setAttribute("ticketDetails", null);
					Notification n = new Notification("Success", "Ticket deleted successfully!", "success");
					request.setAttribute("notifications", n);

				} else {
					Notification e = new Notification("Error", "Failed to delete ticket!", "error");
					request.setAttribute("notifications", e);
				}
			}

			List<SupportTicket> supportTickets = stDAO.getSupportTicketsForAdmin();
			request.setAttribute("supportTickets", supportTickets);

			RequestDispatcher rd = request.getRequestDispatcher(AppPaths.ADMIN_SUPPORT_TICKET_JSP);
			rd.forward(request, response);

		} catch (NumberFormatException e) {
			// handle invalid number format exception
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
					throws ServletException, IOException {
		String tId = request.getParameter("ticket_id");
		String status = request.getParameter("status");

		try {
			int ticketId = Integer.parseInt(tId == null || tId.trim().isEmpty() ? "0" : tId);
			SupportTicketDAO stDAO = new SupportTicketDAO();

			if (ticketId > 0) {
				SupportTicket ticket = stDAO.getTicketInfo(ticketId);
				boolean isStatusValid = false;

				if (status != null) {
					// check if provided status is a valid string
					for (TicketStatus s : TicketStatus.values()) {
						isStatusValid = status.equals(s.toString());
						if (isStatusValid) {
							break;
						}
					}
				}

				if (isStatusValid) {
					boolean updated = stDAO.updateTicketStatus(ticketId, status);

					if (updated) {
						Notification n = new Notification("Success", "Ticket updated successfully!", "success");
						request.setAttribute("notifications", n);
						ticket.setStatus(TicketStatus.valueOf(status));

					} else {
						Notification e = new Notification("Error", "Failed to update ticket!", "error");
						request.setAttribute("notifications", e);
					}
				}

				request.setAttribute("ticketDetails", ticket);
			}

			List<SupportTicket> supportTickets = stDAO.getSupportTicketsForAdmin();
			request.setAttribute("supportTickets", supportTickets);

			RequestDispatcher rd = request.getRequestDispatcher(AppPaths.ADMIN_SUPPORT_TICKET_JSP);
			rd.forward(request, response);

		} catch (NumberFormatException e) {
			// handle invalid number format exception
		}
	}

	@Override
	public String getServletInfo() {
		return "Short description";
	}// </editor-fold>

}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.DAO;

import com.prj.assignment301.db.ConnectionPool;
import com.prj.assignment301.model.SupportTicket;
import com.prj.assignment301.model.User;
import com.prj.assignment301.utils.ReadStatus;
import com.prj.assignment301.utils.TicketStatus;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author hieunghia
 */
public class SupportTicketDAO {

	public SupportTicket addTicket(String email, String name, String message, User user) {
		Date currentDate = new Date();
		Timestamp timestamp = new Timestamp(currentDate.getTime());

		String sql = "INSERT INTO SupportTickets("
						+ "sender_email, "
						+ "sender_name, "
						+ "message, "
						+ "created_at, "
						+ "status, "
						+ "user_read, "
						+ "user_id"
						+ ") VALUES(?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = ConnectionPool.getDataSource().getConnection()) {
			PreparedStatement ps = conn.prepareStatement(sql);

			SupportTicket supTicket = new SupportTicket();
			supTicket.setSenderEmail(email);
			supTicket.setSenderName(name);
			supTicket.setMessage(message);

			ps.setString(1, email);
			ps.setString(2, name);
			ps.setString(3, message);
			ps.setTimestamp(4, timestamp);
			ps.setString(5, TicketStatus.PENDING.toString());
			ps.setString(6, ReadStatus.UNREAD.toString());

			if (user != null) {
				ps.setInt(7, user.getUserId());
			} else {
				ps.setNull(7, Types.INTEGER);
			}

			int rowsInserted = ps.executeUpdate();

			if (rowsInserted > 0) {
				return supTicket;
			}

			ps.close();
		} catch (SQLException e) {
			System.out.println("Error in addTicket! " + e.getMessage());
		}
		return null;
	}

	public List<SupportTicket> getSupportTicketsForAdmin() {
		List<SupportTicket> supportticket = new ArrayList<>();

		String sql = "SELECT *\n"
						+ "FROM SupportTickets\n"
						+ "ORDER BY \n"
						+ "  CASE WHEN status = 'PENDING' THEN 0 ELSE 1 END,\n"
						+ "  CASE WHEN status = 'PENDING' THEN created_at END DESC,\n"
						+ "  created_at DESC;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql);) {

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				SupportTicket st = new SupportTicket();
				st.setTicketId(rs.getInt("ticket_id"));
				st.setSenderName(rs.getString("sender_name"));
				st.setSenderEmail(rs.getString("sender_email"));
				st.setStatus(TicketStatus.valueOf(rs.getString("status")));
				st.setCreatedAt(rs.getDate("created_at"));
				supportticket.add(st);
			}
			rs.close();
		} catch (SQLException e) {
			System.out.println("Error in getSupportTicketsForAdmin! " + e.getMessage());
		}

		return supportticket;

	}

	public List<SupportTicket> getSupportTicketsForDashboard() {
		List<SupportTicket> supportticket = new ArrayList<>();

		String sql = "SELECT TOP 5 *\n"
						+ "FROM SupportTickets\n"
						+ "WHERE status = 'PENDING'\n"
						+ "ORDER BY created_at DESC";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql);) {

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				SupportTicket st = new SupportTicket();
				st.setTicketId(rs.getInt("ticket_id"));
				st.setSenderName(rs.getString("sender_name"));
				st.setSenderEmail(rs.getString("sender_email"));
				st.setStatus(TicketStatus.valueOf(rs.getString("status")));
				st.setCreatedAt(rs.getDate("created_at"));
				supportticket.add(st);
			}
			rs.close();
		} catch (SQLException e) {
			System.out.println("Error in getSupportTicketsForDashboard! " + e.getMessage());
		}

		return supportticket;

	}

	public SupportTicket getTicketInfo(int ticketId) {
		SupportTicket ticket = null;
		String sql = "SELECT *\n"
						+ "FROM SupportTickets\n"
						+ "WHERE ticket_id = ?;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, ticketId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					ticket = new SupportTicket();
					ticket.setTicketId(rs.getInt("ticket_id"));
					ticket.setSenderName(rs.getString("sender_name"));
					ticket.setSenderEmail(rs.getString("sender_email"));
					ticket.setStatus(TicketStatus.valueOf(rs.getString("status")));
					ticket.setCreatedAt(rs.getDate("created_at"));
					ticket.setMessage(rs.getString("message"));
				}
			}
		} catch (SQLException e) {
			System.out.println("getTicketInfo errors!" + e.getMessage());
		}
		return ticket;
	}

	public boolean updateTicketStatus(int ticketId, String status) {
		String sql = "UPDATE [SupportTickets] SET [status] = ? WHERE ticket_id = ?;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, status);
			ps.setInt(2, ticketId);

			int updatedRows = ps.executeUpdate();
			if (updatedRows > 0) {
				return true;
			}
		} catch (SQLException e) {
			System.out.println("updateTicketStatus errors!" + e.getMessage());
		}
		return false;
	}

	public boolean deleteTicket(int ticketId) {
		String sql = "DELETE SupportTickets WHERE ticket_id = ?";
		boolean result = false;

		try (Connection conn = ConnectionPool.getDataSource().getConnection(); 
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, ticketId);

			int deleted = ps.executeUpdate();

			if (deleted > 0) {
				result = true;
			} 
		} catch (Exception e) {
			System.out.println("Something went wrong with deleteTicket!" + e.getMessage());
		}
		return result;
	}
}

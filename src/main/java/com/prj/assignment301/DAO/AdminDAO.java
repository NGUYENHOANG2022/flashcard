/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.DAO;

import com.prj.assignment301.model.Admin;
import com.prj.assignment301.db.ConnectionPool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Admin
 */
public class AdminDAO {

	public Admin login(String email, String password) {
		String sql = "SELECT * FROM Admins WHERE email = ? and password = ?";
		try (Connection conn = ConnectionPool.getDataSource().getConnection()) {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, email);
			ps.setString(2, password);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				Admin admin = new Admin();
				admin.setEmail(rs.getString("email"));
				admin.setAdminId(rs.getInt("admin_id"));
				admin.setPassword(rs.getString("password"));
				admin.setName(rs.getString("name"));

				return admin;
			}
			rs.close();
			ps.close();
		} catch (SQLException e) {
			System.out.println("Login is wrong!" + e.getMessage());
		}
		return null;
	}

	public boolean isAdminExist(String email) {
		String sql = "SELECT 1 FROM Admins WHERE email = ?";
		try (Connection conn = ConnectionPool.getDataSource().getConnection()) {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, email);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return true;
			}
			rs.close();
			ps.close();
		} catch (SQLException e) {
			System.out.println("Admin not found!" + e.getMessage());
		}
		return false;
	}
        
}

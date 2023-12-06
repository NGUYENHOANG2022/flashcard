package com.prj.assignment301.DAO;

import com.prj.assignment301.model.User;
import com.prj.assignment301.db.ConnectionPool;
import com.prj.assignment301.javabean.UsersDecksOverTime;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Admin
 */
public class UserDAO {

	public boolean isUserExist(String email) {
		String sql = "SELECT 1 FROM Users WHERE email = ?";
		try (Connection conn = ConnectionPool.getDataSource().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, email);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return true;
				}
			}
		} catch (SQLException e) {
			System.out.println("User not found!" + e.getMessage());
		}
		return false;
	}

	public User login(String email, String password) {
		String sql = "SELECT * FROM Users WHERE email = ? and password = ?";

		try (Connection conn = ConnectionPool.getDataSource().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, email);
			ps.setString(2, password);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					User user = new User();
					user.setEmail(rs.getString("email"));
					user.setUserId(rs.getInt("user_id"));
					user.setPassword(rs.getString("password"));
					user.setName(rs.getString("name"));
					user.setAvatar(rs.getString("avatar"));
					user.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));

					return user;
				}
			}
		} catch (SQLException e) {
			System.out.println("Login is wrong!" + e.getMessage());
		}
		return null;
	}

	public boolean addUser(String email, String password, String name) {
		String sql = "INSERT INTO Users (email, name, password, created_at, avatar) VALUES(?,?,?,?,?)";
		boolean result = false;

		try (Connection conn = ConnectionPool.getDataSource().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			Date currentDate = new Date();
			Timestamp timestamp = new Timestamp(currentDate.getTime());

			ps.setString(1, email);
			ps.setString(2, name);
			ps.setString(3, password);
			ps.setTimestamp(4, timestamp);
			ps.setString(5, "https://api.dicebear.com/5.x/adventurer/svg?seed=" + name);

			int addedRows = ps.executeUpdate();
			if (addedRows > 0) {
				result = true;
			} else {
				System.out.println("Add user failed!");
			}
		} catch (Exception e) {
			System.out.println("Something went wrong with addUser!" + e.getMessage());
		}
		return result;
	}

	public boolean updateUserAvatar(int userId, String avatar) {
		String sql = "UPDATE Users SET avatar = ? WHERE user_id = ?";
		boolean result = false;

		try (Connection conn = ConnectionPool.getDataSource().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, avatar);
			ps.setInt(2, userId);

			int updatedRows = ps.executeUpdate();
			if (updatedRows > 0) {
				result = true;
			} else {
				System.out.println("Update user avatar failed!");
			}
		} catch (Exception e) {
			System.out.println("Something went wrong with updateUserAvatar!" + e.getMessage());
		}
		return result;
	}

	public boolean updateUser(String name, String password, User user) {
		String sql = "UPDATE Users SET name = ? , password = ? WHERE user_id = ? ";
		boolean result = false;

		try (Connection conn = ConnectionPool.getDataSource().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, name);
			ps.setString(2, password);
			ps.setInt(3, user.getUserId());
			int updatedRows = ps.executeUpdate();
			if (updatedRows > 0) {
				result = true;
			} else {
				System.out.println("Update user failed!");
			}
		} catch (SQLException e) {
			System.out.println("Something went wrong with updateUserProfile!" + e.getMessage());
		}
		return result;
	}

	public boolean deleteUser(int userId) {
		String sql = "DELETE Users WHERE user_id = ?";
		boolean result = false;

		try (Connection conn = ConnectionPool.getDataSource().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			int deleted = ps.executeUpdate();
			if (deleted > 0) {
				result = true;
			} else {
				System.out.println("Delete user failed!");
			}
		} catch (Exception e) {
			System.out.println("Something went wrong with deleteUser!" + e.getMessage());
		}
		return result;
	}

	public User getUserByEmail(String email) {
		String sql = "SELECT * FROM Users WHERE email = ?";

		try (Connection conn = ConnectionPool.getDataSource().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, email);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					User user = new User();
					user.setEmail(rs.getString("email"));
					user.setUserId(rs.getInt("user_id"));
					user.setPassword(rs.getString("password"));
					user.setName(rs.getString("name"));
					user.setAvatar(rs.getString("avatar"));
					user.setCreatedAt(rs.getDate("created_at"));

					return user;
				}
			}
		} catch (SQLException e) {
			System.out.println("User not found!" + e.getMessage());
		}
		return null;
	}

	public List<User> searchUserByName(String searchName, int deckId, int owner_id) {
		List<User> users = new ArrayList<>();

		String sql = "SELECT TOP 10 u.user_id, u.email, u.name, u.avatar \n"
						+ "FROM Users u\n"
						+ "LEFT JOIN DeckShares ds ON u.user_id = ds.user_id AND ds.deck_id = ?\n"
						+ "WHERE ds.user_id IS NULL AND (u.name LIKE CONCAT(N'%', ?, N'%') OR u.email LIKE CONCAT(N'%', '23', N'%'))";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql);) {

			ps.setInt(1, deckId);
			ps.setString(2, searchName);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					User user = new User();
                                        if (rs.getInt("user_id") != owner_id) {
                                            user.setUserId(rs.getInt("user_id"));
                                            user.setEmail(rs.getString("email"));
                                            user.setName(rs.getString("name"));
                                            user.setAvatar(rs.getString("avatar"));

                                            users.add(user);
                                        }					
				}
			}
		} catch (SQLException e) {
			System.out.println("Search users error! " + e.getMessage());
		}

		return users;
	}

	public List<User> getTenUsers() {
		List<User> users = new ArrayList<>();

		String sql = "SELECT TOP 10 user_id, email, name "
						+ "FROM Users";

		try {
			Connection conn = ConnectionPool.getDataSource().getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				int user_id = rs.getInt("user_id");
				String name = rs.getString("name");
				String email = rs.getString("email");

				User user = new User();

				user.setUserId(user_id);
				user.setName(name);
				user.setEmail(email);

				users.add(user);
			}
		} catch (SQLException e) {
			System.out.println("Search users error! " + e.getMessage());
		}

		return users;
	}

	public List<User> getUserList() {
		List<User> users = new ArrayList<>();

		String sql = "SELECT user_id, email, name, avatar, created_at FROM Users";

		try {
			Connection conn = ConnectionPool.getDataSource().getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				int user_id = rs.getInt("user_id");
				String email = rs.getString("email");
				String name = rs.getString("name");
				String avatar = rs.getString("avatar");

				User user = new User();

				user.setUserId(user_id);
				user.setEmail(email);
				user.setName(name);
				user.setAvatar(avatar);
				user.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));

				users.add(user);
			}
		} catch (SQLException e) {
			System.out.println("Get users error!" + e.getMessage());
		}

		return users;
	}

	public User getUserInfo(int user_id) {
		User user = new User();
		String sql = "SELECT COALESCE(COUNT(d.deck_id), 0) AS deck_count, u.email, u.name, u.avatar, u.created_at \n"
						+ "FROM Users AS u \n"
						+ "LEFT JOIN Decks AS d ON d.owner_id = u.user_id \n"
						+ "WHERE u.user_id = ?\n"
						+ "GROUP BY u.email, u.name, u.avatar, u.created_at";

		try {
			Connection conn = ConnectionPool.getDataSource().getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setInt(1, user_id);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				String email = rs.getString("email");
				String name = rs.getString("name");
				String avatar = rs.getString("avatar");
				Date created_at = rs.getDate("created_at");
				int deck_count = rs.getInt("deck_count");

				user.setUserId(user_id);
				user.setEmail(email);
				user.setName(name);
				user.setAvatar(avatar);
				user.setCreatedAt(created_at);
				user.setDeckCount(deck_count);
			}
		} catch (SQLException e) {
			System.out.println("Get user info error! " + e.getMessage());
		}

		return user;
	}

	public int getNumOfNewUsersToday() {
		int total = 0;
		String sql = "SELECT COUNT(*) AS new_users\n"
						+ "FROM Users\n"
						+ "WHERE CONVERT(date, created_at) = CONVERT(date, GETDATE());";

		try {
			Connection conn = ConnectionPool.getDataSource().getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				total = rs.getInt("new_users");
			}
		} catch (SQLException e) {
			System.out.println("getNumOfNewUsersToday error! " + e.getMessage());
		}

		return total;
	}

	public boolean changePassword(int userId, String newPassword) {
		boolean isChanged = false;
		String sql = "UPDATE Users\n"
						+ "SET password = ?\n"
						+ "WHERE user_id = ?";

		try {
			Connection conn = ConnectionPool.getDataSource().getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, newPassword);
			ps.setInt(2, userId);

			int rowsChanged = ps.executeUpdate();

			if (rowsChanged > 0) {
				isChanged = true;
			}

			ps.close();
			conn.close();
		} catch (SQLException e) {
			System.out.println("Change password error! " + e.getMessage());
		}

		return isChanged;
	}

	public List<UsersDecksOverTime> getNewUsersAndDecksOverTime() {
		List<UsersDecksOverTime> l = new ArrayList<>();

		String sql = "SELECT \n"
						+ "  CONVERT(date, COALESCE(u.created_at, d.created_at)) AS date_created, \n"
						+ "  COUNT(DISTINCT u.user_id) AS new_users, \n"
						+ "  COUNT(DISTINCT d.deck_id) AS new_decks\n"
						+ "FROM Users u\n"
						+ "FULL OUTER JOIN Decks d ON CONVERT(date, u.created_at) = CONVERT(date, d.created_at)\n"
						+ "GROUP BY CONVERT(date, COALESCE(u.created_at, d.created_at))\n"
						+ "ORDER BY CONVERT(date, COALESCE(u.created_at, d.created_at)) ASC;";

		try {
			Connection conn = ConnectionPool.getDataSource().getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				int newUsers = rs.getInt("new_users");
				int newDecks = rs.getInt("new_decks");
				String date = rs.getString("date_created");

				UsersDecksOverTime o = new UsersDecksOverTime();

				o.setNewUsers(newUsers);
				o.setNewDecks(newDecks);
				o.setDate(date);

				l.add(o);
			}
		} catch (SQLException e) {
			System.out.println("getNewUsersAndDecksOverTime error!" + e.getMessage());
		}

		return l;
	}
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.DAO;

import com.prj.assignment301.db.ConnectionPool;
import com.prj.assignment301.javabean.DeckDetailsBean;
import com.prj.assignment301.javabean.DeckMeta;
import com.prj.assignment301.javabean.DecksStudiesOverTime;
import com.prj.assignment301.model.Deck;
import com.prj.assignment301.model.ShareDeck;
import com.prj.assignment301.model.User;
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
public class DeckDAO {

	public Deck createDeck(String name, String description, int privateDeck, User user) {
		String sql = "INSERT INTO Decks (name, description, private, created_at, updated_at, owner_id) VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?)";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql);) {

			Deck deck = new Deck();

			deck.setName(name);
			deck.setDescription(description);
			deck.setPrivateDeck(privateDeck);

			ps.setString(1, name);
			ps.setString(2, description);
			ps.setInt(3, privateDeck);

			if (user != null) {
				ps.setInt(4, user.getUserId());
			} else {
				ps.setNull(4, Types.INTEGER);
			}

			int rowsInserted = ps.executeUpdate();

			if (rowsInserted > 0) {
				return deck;
			}

		} catch (SQLException e) {
			System.out.println("Error in create deck! " + e.getMessage());
		}

		return null;
	}

	/*
	This method will return both user's success and other users' success that have been 
	shared will this user.
	Both private and public success will be returned.
	 */
	public List<Deck> getDecksByUserIdWithSearch(int userId, String searchStr) {
		ArrayList<Deck> decks = new ArrayList<>();

		String sql = "SELECT d.deck_id, d.name, d.description, d.private, d.created_at, d.updated_at, d.owner_id, u.name as owner_name, u.avatar as owner_avatar, u.email as owner_email,\n"
						+ "(SELECT COUNT(*) FROM cards WHERE deck_id = d.deck_id) as card_count\n"
						+ "FROM decks d\n"
						+ "LEFT JOIN DeckShares ds ON d.deck_id = ds.deck_id\n"
						+ "LEFT JOIN users u ON d.owner_id = u.user_id\n"
						+ "WHERE (ds.user_id = ? OR d.owner_id = ?)\n"
						+ "AND (d.name LIKE CONCAT(N'%', ?, N'%')) \n"
						+ "GROUP BY d.deck_id, d.name, d.description, d.private, d.created_at, d.updated_at, d.owner_id, u.name, u.avatar, u.email\n"
						+ "ORDER BY d.deck_id DESC;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setInt(2, userId);
			ps.setString(3, searchStr);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Deck deck = new Deck();
				deck.setName(rs.getString("name"));
				deck.setDescription(rs.getString("description"));
				deck.setPrivateDeck(rs.getInt("private"));
				deck.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
				deck.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
				deck.setOwnerId(rs.getInt("owner_id"));
				deck.setDeckId(rs.getInt("deck_id"));
				deck.setOwnerName(rs.getString("owner_name"));
				deck.setOwnerAvatar(rs.getString("owner_avatar"));
				deck.setOwnerEmail(rs.getString("owner_email"));
				deck.setCardCount(rs.getInt("card_count"));

				decks.add(deck);
			}
			rs.close();
		} catch (SQLException e) {
			System.out.println("getDecksByUserIdWithSearch errors!" + e.getMessage());
		}
		return decks;
	}

	/*
	This method will return only user's public decks.
	Other users' decks that have been shared with this user will not return.	
	 */
	public List<Deck> getPublicDecksById(int ownerId) {
		ArrayList<Deck> decks = new ArrayList<>();

		String sql = "SELECT d.deck_id, d.name, d.description, d.private, d.created_at, d.updated_at, d.owner_id, "
						+ "u.name as owner_name, u.avatar as owner_avatar, u.email as owner_email,\n"
						+ "(SELECT COUNT(*) FROM cards WHERE deck_id = d.deck_id) as card_count\n"
						+ "FROM decks d\n"
						+ "INNER JOIN users u ON d.owner_id = u.user_id\n"
						+ "WHERE d.owner_id = ? AND d.private = 0";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, ownerId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Deck deck = new Deck();
				deck.setName(rs.getString("name"));
				deck.setDescription(rs.getString("description"));
				deck.setPrivateDeck(rs.getInt("private"));
				deck.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
				deck.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
				deck.setOwnerId(rs.getInt("owner_id"));
				deck.setDeckId(rs.getInt("deck_id"));
				deck.setOwnerName(rs.getString("owner_name"));
				deck.setOwnerAvatar(rs.getString("owner_avatar"));
				deck.setOwnerEmail(rs.getString("owner_email"));
				deck.setCardCount(rs.getInt("card_count"));

				decks.add(deck);
			}
			rs.close();
		} catch (SQLException e) {
			System.out.println("getPublicDecksById errors!" + e.getMessage());
		}
		return decks;
	}

	public List<Deck> getRecentDecks(int userId) {
		ArrayList<Deck> decks = new ArrayList<>();

		String sql = "DECLARE @ownerId INT = ?;\n"
						+ "\n"
						+ "SELECT D.deck_id, D.name, D.description, D.private, D.owner_id, D.created_at, D.updated_at,\n"
						+ "    (SELECT COUNT(*) FROM Cards WHERE deck_id = D.deck_id) AS card_count, \n"
						+ "    U.avatar AS owner_avatar, U.name AS owner_name, U.email AS owner_email,\n"
						+ "    MAX(COALESCE(last_action_date, '1900-01-01')) AS latest_action_date\n"
						+ "FROM Decks D\n"
						+ "INNER JOIN Users U ON U.user_id = D.owner_id\n"
						+ "LEFT JOIN Cards C ON C.deck_id = D.deck_id\n"
						+ "LEFT JOIN (\n"
						+ "    SELECT deck_id,\n"
						+ "        (CASE\n"
						+ "			WHEN MAX(COALESCE(created_at, '1900-01-01')) >= MAX(COALESCE(updated_at, '1900-01-01')) AND \n"
						+ "				MAX(COALESCE(created_at, '1900-01-01')) >= MAX(COALESCE(date_shared, '1900-01-01')) AND \n"
						+ "				MAX(COALESCE(created_at, '1900-01-01')) >= MAX(COALESCE(latest_update, '1900-01-01')) THEN \n"
						+ "				MAX(COALESCE(created_at, '1900-01-01'))\n"
						+ "			WHEN MAX(COALESCE(updated_at, '1900-01-01')) >= MAX(COALESCE(created_at, '1900-01-01')) AND \n"
						+ "				MAX(COALESCE(updated_at, '1900-01-01')) >= MAX(COALESCE(date_shared, '1900-01-01')) AND \n"
						+ "				MAX(COALESCE(updated_at, '1900-01-01')) >= MAX(COALESCE(latest_update, '1900-01-01')) THEN \n"
						+ "				MAX(COALESCE(updated_at, '1900-01-01'))\n"
						+ "			WHEN MAX(COALESCE(date_shared, '1900-01-01')) >= MAX(COALESCE(created_at, '1900-01-01')) AND \n"
						+ "				MAX(COALESCE(date_shared, '1900-01-01')) >= MAX(COALESCE(updated_at, '1900-01-01')) AND \n"
						+ "				MAX(COALESCE(date_shared, '1900-01-01')) >= MAX(COALESCE(latest_update, '1900-01-01')) THEN \n"
						+ "				MAX(COALESCE(date_shared, '1900-01-01'))\n"
						+ "			ELSE MAX(COALESCE(latest_update, '1900-01-01'))\n"
						+ "        END) AS last_action_date\n"
						+ "    FROM (\n"
						+ "        SELECT deck_id, created_at, updated_at, NULL AS date_shared, NULL AS latest_update\n"
						+ "        FROM Decks\n"
						+ "        UNION \n"
						+ "        SELECT deck_id, NULL, NULL, date_shared, NULL\n"
						+ "        FROM DeckShares\n"
						+ "        UNION \n"
						+ "        SELECT deck_id, NULL, NULL, NULL, latest_update\n"
						+ "        FROM DeckHistories\n"
						+ "    ) AS action\n"
						+ "    GROUP BY deck_id\n"
						+ ") AS lastActionDate\n"
						+ "ON D.deck_id = lastActionDate.deck_id\n"
						+ "WHERE D.owner_id = @ownerId OR EXISTS (SELECT 1 FROM DeckShares WHERE deck_id = D.deck_id AND user_id = @ownerId)\n"
						+ "GROUP BY D.deck_id, D.name, D.description, D.private, D.owner_id, U.avatar, U.name, U.email, D.created_at, D.updated_at\n"
						+ "ORDER BY latest_action_date DESC;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Deck deck = new Deck();
				deck.setName(rs.getString("name"));
				deck.setDescription(rs.getString("description"));
				deck.setPrivateDeck(rs.getInt("private"));
				deck.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
				deck.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
				deck.setOwnerId(rs.getInt("owner_id"));
				deck.setDeckId(rs.getInt("deck_id"));
				deck.setOwnerName(rs.getString("owner_name"));
				deck.setOwnerAvatar(rs.getString("owner_avatar"));
				deck.setOwnerEmail(rs.getString("owner_email"));
				deck.setCardCount(rs.getInt("card_count"));

				decks.add(deck);
			}
			rs.close();
		} catch (SQLException e) {
			System.out.println("getRecentDecks errors!" + e.getMessage());
		}
		return decks;
	}

	public List<Deck> getPublicDecksWithSearch(String searchStr) {
		ArrayList<Deck> decks = new ArrayList<>();

		String sql = "SELECT d.deck_id, d.name, d.description, d.private, d.created_at, d.updated_at, d.owner_id, u.name as owner_name, u.avatar as owner_avatar, u.email as owner_email,\n"
						+ "(SELECT COUNT(*) FROM cards WHERE deck_id = d.deck_id) as card_count\n"
						+ "FROM decks d\n"
						+ "LEFT JOIN users u ON d.owner_id = u.user_id\n"
						+ "WHERE d.private = 0 AND (d.name LIKE CONCAT(N'%', ?, N'%'))"
						+ "ORDER BY d.deck_id DESC;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, searchStr);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Deck deck = new Deck();
				deck.setName(rs.getString("name"));
				deck.setDescription(rs.getString("description"));
				deck.setPrivateDeck(rs.getInt("private"));
				deck.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
				deck.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
				deck.setOwnerId(rs.getInt("owner_id"));
				deck.setDeckId(rs.getInt("deck_id"));
				deck.setOwnerName(rs.getString("owner_name"));
				deck.setOwnerAvatar(rs.getString("owner_avatar"));
				deck.setOwnerEmail(rs.getString("owner_email"));
				deck.setCardCount(rs.getInt("card_count"));

				decks.add(deck);
			}
			rs.close();
		} catch (SQLException e) {
			System.out.println("getPublicDecksWithSearch errors!" + e.getMessage());
		}
		return decks;
	}

	public List<DeckMeta> getDeckMetaByOwnerId(int ownerId) {
		List<DeckMeta> decks = new ArrayList<>();
		String sql = "SELECT deck_id, name, private FROM Decks WHERE owner_id = ?";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, ownerId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				DeckMeta deck = new DeckMeta();
				deck.setName(rs.getString("name"));
				deck.setPrivateDeck(rs.getInt("private"));
				deck.setDeckId(rs.getInt("deck_id"));

				decks.add(deck);
			}
			rs.close();
		} catch (SQLException e) {
			System.out.println("getDeckMetaByOwnerId errors!" + e.getMessage());
		}
		return decks;
	}

	// Return success's info. 
	// Only the owner and shared users can retrieve private success's info
	// If it is public success then anyone can retrieve it
	public DeckDetailsBean getDeckInfoByUserId(int deckId, int userId) {
		DeckDetailsBean deck = null;
		String sql = "DECLARE @deck_id INT = ?;\n"
						+ "DECLARE @user_id INT = ?;\n"
						+ "DECLARE @today DATE = CAST(GETDATE() AS DATE);\n"
						+ "SELECT \n"
						+ "	d.deck_id,d.name, d.description, d.owner_id, u.name AS owner_name, \n"
						+ "	u.email AS owner_email, u.avatar AS owner_avatar, \n"
						+ "	(SELECT COUNT(*) FROM Cards WHERE deck_id = d.deck_id) AS card_count, d.private,\n"
						+ "	COUNT(DISTINCT ds.user_id) AS shared_users_count,\n"
						+ "	(SELECT SUM(study_count) FROM DeckHistories WHERE deck_id = @deck_id AND user_id = @user_id AND date = @today) AS deck_studies_today\n"
						+ "FROM Decks d\n"
						+ "LEFT JOIN Users u ON d.owner_id = u.user_id\n"
						+ "LEFT JOIN Cards c ON d.deck_id = c.deck_id\n"
						+ "LEFT JOIN DeckShares ds ON d.deck_id = ds.deck_id\n"
						+ "LEFT JOIN DeckHistories dh ON d.deck_id = dh.deck_id\n"
						+ "WHERE d.deck_id = @deck_id AND (d.private = 0 OR d.owner_id = @user_id OR ds.user_id = @user_id)\n"
						+ "GROUP BY d.deck_id, d.name, d.description, d.owner_id, u.name, u.email, u.avatar, d.private;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, deckId);
			ps.setInt(2, userId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					deck = new DeckDetailsBean();
					deck.setName(rs.getString("name"));
					deck.setDescription(rs.getString("description"));
					deck.setPrivateDeck(rs.getInt("private"));
					deck.setOwnerId(rs.getInt("owner_id"));
					deck.setDeckId(rs.getInt("deck_id"));
					deck.setOwnerName(rs.getString("owner_name"));
					deck.setOwnerAvatar(rs.getString("owner_avatar"));
					deck.setOwnerEmail(rs.getString("owner_email"));
					deck.setCardCount(rs.getInt("card_count"));
					deck.setSharedUsersCount(rs.getInt("shared_users_count"));
					deck.setDeckStudiesToday(rs.getInt("deck_studies_today"));
				}
			}
		} catch (SQLException e) {
			System.out.println("getDeckInfoByUserId errors!" + e.getMessage());
		}
		return deck;
	}

	// Return success's info. 
	// Only the owner can retrieve success's info
	public DeckDetailsBean getDeckInfoByOwnerId(int deckId, int userId) {
		DeckDetailsBean deck = null;
		String sql = "DECLARE @deck_id INT = ?;\n"
						+ "DECLARE @user_id INT = ?;\n"
						+ "DECLARE @today DATE = GETDATE();\n"
						+ "SELECT	d.deck_id,d.name,  d.description, d.owner_id, d.private,\n"
						+ "		u.name AS owner_name, u.email AS owner_email, u.avatar AS owner_avatar,\n"
						+ "		(SELECT COUNT(*) FROM Cards WHERE deck_id = d.deck_id) AS card_count,\n"
						+ "		COUNT(DISTINCT ds.user_id) AS shared_users_count,\n"
						+ "		SUM(CASE WHEN dh.date = @today \n"
						+ "THEN dh.study_count ELSE 0 END) AS deck_studies_today \n"
						+ "FROM Decks d LEFT JOIN Users u ON d.owner_id = u.user_id\n"
						+ "LEFT JOIN Cards c ON d.deck_id = c.deck_id\n"
						+ "LEFT JOIN DeckShares ds ON d.deck_id = ds.deck_id\n"
						+ "LEFT JOIN DeckHistories dh ON d.deck_id = dh.deck_id\n"
						+ "WHERE d.deck_id = @deck_id AND (d.owner_id = @user_id)\n"
						+ "GROUP BY d.deck_id, d.name, d.description, d.owner_id, u.name, u.email, u.avatar, d.private;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, deckId);
			ps.setInt(2, userId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					deck = new DeckDetailsBean();
					deck.setName(rs.getString("name"));
					deck.setDescription(rs.getString("description"));
					deck.setPrivateDeck(rs.getInt("private"));
					deck.setOwnerId(rs.getInt("owner_id"));
					deck.setDeckId(rs.getInt("deck_id"));
					deck.setOwnerName(rs.getString("owner_name"));
					deck.setOwnerAvatar(rs.getString("owner_avatar"));
					deck.setOwnerEmail(rs.getString("owner_email"));
					deck.setCardCount(rs.getInt("card_count"));
					deck.setSharedUsersCount(rs.getInt("shared_users_count"));
					deck.setDeckStudiesToday(rs.getInt("deck_studies_today"));
				}
			}
		} catch (SQLException e) {
			System.out.println("getDeckInfoByOwnerId errors!" + e.getMessage());
		}
		return deck;
	}

	public boolean updateDeck(int deckId, String name, String description, int privateDeck, int userId) {
		boolean success = false;
		String sql = "DECLARE @deck_id INT = ?;\n"
						+ "DECLARE @user_id INT = ?;\n"
						+ "DECLARE @new_name NVARCHAR(40) = ?;\n"
						+ "DECLARE @new_description NVARCHAR(200) = ?;\n"
						+ "DECLARE @new_private INT = ?;\n"
						+ "\n"
						+ "UPDATE Decks\n"
						+ "SET name = @new_name,\n"
						+ "    description = @new_description,\n"
						+ "    private = @new_private,\n"
						+ "    updated_at = CURRENT_TIMESTAMP\n"
						+ "WHERE deck_id = @deck_id AND owner_id = @user_id;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, deckId);
			ps.setInt(2, userId);
			ps.setString(3, name);
			ps.setString(4, description);
			ps.setInt(5, privateDeck);

			int rowUpdated = ps.executeUpdate();

			if (rowUpdated > 0) {
				return true;
			}

		} catch (SQLException e) {
			System.out.println("updteDeck errors!" + e.getMessage());
		}
		return success;
	}

	public boolean deleteDeck(int deckId, int userId) {
		boolean success = false;
		String sql = "DECLARE @deck_id INT = ?;\n"
						+ "DECLARE @owner_id INT = ?;\n"
						+ "IF EXISTS (SELECT * FROM Decks WHERE deck_id = @deck_id AND owner_id = @owner_id)\n"
						+ "BEGIN\n"
						+ "    DELETE FROM Cards WHERE deck_id = @deck_id;\n"
						+ "    DELETE FROM Decks WHERE deck_id = @deck_id;\n"
						+ "    SELECT 'Deck deleted successfully' AS message;\n"
						+ "END\n"
						+ "ELSE\n"
						+ "BEGIN\n"
						+ "    DECLARE @message NVARCHAR(100) = 'Deck not found or you not the owner of the deck';\n"
						+ "    RAISERROR(@message, 16, 1);\n"
						+ "END";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, deckId);
			ps.setInt(2, userId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return true;
			}

		} catch (SQLException e) {
			System.out.println("deleteDeck errors!" + e.getMessage());
		}
		return success;
	}

	public ShareDeck shareDeckToUser(int deckId, int[] selectedUsers) {
		ShareDeck shareDeck = new ShareDeck();
		String userRead = "UNREAD";
		String sql = "INSERT INTO DeckShares(user_read, user_id, deck_id, date_shared) VALUES (?, ?, ?, ?)";
		Date currentDate = new Date();
		Timestamp timestamp = new Timestamp(currentDate.getTime());

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {

			for (int usersId : selectedUsers) {
				shareDeck.setUserRead(userRead);
				shareDeck.setDeckId(deckId);
				shareDeck.setUserId(usersId);

				ps.setString(1, userRead);
				ps.setInt(2, usersId);
				ps.setInt(3, deckId);
				ps.setTimestamp(4, timestamp);

				ps.addBatch();
			}

			ps.executeBatch();

		} catch (SQLException e) {
			System.out.println("shareDeckToUser errors!" + e.getMessage());
		}

		return shareDeck;
	}

	public List<User> getSharedUsers(int deckId) {
		List<User> users = new ArrayList<>();
		String sql = "SELECT u.user_id, u.email, u.name, u.avatar \n"
						+ "FROM Users u\n"
						+ "JOIN DeckShares ds ON u.user_id = ds.user_id AND ds.deck_id = ?";

		try (Connection conn = ConnectionPool.getDataSource().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, deckId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				User user = new User();
				user.setUserId(rs.getInt("user_id"));
				user.setEmail(rs.getString("email"));
				user.setName(rs.getString("name"));
				user.setAvatar(rs.getString("avatar"));

				users.add(user);
			}
		} catch (SQLException e) {
			System.out.println("getSharedUsers errors!" + e.getMessage());
		}

		return users;
	}

	public String getDeckName(int deckId, int userId) {
		String deckName = "";
		String sql = "DECLARE @deck_id INT = ?;\n"
						+ "DECLARE @user_id INT = ?;\n"
						+ "SELECT d.name\n"
						+ "FROM Decks d\n"
						+ "LEFT JOIN DeckShares ds ON d.deck_id = ds.deck_id\n"
						+ "WHERE d.deck_id = @deck_id \n"
						+ "    AND ((d.private = 1 AND (d.owner_id = @user_id OR ds.user_id = @user_id)) OR d.private = 0)";

		try (Connection conn = ConnectionPool.getDataSource().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, deckId);
			ps.setInt(2, userId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				deckName = rs.getString("name");
			}
		} catch (SQLException e) {
			System.out.println("getDeckName errors!" + e.getMessage());
		}

		return deckName;
	}

	public int getNumOfNewDecksToday() {
		int total = 0;
		String sql = "SELECT COUNT(*) AS new_decks\n"
						+ "FROM Decks\n"
						+ "WHERE CONVERT(date, created_at) = CONVERT(date, GETDATE());";

		try {
			Connection conn = ConnectionPool.getDataSource().getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				total = rs.getInt("new_decks");
			}
		} catch (SQLException e) {
			System.out.println("getNumOfNewDecksToday error! " + e.getMessage());
		}

		return total;
	}

	public int getNumOfDecksStudiesToday() {
		int total = 0;
		String sql = "SELECT COUNT(DISTINCT dh.deck_id) AS decks_studies\n"
						+ "FROM DeckHistories dh\n"
						+ "INNER JOIN Decks d ON dh.deck_id = d.deck_id\n"
						+ "WHERE CONVERT(date, dh.date) = CONVERT(date, GETDATE());";

		try {
			Connection conn = ConnectionPool.getDataSource().getConnection();
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				total = rs.getInt("decks_studies");
			}
		} catch (SQLException e) {
			System.out.println("getNumOfDecksStudiesToday error! " + e.getMessage());
		}

		return total;
	}
        public int getNumOfDecksStudiesToday(int userId) {
        int total = 0;
        String sql = "SELECT COUNT(*) AS 'count'\n"
                + "FROM DeckHistories\n"
                + "WHERE user_id = ? AND CONVERT(DATE, latest_update) = CONVERT(DATE, GETDATE())";

        try {
            Connection conn = ConnectionPool.getDataSource().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getInt("count");
            }
        } catch (SQLException e) {
            System.out.println("getNumOfDecksStudiesToday by user error! " + e.getMessage());
        }

        return total;
    }
         public List<DecksStudiesOverTime> getDecksStudyOvertime(int userId) {
        List<DecksStudiesOverTime> l = new ArrayList<>();

        String sql = "SELECT \n"
								+ "    CONVERT(date, dh.date) AS 'date', \n"
								+ "    dh.study_count AS studied_count\n"
								+ "FROM \n"
								+ "    DeckHistories dh\n"
								+ "    JOIN Decks d ON dh.deck_id = d.deck_id \n"
								+ "WHERE \n"
								+ "    dh.user_id = ? AND \n"
								+ "    dh.study_count > 0 \n"
								+ "GROUP BY \n"
								+ "    CONVERT(date, dh.date), dh.study_count\n"
								+ "ORDER BY \n"
								+ "    CONVERT(date, dh.date) ASC;";

        try {
            Connection conn = ConnectionPool.getDataSource().getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int studyCount = rs.getInt("studied_count");
                String date = rs.getString("date");

                DecksStudiesOverTime o = new DecksStudiesOverTime();

                o.setStudyCount(studyCount);
                o.setDate(date);

                l.add(o);
            }
        } catch (SQLException e) {
            System.out.println("getDecksStudyOvertime error!" + e.getMessage());
        }

        return l;
    }
}

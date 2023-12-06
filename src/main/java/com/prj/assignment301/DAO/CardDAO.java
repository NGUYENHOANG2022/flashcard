/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.DAO;

import com.prj.assignment301.db.ConnectionPool;
import com.prj.assignment301.javabean.CardMeta;
import com.prj.assignment301.model.Card;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Hieu
 */
public class CardDAO {

	public Card addCard(String front, String back, String tags, int deckId, int ownerId) {
		Card addedCard = null;
		String sql = "DECLARE @front NVARCHAR(100) = ?\n"
						+ "DECLARE @back NVARCHAR(100) = ?\n"
						+ "DECLARE @tags NVARCHAR(200) = ?\n"
						+ "DECLARE @deck_id INT = ?\n"
						+ "DECLARE @user_id INT = ?\n"
						+ "\n"
						+ "IF NOT EXISTS(SELECT 1 FROM Decks WHERE deck_id = @deck_id AND owner_id = @user_id)\n"
						+ "BEGIN\n"
						+ "  RAISERROR('Deck not found or user is not the owner.', 16, 1);\n"
						+ "  RETURN;\n"
						+ "END\n"
						+ "\n"
						+ "INSERT INTO Cards (front, back, tags, deck_id)\n"
						+ "VALUES (@front, @back, @tags, @deck_id);\n"
						+ "\n"
						+ "SELECT card_id, front, back, tags, deck_id\n"
						+ "FROM Cards\n"
						+ "WHERE card_id = SCOPE_IDENTITY();";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql);) {

			ps.setString(1, front);
			ps.setString(2, back);
			ps.setString(3, tags);
			ps.setInt(4, deckId);
			ps.setInt(5, ownerId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					addedCard = new Card(rs.getInt("card_id"), rs.getString("front"),
									rs.getString("back"), rs.getString("tags"), rs.getInt("deck_id"));
				}
			}
		} catch (SQLException e) {
			System.out.println("addCard errors!" + e.getMessage());
		}

		return addedCard;
	}

	public boolean deleteCard(int cardId, int ownerId) {
		boolean success = false;
		String sql = "DECLARE @card_id INT = ?;\n"
						+ "DECLARE @deck_owner_id INT;\n"
						+ "\n"
						+ "SELECT @deck_owner_id = d.owner_id\n"
						+ "FROM Decks d\n"
						+ "INNER JOIN Cards c ON d.deck_id = c.deck_id\n"
						+ "WHERE c.card_id = @card_id;\n"
						+ "\n"
						+ "IF @deck_owner_id IS NULL\n"
						+ "BEGIN\n"
						+ "  RAISERROR('Card not found.', 16, 1);\n"
						+ "  RETURN;\n"
						+ "END\n"
						+ "\n"
						+ "DECLARE @user_id INT = ?;\n"
						+ "\n"
						+ "IF @deck_owner_id <> @user_id\n"
						+ "BEGIN\n"
						+ "  RAISERROR('User is not the owner of the deck that contains the card.', 16, 1);\n"
						+ "  RETURN;\n"
						+ "END\n"
						+ "\n"
						+ "DELETE FROM Cards\n"
						+ "WHERE card_id = @card_id;\n"
						+ "\n"
						+ "SELECT @@ROWCOUNT; -- returns the number of rows affected by the DELETE statement";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql);) {
			ps.setInt(1, cardId);
			ps.setInt(2, ownerId);
			int deletedRows = ps.executeUpdate();

			if (deletedRows > 0) {
				success = true;
			}
		} catch (SQLException e) {
			System.out.println("deleteCard errors!" + e.getMessage());
		}

		return success;
	}

	public CardMeta getCard(int cardId, int ownerId) {
		CardMeta card = null;
		String sql = "DECLARE @cardId INT = ?\n"
						+ "DECLARE @userId INT = ?\n"
						+ "SELECT c.card_id, c.front, c.back, c.tags, c.deck_id, d.name AS deck_name, d.private\n"
						+ "FROM Cards c\n"
						+ "INNER JOIN Decks d ON c.deck_id = d.deck_id\n"
						+ "WHERE c.card_id = @cardId\n"
						+ "AND d.owner_id = @userId";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql);) {
			ps.setInt(1, cardId);
			ps.setInt(2, ownerId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					card = new CardMeta();
					card.setCardId(rs.getInt("card_id"));
					card.setFront(rs.getString("front"));
					card.setBack(rs.getString("back"));
					card.setTags(rs.getString("tags"));
					card.setDeckId(rs.getInt("deck_id"));
					card.setPrivateDeck(rs.getInt("private"));
					card.setDeckName(rs.getString("deck_name"));

					return card;
				}
			}
		} catch (SQLException e) {
			System.out.println("getCard errors!" + e.getMessage());
		}
		return card;
	}

	public boolean updateCard(String front, String back, String tags, int cardId, int ownerId) {
		boolean success = false;
		String sql = "DECLARE @card_id INT = ?\n"
						+ "DECLARE @user_id INT = ?\n"
						+ "DECLARE @front NVARCHAR(100) = ?\n"
						+ "DECLARE @back NVARCHAR(100) = ?\n"
						+ "DECLARE @tags NVARCHAR(200) = ?\n"
						+ "UPDATE Cards \n"
						+ "SET front = @front, back = @back, tags = @tags\n"
						+ "WHERE card_id = @card_id \n"
						+ "AND deck_id IN (SELECT deck_id FROM Decks WHERE owner_id = @user_id);";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql);) {
			ps.setInt(1, cardId);
			ps.setInt(2, ownerId);
			ps.setString(3, front);
			ps.setString(4, back);
			ps.setString(5, tags);
			int updatedRows = ps.executeUpdate();

			if (updatedRows > 0) {
				success = true;
			}
		} catch (SQLException e) {
			System.out.println("updateCard errors!" + e.getMessage());
		}

		return success;
	}

	public List<Card> getCardsPagination(int deckId, int page, int pageSize) {
		List<Card> cards = new ArrayList<>();
		String sql = "SELECT card_id, front, back, tags "
						+ "FROM Cards "
						+ "WHERE deck_id = ? "
						+ "ORDER BY card_id "
						+ "OFFSET ? ROWS "
						+ "FETCH NEXT ? ROWS ONLY";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, deckId);
			ps.setInt(2, (page - 1) * pageSize);
			ps.setInt(3, pageSize);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Card card = new Card();
				card.setCardId(rs.getInt("card_id"));
				card.setFront(rs.getString("front"));
				card.setBack(rs.getString("back"));
				card.setTags(rs.getString("tags"));
				cards.add(card);
			}
		} catch (SQLException ex) {
			System.out.println("getCardsPagination errors!" + ex.getMessage());
		}

		return cards;
	}

	public List<CardMeta> getCardsSearchByCardName(int userId, String s, int page, int pageSize) {
		List<CardMeta> cards = new ArrayList<>();
		String sql = "DECLARE @userId INT = ?;\n"
						+ "DECLARE @PageNumber INT = ?;\n"
						+ "DECLARE @PageSize INT = ?;\n"
						+ "DECLARE @search NVARCHAR(100) = ?;\n"
						+ "SELECT Cards.*, Decks.name AS deck_name, Decks.private FROM Cards\n"
						+ "INNER JOIN Decks ON Cards.deck_id = Decks.deck_id\n"
						+ "LEFT JOIN DeckShares ON DeckShares.deck_id = Decks.deck_id\n"
						+ "WHERE (Decks.owner_id = @userId OR DeckShares.user_id = @userId)\n"
						+ "AND (Cards.front LIKE CONCAT(N'%', @search, N'%') OR Cards.back LIKE CONCAT(N'%', @search, N'%'))\n"
						+ "ORDER BY Cards.card_id\n"
						+ "OFFSET @PageNumber ROWS\n"
						+ "FETCH NEXT @PageSize ROWS ONLY;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setInt(2, (page - 1) * pageSize);
			ps.setInt(3, pageSize);
			ps.setString(4, s);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				CardMeta card = new CardMeta();
				card.setCardId(rs.getInt("card_id"));
				card.setFront(rs.getString("front"));
				card.setBack(rs.getString("back"));
				card.setTags(rs.getString("tags"));
				card.setDeckName(rs.getString("deck_name"));
				card.setDeckId(rs.getInt("deck_id"));
				card.setPrivateDeck(rs.getInt("private"));
				cards.add(card);
			}
		} catch (SQLException ex) {
			System.out.println("getCardsSearchByCardName errors!" + ex.getMessage());
		}

		return cards;
	}

	public List<CardMeta> getCardsSearchByTagName(int userId, String s, int page, int pageSize) {
		List<CardMeta> cards = new ArrayList<>();
		String sql = "DECLARE @userId INT = ?;\n"
						+ "DECLARE @PageNumber INT = ?;\n"
						+ "DECLARE @PageSize INT = ?;\n"
						+ "DECLARE @search NVARCHAR(100) = ?;\n"
						+ "SELECT Cards.*, Decks.name AS deck_name, Decks.private FROM Cards\n"
						+ "INNER JOIN Decks ON Cards.deck_id = Decks.deck_id\n"
						+ "LEFT JOIN DeckShares ON DeckShares.deck_id = Decks.deck_id\n"
						+ "WHERE (Decks.owner_id = @userId OR DeckShares.user_id = @userId)\n"
						+ "AND Cards.tags LIKE CONCAT(N'%', @search, N'%')\n"
						+ "ORDER BY Cards.card_id\n"
						+ "OFFSET @PageNumber ROWS\n"
						+ "FETCH NEXT @PageSize ROWS ONLY;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setInt(2, (page - 1) * pageSize);
			ps.setInt(3, pageSize);
			ps.setString(4, s);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				CardMeta card = new CardMeta();
				card.setCardId(rs.getInt("card_id"));
				card.setFront(rs.getString("front"));
				card.setBack(rs.getString("back"));
				card.setTags(rs.getString("tags"));
				card.setDeckName(rs.getString("deck_name"));
				card.setDeckId(rs.getInt("deck_id"));
				card.setPrivateDeck(rs.getInt("private"));
				cards.add(card);
			}
		} catch (SQLException ex) {
			System.out.println("getCardsSearchByTagName errors!" + ex.getMessage());
		}

		return cards;
	}

	public List<CardMeta> getCardsSearchByDeckName(int userId, String s, int page, int pageSize) {
		List<CardMeta> cards = new ArrayList<>();
		String sql = "DECLARE @userId INT = ?;\n"
						+ "DECLARE @PageNumber INT = ?;\n"
						+ "DECLARE @PageSize INT = ?;\n"
						+ "DECLARE @search NVARCHAR(100) = ?;\n"
						+ "SELECT Cards.*, Decks.name AS deck_name, Decks.private FROM Cards\n"
						+ "INNER JOIN Decks ON Cards.deck_id = Decks.deck_id\n"
						+ "LEFT JOIN DeckShares ON DeckShares.deck_id = Decks.deck_id\n"
						+ "WHERE (Decks.owner_id = @userId OR DeckShares.user_id = @userId)\n"
						+ "AND Decks.name LIKE CONCAT(N'%', @search, N'%')\n"
						+ "ORDER BY Cards.card_id\n"
						+ "OFFSET @PageNumber ROWS\n"
						+ "FETCH NEXT @PageSize ROWS ONLY;";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setInt(2, (page - 1) * pageSize);
			ps.setInt(3, pageSize);
			ps.setString(4, s);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				CardMeta card = new CardMeta();
				card.setCardId(rs.getInt("card_id"));
				card.setFront(rs.getString("front"));
				card.setBack(rs.getString("back"));
				card.setTags(rs.getString("tags"));
				card.setDeckName(rs.getString("deck_name"));
				card.setDeckId(rs.getInt("deck_id"));
				card.setPrivateDeck(rs.getInt("private"));
				cards.add(card);
			}
		} catch (SQLException ex) {
			System.out.println("getCardsSearchByDeckName errors!" + ex.getMessage());
		}

		return cards;
	}

	public int getTotalCardsSearchByDeckName(int userId, String s) {
		String sql = "DECLARE @userId INT = ?;\n"
						+ "DECLARE @search NVARCHAR(100) = ?;\n"
						+ "SELECT COUNT(*) AS total_count FROM Cards\n"
						+ "INNER JOIN Decks ON Cards.deck_id = Decks.deck_id\n"
						+ "LEFT JOIN DeckShares ON DeckShares.deck_id = Decks.deck_id\n"
						+ "WHERE (Decks.owner_id = @userId OR DeckShares.user_id = @userId)\n"
						+ "AND Decks.name LIKE CONCAT(N'%', @search, N'%');";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setString(2, s);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getInt("total_count");
			}
		} catch (SQLException ex) {
			System.out.println("getTotalCardsSearchByDeckName errors!" + ex.getMessage());
		}

		return 0;
	}

	public int getTotalCardsSearchByCardName(int userId, String s) {
		String sql = "DECLARE @userId INT = ?;\n"
						+ "DECLARE @search NVARCHAR(100) = ?;\n"
						+ "SELECT COUNT(*) AS total_count FROM Cards\n"
						+ "INNER JOIN Decks ON Cards.deck_id = Decks.deck_id\n"
						+ "LEFT JOIN DeckShares ON DeckShares.deck_id = Decks.deck_id\n"
						+ "WHERE (Decks.owner_id = @userId OR DeckShares.user_id = @userId)\n"
						+ "AND (Cards.front LIKE CONCAT(N'%', @search, N'%') OR Cards.back LIKE CONCAT(N'%', @search, N'%'));";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setString(2, s);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getInt("total_count");
			}
		} catch (SQLException ex) {
			System.out.println("getTotalCardsSearchByCardName errors!" + ex.getMessage());
		}

		return 0;
	}

	public int getTotalCardsSearchByTagName(int userId, String s) {
		String sql = "DECLARE @userId INT = ?;\n"
						+ "DECLARE @search NVARCHAR(100) = ?;\n"
						+ "SELECT COUNT(*) AS total_count FROM Cards\n"
						+ "INNER JOIN Decks ON Cards.deck_id = Decks.deck_id\n"
						+ "LEFT JOIN DeckShares ON DeckShares.deck_id = Decks.deck_id\n"
						+ "WHERE (Decks.owner_id = @userId OR DeckShares.user_id = @userId)\n"
						+ "AND Cards.tags LIKE CONCAT(N'%', @search, N'%')";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, userId);
			ps.setString(2, s);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getInt("total_count");
			}
		} catch (SQLException ex) {
			System.out.println("getTotalCardsSearchByCardName errors!" + ex.getMessage());
		}

		return 0;
	}

	public List<Card> getCardsForFlashCards(int deckId, int userId) {
		List<Card> cards = new ArrayList<>();
		String sql = "DECLARE \n"
						+ "  @deck_id INT = ?,\n"
						+ "  @user_id INT = ?\n"
						+ "\n"
						+ "IF EXISTS (\n"
						+ "  SELECT 1 FROM Decks d\n"
						+ "  LEFT JOIN DeckShares ds ON d.deck_id = ds.deck_id\n"
						+ "  WHERE d.deck_id = @deck_id\n"
						+ "  AND ((d.private = 1 AND (d.owner_id = @user_id OR ds.user_id = @user_id)) OR d.private = 0)\n"
						+ ")\n"
						+ "BEGIN\n"
						+ "  -- retrieve cards of the deck\n"
						+ "  SELECT * FROM Cards\n"
						+ "  WHERE deck_id = @deck_id\n"
						+ "  \n"
						+ "  -- check if a DeckHistories record exists for the deck and the date of today\n"
						+ "  IF EXISTS (\n"
						+ "    SELECT 1 FROM DeckHistories\n"
						+ "    WHERE deck_id = @deck_id\n"
						+ "    AND user_id = @user_id\n"
						+ "    AND date = CONVERT(DATE, GETDATE())\n"
						+ "  )\n"
						+ "  BEGIN\n"
						+ "    -- increase the study_count of the existing DeckHistories record\n"
						+ "    UPDATE DeckHistories\n"
						+ "    SET study_count = study_count + 1, latest_update = CURRENT_TIMESTAMP\n"
						+ "    WHERE deck_id = @deck_id\n"
						+ "    AND user_id = @user_id\n"
						+ "    AND date = CONVERT(DATE, GETDATE())\n"
						+ "  END\n"
						+ "  ELSE\n"
						+ "  BEGIN\n"
						+ "    -- create a new DeckHistories record\n"
						+ "    INSERT INTO DeckHistories (date, study_count, deck_id, user_id, latest_update)\n"
						+ "    VALUES (CONVERT(DATE, GETDATE()), 1, @deck_id, @user_id, CURRENT_TIMESTAMP)\n"
						+ "  END\n"
						+ "END";

		try (Connection conn = ConnectionPool.getDataSource().getConnection();
						PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, deckId);
			if (userId == 0) {
				ps.setNull(2, Types.INTEGER);
			} else {
				ps.setInt(2, userId);
			}

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Card card = new Card();
				card.setCardId(rs.getInt("card_id"));
				card.setFront(rs.getString("front"));
				card.setBack(rs.getString("back"));
				card.setTags(rs.getString("tags"));
				card.setDeckId(rs.getInt("deck_id"));
				cards.add(card);
			}
		} catch (SQLException ex) {
			System.out.println("getCardsForFlashCards errors!" + ex.getMessage());
		}

		return cards;
	}


}

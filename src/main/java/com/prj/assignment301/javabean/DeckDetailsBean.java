/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.javabean;

import com.prj.assignment301.model.Card;
import java.io.Serializable;
import java.util.List;

/**
 *
 * @author Admin
 */
public class DeckDetailsBean implements Serializable {

	private static final long serialVersionUID = 1L;
	private String name;
	private String description;
	private int privateDeck;
	private int ownerId;
	private int deckId;
	private String ownerName;
	private String ownerEmail;
	private String ownerAvatar;
	private int cardCount;
	private int sharedUsersCount;
	private int deckStudiesToday;
	private List<Card> cardsList;

	public int getCardCount() {
		return cardCount;
	}

	public void setCardCount(int cardCount) {
		this.cardCount = cardCount;
	}

	public List<Card> getCardsList() {
		return cardsList;
	}

	public void setCardsList(List<Card> cardsList) {
		this.cardsList = cardsList;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getPrivateDeck() {
		return privateDeck;
	}

	public void setPrivateDeck(int privateDeck) {
		this.privateDeck = privateDeck;
	}

	public int getOwnerId() {
		return ownerId;
	}

	public void setOwnerId(int ownerId) {
		this.ownerId = ownerId;
	}

	public int getDeckId() {
		return deckId;
	}

	public void setDeckId(int deckId) {
		this.deckId = deckId;
	}

	public String getOwnerName() {
		return ownerName;
	}

	public void setOwnerName(String ownerName) {
		this.ownerName = ownerName;
	}

	public String getOwnerEmail() {
		return ownerEmail;
	}

	public void setOwnerEmail(String ownerEmail) {
		this.ownerEmail = ownerEmail;
	}

	public String getOwnerAvatar() {
		return ownerAvatar;
	}

	public void setOwnerAvatar(String ownerAvatar) {
		this.ownerAvatar = ownerAvatar;
	}

	public int getSharedUsersCount() {
		return sharedUsersCount;
	}

	public void setSharedUsersCount(int sharedUsersCount) {
		this.sharedUsersCount = sharedUsersCount;
	}

	public int getDeckStudiesToday() {
		return deckStudiesToday;
	}

	public void setDeckStudiesToday(int deckStudiesToday) {
		this.deckStudiesToday = deckStudiesToday;
	}

}

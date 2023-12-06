/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.javabean;

import java.io.Serializable;

/**
 *
 * @author Admin
 */
public class CardMeta implements Serializable {

	private static final long serialVersionUID = 1L;
	private int cardId;
	private String front;
	private String back;
	private String tags;
	private int deckId;
	private String deckName;
	private int privateDeck;

	public CardMeta() {
	}

	public CardMeta(int cardId, String front, String back, String tags, int deckId, String deckName, int privateDeck) {
		this.cardId = cardId;
		this.front = front;
		this.back = back;
		this.tags = tags;
		this.deckId = deckId;
		this.deckName = deckName;
		this.privateDeck = privateDeck;
	}

	public int getCardId() {
		return cardId;
	}

	public void setCardId(int cardId) {
		this.cardId = cardId;
	}

	public String getFront() {
		return front;
	}

	public void setFront(String front) {
		this.front = front;
	}

	public String getBack() {
		return back;
	}

	public void setBack(String back) {
		this.back = back;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public int getDeckId() {
		return deckId;
	}

	public void setDeckId(int deckId) {
		this.deckId = deckId;
	}

	public String getDeckName() {
		return deckName;
	}

	public void setDeckName(String deckName) {
		this.deckName = deckName;
	}

	public int getPrivateDeck() {
		return privateDeck;
	}

	public void setPrivateDeck(int privateDeck) {
		this.privateDeck = privateDeck;
	}

}

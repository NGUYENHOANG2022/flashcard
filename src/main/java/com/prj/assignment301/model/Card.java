/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.model;

import java.io.Serializable;

/**
 *
 * @author Admin
 */
public class Card implements Serializable {

	private static final long serialVersionUID = 1L;
	private int cardId;
	private String front;
	private String back;
	private String tags;
	private int deckId;

	public Card() {
	}

	public Card(int cardId, String front, String back, String tags, int deckId) {
		this.cardId = cardId;
		this.front = front;
		this.back = back;
		this.tags = tags;
		this.deckId = deckId;
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

}

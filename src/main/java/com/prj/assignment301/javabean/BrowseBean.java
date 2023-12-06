/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.javabean;

import java.io.Serializable;
import java.util.List;

/**
 *
 * @author Admin
 */
public class BrowseBean implements Serializable {

	private static final long serialVersionUID = 1L;
	private List<CardMeta> cards;
	private int totalCards;

	public List<CardMeta> getCards() {
		return cards;
	}

	public void setCards(List<CardMeta> cards) {
		this.cards = cards;
	}

	public int getTotalCards() {
		return totalCards;
	}

	public void setTotalCards(int totalCards) {
		this.totalCards = totalCards;
	}
}

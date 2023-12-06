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
public class UsersDecksOverTime implements Serializable {

	private static final long serialVersionUID = 1L;
	private int newUsers;
	private int newDecks;
	private String date;

	public int getNewUsers() {
		return newUsers;
	}

	public void setNewUsers(int newUsers) {
		this.newUsers = newUsers;
	}

	public int getNewDecks() {
		return newDecks;
	}

	public void setNewDecks(int newDecks) {
		this.newDecks = newDecks;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

}

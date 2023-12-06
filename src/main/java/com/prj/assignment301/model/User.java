/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.model;

import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author Admin
 */
public class User implements Serializable {

	private static final long serialVersionUID = 1L;
	private int userId;
	private String email;
	private String name;
	private String password;
	private String avatar;
	private Date createdAt;
        private int deckCount;

        public int getDeckCount() {
            return deckCount;
        }

        public void setDeckCount(int deckCount) {
            this.deckCount = deckCount;
        }

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
}

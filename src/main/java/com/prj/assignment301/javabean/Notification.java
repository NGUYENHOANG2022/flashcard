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
public class Notification implements Serializable {

	private static final long serialVersionUID = 1L;
	private String title;
	private String message;
	private String type; // sussess or error
	private boolean show;

	public Notification() {
	}

	public Notification(String title, String message, String type, boolean show) {
		this.title = title;
		this.message = message;
		this.type = type;
		this.show = show;
	}

	public Notification(String title, String message, String type) {
		this.title = title;
		this.message = message;
		this.type = type;
		this.show = true;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public boolean isShow() {
		return show;
	}

	public void setShow(boolean show) {
		this.show = show;
	}

}

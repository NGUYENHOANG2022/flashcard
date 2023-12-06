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
public class LoginErrors implements Serializable {

	private static final long serialVersionUID = 1L;
	private String email;
	private String password;
	private String emailErrs;
	private String passwordErrs;

	public LoginErrors() {
	}

	public LoginErrors(String email, String password, String emailErrs, String passwordErrs) {
		this.email = email;
		this.password = password;
		this.emailErrs = emailErrs;
		this.passwordErrs = passwordErrs;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmailErrs() {
		return emailErrs;
	}

	public void setEmailErrs(String emailErrs) {
		this.emailErrs = emailErrs;
	}

	public String getPasswordErrs() {
		return passwordErrs;
	}

	public void setPasswordErrs(String passwordErrs) {
		this.passwordErrs = passwordErrs;
	}

}

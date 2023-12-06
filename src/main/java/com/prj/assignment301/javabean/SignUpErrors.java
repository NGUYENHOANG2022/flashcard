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
public class SignUpErrors implements Serializable {

	private static final long serialVersionUID = 1L;
	private String email;
	private String name;
	private String emailErr;
	private String nameErr;
	private String passwordErr;
	private String retypePasswordErr;

	public SignUpErrors() {
	}

	public SignUpErrors(String email, String name, String emailErr, String nameErr, String passwordErr, String retypePasswordErr) {
		this.email = email;
		this.name = name;
		this.emailErr = emailErr;
		this.nameErr = nameErr;
		this.passwordErr = passwordErr;
		this.retypePasswordErr = retypePasswordErr;
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

	public String getEmailErr() {
		return emailErr;
	}

	public void setEmailErr(String emailErr) {
		this.emailErr = emailErr;
	}

	public String getNameErr() {
		return nameErr;
	}

	public void setNameErr(String nameErr) {
		this.nameErr = nameErr;
	}

	public String getPasswordErr() {
		return passwordErr;
	}

	public void setPasswordErr(String passwordErr) {
		this.passwordErr = passwordErr;
	}

	public String getRetypePasswordErr() {
		return retypePasswordErr;
	}

	public void setRetypePasswordErr(String retypePasswordErr) {
		this.retypePasswordErr = retypePasswordErr;
	}

}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.model;

import com.prj.assignment301.utils.ReadStatus;
import com.prj.assignment301.utils.TicketStatus;
import java.io.Serializable;
import java.util.Date;

/**
 *
 * @author hieunghia
 */
public class SupportTicket implements Serializable {

	private static final long serialVersionUID = 1L;
	private int ticketId;
	private String message;
	private String senderEmail;
	private String senderName;
	private Date createdAt;
	private TicketStatus status;
	private String responseMes;
	private Date responsedAt;
	private ReadStatus userRead;
	private int userId;
	private int adminId;
        
        public SupportTicket(){
            super();
        }

	public String getSenderEmail() {
		return senderEmail;
	}

	public void setSenderEmail(String senderEmail) {
		this.senderEmail = senderEmail;
	}

	public String getSenderName() {
		return senderName;
	}

	public void setSenderName(String senderName) {
		this.senderName = senderName;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public int getTicketId() {
		return ticketId;
	}

	public void setTicketId(int ticketId) {
		this.ticketId = ticketId;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public TicketStatus getStatus() {
		return status;
	}

	public void setStatus(TicketStatus status) {
		this.status = status;
	}

	public String getResponseMes() {
		return responseMes;
	}

	public void setResponseMes(String responseMes) {
		this.responseMes = responseMes;
	}

	public Date getResponsedAt() {
		return responsedAt;
	}

	public void setResponsedAt(Date responsedAt) {
		this.responsedAt = responsedAt;
	}

	public ReadStatus getUserRead() {
		return userRead;
	}

	public void setUserRead(ReadStatus userRead) {
		this.userRead = userRead;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getAdminId() {
		return adminId;
	}

	public void setAdminId(int adminId) {
		this.adminId = adminId;
	}

}

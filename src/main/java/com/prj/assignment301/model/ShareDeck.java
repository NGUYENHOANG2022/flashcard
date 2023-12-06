/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.model;

import java.io.Serializable;

/**
 *
 * @author hieunghia
 */
public class ShareDeck implements Serializable {
    private static final long serialVersionUID = 1L;
    private String userRead;
    private int userId;
    private int deckId;

    public String getUserRead() {
        return userRead;
    }

    public void setUserRead(String userRead) {
        this.userRead = userRead;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getDeckId() {
        return deckId;
    }

    public void setDeckId(int deckId) {
        this.deckId = deckId;
    }
    
    
}

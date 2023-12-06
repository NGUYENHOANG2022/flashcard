/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.javabean;

import java.io.Serializable;

/**
 *
 * @author LAPTOP
 */
public class DeckMeta implements Serializable {

    private static final long serialVersionUID = 1L;
    private String name;
    private int deckId;
    private int privateDeck;

    public DeckMeta(String name, int deckId, int privateDeck) {
        this.name = name;
        this.deckId = deckId;
        this.privateDeck = privateDeck;
    }

    public DeckMeta() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDeckId() {
        return deckId;
    }

    public void setDeckId(int deckId) {
        this.deckId = deckId;
    }

    public int getPrivateDeck() {
        return privateDeck;
    }

    public void setPrivateDeck(int privateDeck) {
        this.privateDeck = privateDeck;
    }
    
}

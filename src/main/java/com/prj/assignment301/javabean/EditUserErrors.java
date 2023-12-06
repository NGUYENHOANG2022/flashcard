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
public class EditUserErrors implements Serializable {

    private static final long serialVersionUID = 1L;
    private String name;
    private String password;
    private String avatar;

    private String nameErr;
    private String avatarErr;
    private String passwordErr;
    private String retypePasswordErr;

    public EditUserErrors() {
    }

    public EditUserErrors(String name, String password, String avatar, String nameErr, String avatarErr, String passwordErr, String retypePasswordErr) {
        this.name = name;
        this.password = password;
        this.avatar = avatar;
        this.nameErr = nameErr;
        this.avatarErr = avatarErr;
        this.passwordErr = passwordErr;
        this.retypePasswordErr = retypePasswordErr;
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

    public String getNameErr() {
        return nameErr;
    }

    public void setNameErr(String nameErr) {
        this.nameErr = nameErr;
    }

    public String getAvatarErr() {
        return avatarErr;
    }

    public void setAvatarErr(String avatarErr) {
        this.avatarErr = avatarErr;
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

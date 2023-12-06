/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.prj.assignment301.db;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 *
 * @author Nguyen
 */
public class ConnectionPool {
	private static DataSource dataSource;

	// The static block is stored in the memory during the time of class loading 
	// and before the main method is executed, so the static block is executed 
	// before the main method. It runs once when the class is loaded into the memory
	static {
		try {
			Context initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/mydb");
		} catch (NamingException e) {
			throw new RuntimeException("Cannot initialize DataSource", e);
		}
	}

	public static DataSource getDataSource() {
		return dataSource;
	}
}

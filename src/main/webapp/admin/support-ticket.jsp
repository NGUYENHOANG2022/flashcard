<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	pageContext.setAttribute("supTickets", request.getAttribute("supportTickets"));
	pageContext.setAttribute("updateTicket", request.getContextPath() + AppPaths.ADMIN_SUPPORT_TICKET + "?ticket_id=");
	String logoutPath = request.getContextPath() + AppPaths.LOGOUT;
	String dashboardPath = request.getContextPath() + AppPaths.ADMIN;
	String usersPath = request.getContextPath() + AppPaths.ADMIN_USERS;
	String supportTicketsPath = request.getContextPath() + AppPaths.ADMIN_SUPPORT_TICKET;
%>


<!DOCTYPE html>
<html>
	<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Admin - Support tickets</title>
		<!-- Boxicons -->
		<link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
		<!-- My CSS -->
		<tag:head
			alpine="true"
			cssPath="/assets/css/index.css"
			contextPath="${pageContext.request.contextPath}"
			/>
		<link rel="stylesheet" href="../assets/css/admin.css">
	</head>
	<body>
		<!-- SIDEBAR -->
		<section id="sidebar">
			<a href="#" class="brand">
				<i class='bx bxs-smile'></i>
				<span class="text">Flashcard</span>
			</a>
			<ul class="side-menu top">
				<li>
					<a href="<%= dashboardPath%>">
						<i class='bx bxs-dashboard' ></i>
						<span class="text">Dashboard</span>
					</a>
				</li>
				<li>
					<a href="<%= usersPath%>">
						<i class='bx bxs-contact'></i>
						<span class="text">Users</span>
					</a>
				</li>
				<li class="active">
					<a href="<%= supportTicketsPath%>">
						<i class='bx bxs-doughnut-chart' ></i>
						<span class="text">Support Tickets</span>
					</a>
				</li>
			</ul>
			<ul class="side-menu">
				<li>
					<a href="<%= logoutPath%>" class="logout">
						<i class='bx bxs-log-out-circle' ></i>
						<span class="text">Logout</span>
					</a>
				</li>
			</ul>
		</section>
		<!-- SIDEBAR -->



		<!-- CONTENT -->
		<section id="content">
			<!-- NAVBAR -->
			<nav>
				<i class='bx bx-menu' ></i>

				<div class="relative ml-3">
					<div class="peer h-full items-center flex">
						<button class="w-8 h-8 m-2 bg-gray-400 text-sm rounded-full flex items-center justify-center text-white focus:outline-none focus:shadow-solid">
							<img
								class="h-8 w-8 rounded-full"
								src="https://api.dicebear.com/5.x/adventurer/svg?seed=admin"
								alt="Profile Image"
								/>
						</button>
					</div>
					<div class="hidden peer-hover:block hover:block origin-top-right absolute right-0 z-10 pt-2 w-48 rounded-md shadow-lg">
						<div class="py-1 rounded-md bg-white shadow-xs">
							<a href="<%= logoutPath%>"
								 class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Logout</a>
						</div>
					</div>
				</div>
			</nav>
			<!-- NAVBAR -->

			<!-- MAIN -->
			<main>
				<div class="head-title">
					<div class="left">
						<ul class="breadcrumb">
							<li>
								<a href="#">Admin</a>
							</li>
							<li><i class='bx bx-chevron-right' ></i></li>
							<li>
								<a class="active" href="#">Support Ticket</a>
							</li>
						</ul>
					</div>
				</div>

				<div class="table-data">
					<div class="order shadow-md">
						<table>
							<thead>
								<tr>
									<th>Email</th>
									<th>Created at</th>
									<th>Status</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${pageScope.supTickets}" var="sup">
									<tr>
										<td>
											<a href="<%= supportTicketsPath%>?ticket_id=${sup.ticketId}">${sup.senderEmail}</a>
										</td>
										<td>
											<a href="<%= supportTicketsPath%>?ticket_id=${sup.ticketId}">
												${sup.createdAt}
											</a>
										</td>
										<td>
											<span class="status ${sup.status}">${sup.status}</span>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
					<c:if test="${not empty requestScope.ticketDetails}">
						<div class="todo shadow-md">
							<form action="${pageScope.updateTicket}${requestScope.ticketDetails.ticketId}" method="POST">
								<input name="ticket_id" hidden required value="${requestScope.ticketDetails.ticketId}"/>
								<div class="head">
									<h3>Ticket details</h3>
								</div>
								<div class="mb-8 grid grid-cols-6 gap-2 items-center">
									<label class="col-span-1 block text-gray-700 font-semibold" for="email">
										Email: 
									</label>
									<input
										class="col-span-5 appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none select-none read-only:bg-gray-100"
										id="email"
										name="email"
										type="text"
										placeholder="Enter email"
										required
										value="${requestScope.ticketDetails.senderEmail}"
										readonly="readonly"
										/>
								</div>
								<div class="mb-8 grid grid-cols-6 gap-2 items-center">
									<label class="col-span-1 block text-gray-700 font-semibold" for="name">
										Name: 
									</label>
									<input
										class="col-span-5 appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none select-none read-only:bg-gray-100"
										id="name"
										name="name"
										type="text"
										placeholder="Enter name"
										required
										value="${requestScope.ticketDetails.senderName}"
										readonly="readonly"
										/>
								</div>
								<div class="mb-8 grid grid-cols-6 gap-2">
									<label class="col-span-6 block text-gray-700 font-semibold" for="message">
										Message: 
									</label>
									<textarea
										class="col-span-6 appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none select-none read-only:bg-gray-100"
										id="message"
										name="message"
										type="text"
										rows="6"
										cols="50"
										placeholder="Enter message"
										required
										readonly="readonly"
										>${requestScope.ticketDetails.message}</textarea>
								</div>
								<div class="mb-8 grid grid-cols-6 gap-2 items-center" x-data>
									<label class="col-span-1 block text-gray-700 font-semibold" for="status">
										Status: 
									</label>

									<div class="col-span-5 relative w-48">
										<select 
											id="status"
											name="status"
											class="block truncate appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600">
											<option value="PENDING" x-bind:selected="${ticketDetails.status == 'PENDING'}">PENDING</option>
											<option value="RESOLVED" x-bind:selected="${ticketDetails.status == 'RESOLVED'}">RESOLVED</option>
											<option value="CLOSED" x-bind:selected="${ticketDetails.status == 'CLOSED'}">CLOSED</option>
										</select>
										<div class="absolute inset-y-0 right-0 flex items-center px-2 pointer-events-none">
											<svg class="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M14.95 7.95l-3.97 3.97-3.97-3.97a.75.75 0 0 0-1.06 1.06l4.25 4.25a.75.75 0 0 0 1.06 0l4.25-4.25a.75.75 0 0 0-1.06-1.06z"/></svg>
										</div>
									</div>
								</div>


								<div class="space-x-3">
									<a
										class="bg-white hover:bg-gray-100 border font-bold py-2 px-4 rounded focus:shadow-outline"
										href="${pageScope.updateTicket}${ticketDetails.ticketId}&delete_ticket=true"
										>
										Delete ticket
									</a>
									<button
										class="bg-gray-700 hover:bg-black text-white font-bold py-2 px-4 rounded focus:shadow-outline"
										type="submit"
										>
										Save
									</button>
								</div>
							</form>
						</div>
					</c:if>
				</div>

			</main>
			<!-- MAIN -->
		</section>
		<!-- CONTENT -->


    <jsp:include page="../WEB-INF/jspf/notification.jsp" flush="true"/>
		<script src="../assets/js/script.js"></script>
	</body>
</html>

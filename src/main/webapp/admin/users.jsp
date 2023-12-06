<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	pageContext.setAttribute("changePass", request.getContextPath() + AppPaths.ADMIN_USERS + "?id=");
	String logoutPath = request.getContextPath() + AppPaths.LOGOUT;
	String dashboardPath = request.getContextPath() + AppPaths.ADMIN;
	String usersPath = request.getContextPath() + AppPaths.ADMIN_USERS;
	String supportTicketsPath = request.getContextPath() + AppPaths.ADMIN_SUPPORT_TICKET;
%>

<!DOCTYPE html>
<html lang="en">
	<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Boxicons -->
    <link href='https://unpkg.com/boxicons@2.0.9/css/boxicons.min.css' rel='stylesheet'>
    <!-- My CSS -->
    <tag:head
			alpine="true"
			icon="true"
			cssPath="/assets/css/index.css"
			contextPath="${pageContext.request.contextPath}"
			/>
    <link rel="stylesheet" href="../assets/css/admin.css">

    <title>Admin - Users</title>
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
				<li class="active">
					<a href="<%= usersPath%>">
						<i class='bx bxs-contact'></i>
						<span class="text">Users</span>
					</a>
				</li>
				<li>
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

			<main>
				<div class="head-title">
					<div class="left">
						<ul class="breadcrumb">
							<li>
								<a href="#">Users</a>
							</li>
							<li><i class='bx bx-chevron-right'></i></li>
							<li>
								<a class="active" href="#">details</a>
							</li>
						</ul>
					</div>
				</div>

				<div class="table-data">
					<div class="order shadow-md">
						<table>
							<thead>
								<tr>
									<th>Id</th>
									<th>Email</th>
									<th>Name</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach items="${userList}" var="user">
									<tr>
										<td>
											${user.userId}
										</td>
										<td>
											<a href="?id=${user.userId}">${user.email}</a>
										</td>
										<td>
											<a href="?id=${user.userId}">
												${user.name}
											</a>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>

					<c:if test="${not empty requestScope.userInfo}">
						<div class="todo shadow-md">
							<div class="head">
								<h3>User's details</h3>
							</div>
							<div class="flex gap-2 justify-center items-center">
								<img src="${userInfo.avatar}" class="w-28 h-28 rounded-full">
								<div>
									<p>User ID: <b>${userInfo.userId}</b></p>
									<p>Created at: <b>${userInfo.createdAt}</b></p>
									<p>No. of Decks: <b>${userInfo.deckCount}</b></p>
								</div>
							</div>

							<form action="${pageScope.changePass}${param.id}" method="POST">
								<div class="mb-8">
									<label class="block text-gray-700 font-medium mb-2" for="email">
										Email
									</label>
									<input
										class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none select-none read-only:bg-gray-100"
										id="email"
										name="email"
										type="text"
										placeholder="Enter email"
										required
										value="${userInfo.email}"
										readonly="readonly"
										/>
								</div>

								<div class="mb-8">
									<label class="block text-gray-700 font-medium mb-2" for="name">
										Name
									</label>
									<input
										class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none select-none read-only:bg-gray-100"
										id="name"
										name="name"
										type="text"
										required
										placeholder="Enter name"
										value="${userInfo.name}"
										readonly="readonly"
										/>
								</div>

								<div class="mb-8">
									<label
										class="block text-gray-700 font-medium mb-2"
										for="new-password"
										>
										New password
									</label>
									<input
										class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
										id="new-password"
										name="newPassword"
										type="password"
										autocomplete="off"
										placeholder="Enter a new password"
										/>
								</div>
								<div class="mb-8">
									<label
										class="block text-gray-700 font-medium mb-2"
										for="retype-password"
										>
										Re-enter new password
									</label>
									<input
										class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
										id="retype-password"
										name="retypePassword"
										type="password"
										placeholder="Re-enter new password"
										/>
								</div>
								<div class="space-x-3">
									<a
										class="bg-white hover:bg-gray-100 border font-bold py-2 px-4 rounded focus:shadow-outline"
										href="${pageScope.changePass}${param.id}&delete=true"
										>
										Delete user
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
    </section>

    <!-- Footer -->
    <jsp:include page="../WEB-INF/jspf/notification.jsp" flush="true"/>
		<script src="../assets/js/script.js"></script>

	</body>
</html>

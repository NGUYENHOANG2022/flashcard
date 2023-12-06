<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page import="com.prj.assignment301.utils.Constants"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	pageContext.setAttribute("user", session.getAttribute(Constants.SESSION_USER));
	pageContext.setAttribute("editAvatar", request.getContextPath() + AppPaths.EDIT_AVATAR);
	pageContext.setAttribute("editProfile", request.getContextPath() + AppPaths.EDIT_USER);
	pageContext.setAttribute("deleteProfile", request.getContextPath() + AppPaths.DELETE_USER);
	pageContext.setAttribute("publicProfile", request.getContextPath() + AppPaths.USER_DETAILS + "?email=");
%>
<jsp:useBean id="user" class="com.prj.assignment301.model.User" scope="page" />
<jsp:useBean
	id="ERRORS"
	class="com.prj.assignment301.javabean.EditUserErrors"
	scope="request"
	/>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>FlashCard - Edit user profile</title> 
		<tag:head alpine="true" icon="true" cssPath="/assets/css/index.css" contextPath="${pageContext.request.contextPath}" />
	</head>
	<body>
		<jsp:include page="../WEB-INF/jspf/navbar.jsp" flush="true" />

		<!-- Edit forms -->
		<div class="container py-12 px-6 mx-auto flex-1">
			<div
				class="max-w-5xl mx-auto p-6 bg-white rounded-lg shadow-md md:flex md:justify-between md:items-start"
				>
				<div class="md:w-1/4 mb-6 md:mb-0">
					<div class="mb-6">
						<div class="font-bold text-lg mb-2">Profile</div>
						<div class="border rounded-lg p-4 shadow-sm">
							<div>
								<img
									class="h-20 w-20 bg-gray-400 rounded-full mx-auto"
									src="${user.avatar}"
									alt="Profile Image"
									/>
								<div class="text-center">
									<div class="font-medium">${user.name}</div>
									<div class="text-gray-600 text-sm truncate">
										${user.email}
									</div>
								</div>
							</div>
						</div>
					</div>
					<div>
						<div class="font-bold text-lg mb-2">Navigation</div>
						<div class="border rounded-lg p-4 shadow-sm">
							<ul>
								<li class="mb-4">
									<a href="${pageScope.publicProfile}${user.email}" class="text-indigo-600 hover:text-indigo-500">View public profile</a>
								</li>
								<li class="mb-4">
									<span class="text-gray-600 select-none">Edit profile</span>
								</li>
								<li class="mb-4">
									<a href="${pageScope.editAvatar}" class="text-indigo-600 hover:text-indigo-500">Change avatar</a>
                                                                </li>
								<li class="mb-4">
									<a href="${pageScope.deleteProfile}" class="text-indigo-600 hover:text-indigo-500">Delete account</a>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- Main Content -->
				<div class="flex-grow flex-shrink w-full sm:w-2/3 md:w-3/4 px-4" x-data="editprofile">
					<form class="max-w-lg mx-auto my-7" action="${pageScope.editProfile}" method="POST">
						<div class="mb-8 text-center">
							<h2 class="text-3xl font-medium mb-2">Your Profile</h2>
						</div>
						<div class="border mb-8"></div>

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
								value="${user.email}"
								readonly="readonly"
								/>
						</div>

						<div class="mb-8">
							<label class="block text-gray-700 font-medium mb-2" for="name">
								Your name
							</label>
							<input
								class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
								x-bind:class="{ 'border-red-500': errors.name }"
								id="name"
								name="name"
								type="text"
								required
								placeholder="Enter your name"
								value="${not empty ERRORS.nameErr ? ERRORS.name : user.name}"
								x-on:input="errors.name = ''"
								/>
							<p
								x-show="errors.name"
								class="text-red-700"
								x-text="errors.name"
								></p>
						</div>

						<div class="mb-8">
							<p class="text-gray-600 text-sm mb-2">
								Keep your account safe with a strong password.
							</p>
							<label
								class="block text-gray-700 font-medium mb-2"
								for="new-password"
								>
								New password
							</label>
							<input
								class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
								x-bind:class="{ 'border-red-500': errors.password }"
								id="new-password"
								name="newPassword"
								type="password"
								autocomplete="off"
								placeholder="Enter a new password"
								x-on:input="errors.password = ''"
								/>
							<p
								x-show="errors.password"
								class="text-red-700"
								x-text="errors.password"
								></p>
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
								x-bind:class="{ 'border-red-500': errors.retypePassword }"
								id="retype-password"
								name="retypePassword"
								type="password"
								placeholder="Re-enter new password"
								x-on:input="errors.retypePassword = ''"
								/>
							<p
								x-show="errors.retypePassword"
								class="text-red-700"
								x-text="errors.retypePassword"
								></p>
						</div>
						<div class="space-x-3">
							<button
								class="bg-white hover:bg-gray-100 border font-bold py-2 px-4 rounded focus:shadow-outline"
								type="button"
								>
								Discard changes
							</button>
							<button
								class="bg-gray-700 hover:bg-black text-white font-bold py-2 px-4 rounded focus:shadow-outline"
								type="submit"
								>
								Save
							</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<jsp:include page="../WEB-INF/jspf/footer.jsp" flush="true" />
		<jsp:include page="../WEB-INF/jspf/notification.jsp" flush="true" />

		<script>
			document.addEventListener("alpine:init", () => {
				Alpine.data("editprofile", () => ({
						init() {
							this.errors = {
								name: "${ERRORS.nameErr}",
								password: "${ERRORS.passwordErr}",
								retypePassword: "${ERRORS.retypePasswordErr}"
							};
						},
						errors: {}
					}));
			});
		</script>
	</body>
</html>

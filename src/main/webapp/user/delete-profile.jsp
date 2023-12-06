<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page import="com.prj.assignment301.utils.Constants"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	pageContext.setAttribute("editPage", request.getContextPath() + AppPaths.EDIT_USER);
	pageContext.setAttribute("editAvatarPath", request.getContextPath() + AppPaths.EDIT_AVATAR);
	pageContext.setAttribute("deleteProfilePath", request.getContextPath() + AppPaths.DELETE_USER);
	pageContext.setAttribute("publicProfile", request.getContextPath() + AppPaths.USER_DETAILS + "?email=");
	pageContext.setAttribute("user", session.getAttribute(Constants.SESSION_USER));
%>

<jsp:useBean id="user" class="com.prj.assignment301.model.User" scope="page" />
<jsp:useBean id="ERRORS" class="com.prj.assignment301.javabean.EditUserErrors" scope="request" />

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>FlashCard - Edit user avatar</title>
		<tag:head alpine="true" icon="true" cssPath="/assets/css/index.css" contextPath="${pageContext.request.contextPath}" />
	</head>
	<body>
		<jsp:include page="../WEB-INF/jspf/navbar.jsp" flush="true" />

		<!-- Edit forms -->
		<div class="container py-12 px-6 mx-auto flex-1">
			<div class="max-w-5xl mx-auto p-6 bg-white rounded-lg shadow-md md:flex md:justify-between md:items-start">
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
									<a href="${pageScope.editPage}" class="text-indigo-600 hover:text-indigo-500">Edit profile</a>
								</li>
								<li class="mb-4">
									<a href="${pageScope.editAvatarPath}" class="text-indigo-600 hover:text-indigo-500">Change avatar</a>
								</li>
								<li class="mb-4">
									<span class="text-gray-600 select-none">Delete account</span>
								</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- Main Content -->
				<div class="flex-grow flex-shrink w-full sm:w-2/3 md:w-3/4 px-4" x-data="deleteProfile">
					<form class="max-w-lg mx-auto my-7" action="${pageScope.deleteProfilePath}" method="POST" x-on:submit.prevent="submitForm(event)">
						<div class="mb-8 text-center">
							<h2 class="text-3xl font-medium mb-2">Delete account</h2>
						</div>
						<div class="border mb-8"></div>
						<div class="mb-8">
							<p class="text-center text-xl italic text-gray-600">
								Close your account permanently
							</p>
						</div>
						<div class="mb-8">
							<p class="text-2xl font-bold text-gray-600">
								<span class="text-red-700">Warning*: </span>If you delete your account, you will lose access forever. The cards and decks you've shared will still remain with the person you shared them with.
							</p>
						</div>
						<div>
							<button
								class="block ml-auto bg-gray-700 hover:bg-black text-white font-bold py-2 px-4 rounded focus:shadow-outline"
								type="submit"
								>
								Delete account
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
				Alpine.data("deleteProfile", () => ({
						init() {
							this.errors = {
							};
						},
						errors: {},
						submitForm: function (event) {
							if (confirm('Are you sure you want to delete the account?')) {
								event.target.submit();
							}
						}
					}));
			});
		</script>
	</body>
</html>

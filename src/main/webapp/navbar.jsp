<%@page import="com.prj.assignment301.utils.Constants"%>
<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String signUpPath = request.getContextPath() + AppPaths.SIGNUP;
	String loginPath = request.getContextPath() + AppPaths.LOGIN;
	String logoutPath = request.getContextPath() + AppPaths.LOGOUT;
	String contactPath = request.getContextPath() + AppPaths.CONTACT;
	String statisticsPath = request.getContextPath() + AppPaths.STATISTICS;
	String homePath = request.getContextPath() + AppPaths.HOME;
	String browsePath = request.getContextPath() + AppPaths.BROWSE;
	String addCardsPath = request.getContextPath() + AppPaths.ADD_CARDS;
	String currentPage = request.getRequestURI();
	String editProfilePath = request.getContextPath() + AppPaths.EDIT_USER;
	String iconPath = request.getContextPath() + "/assets/images/logo2.jpg";
	pageContext.setAttribute("iconPath", iconPath);
	String viewPublicProfile = request.getContextPath() + AppPaths.USER_DETAILS + "?email=";
	pageContext.setAttribute("user", session.getAttribute(Constants.SESSION_USER));
%>

<nav x-data="{ open: false }" class="bg-white">
	<div class="mx-auto max-w-6xl px-2 sm:px-6 lg:px-8">
		<div class="relative flex h-16 items-center justify-between">
			<div class="absolute inset-y-0 left-0 flex items-center sm:hidden">
				<button @click="open = !open" type="button" class="inline-flex items-center justify-center rounded-md p-2 hover:bg-gray-700 hover:text-white focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white" x-bind:aria-expanded="open ? 'true' : 'false'">
					<span class="sr-only">Open main menu</span>
					<svg x-bind:class="open ? 'hidden' : 'block h-6 w-6'" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
					<path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
					</svg>
					<svg x-bind:class="open ? 'block h-6 w-6' : 'hidden'" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
					<path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
					</svg>
				</button>
			</div>
			<div class="flex flex-1 items-center justify-center sm:flex-none sm:items-end sm:justify-start">
				<div class="flex flex-shrink-0 items-center">
					<!--<img class="block h-10 w-auto relative top-0 sm:-top-1" src="${pageScope.iconPath}" alt="Flashcard">-->
					<a class="flex items-center gap-2 font-bold" href="<%= homePath%>">
						<img
							class="block h-10 w-auto"
							src="${pageScope.iconPath}"
							alt="Flashcard"
							/>
						<p class="text-xl">Flashcard</p>
					</a>
				</div>
			</div>


			<c:if test="${empty pageScope.user}">
				<!-- ## These 2 buttons show when user NOT login -->
				<div class="hidden relative h-full sm:flex items-center gap-2">
					<div class="relative h-full flex items-center gap-2">
						<a href="<%= contactPath%>" class="mr-4 text-gray-800 hover:text-indigo-600">Contact us</a>
					</div>
					<a
						class="block bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow"
						href="<%= signUpPath%>"
						>
						Sign up
					</a>

					<a
						class="block bg-gray-900 hover:bg-black text-white font-semibold py-2 px-4 border border-gray-400 rounded shadow"
						href="<%= loginPath%>"
						>
						Log in
					</a>
				</div>
				<!-- ## -->
			</c:if>

			<c:if test="${not empty pageScope.user}">
				<div class="hidden flex-1 md:mr-20 sm:block">
					<div class="flex justify-center space-x-4">
						<a href="<%= homePath%>" 
							 x-bind:class="{ 'bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium': <%= currentPage.contains(AppPaths.HOME)%>,
							 'hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium':<%= !currentPage.contains(AppPaths.HOME)%>}"
							 x-bind:aria-current="<%= currentPage.contains(AppPaths.HOME)%> && 'page'">Decks</a>
						<a href="<%= browsePath%>" 
							 x-bind:class="{ 'bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium': <%= currentPage.contains(AppPaths.BROWSE)%>,
							 'hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium':<%= !currentPage.contains(AppPaths.BROWSE)%>}"
							 x-bind:aria-current="<%= currentPage.contains(AppPaths.BROWSE)%> && 'page'">Browse</a>
						<a href="<%= addCardsPath%>" 
							 x-bind:class="{ 'bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium': <%= currentPage.contains(AppPaths.ADD_CARDS)%>,
							 'hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium':<%= !currentPage.contains(AppPaths.ADD_CARDS)%>}"
							 x-bind:aria-current="<%= currentPage.contains(AppPaths.ADD_CARDS)%> && 'page'">Add cards</a>
						<a href="<%= statisticsPath%>" 
							 x-bind:class="{ 'bg-gray-900 text-white rounded-md px-3 py-2 text-sm font-medium': <%= currentPage.contains(AppPaths.CONTACT)%>,
							 'hover:bg-gray-700 hover:text-white rounded-md px-3 py-2 text-sm font-medium':<%= !currentPage.contains(AppPaths.CONTACT)%>}"
							 x-bind:aria-current="<%= currentPage.contains(AppPaths.STATISTICS)%> && 'page'">Statistics</a>
					</div>
				</div>
				<div class="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0">
					<div class="relative ml-3">
						<div class="peer h-full items-center flex">
							<button class="w-8 h-8 m-2 bg-gray-400 text-sm rounded-full flex items-center justify-center text-white focus:outline-none focus:shadow-solid">
								<img
									class="h-8 w-8 rounded-full"
									src="${pageScope.user.avatar}"
									alt="Profile Image"
									/>
							</button>
						</div>
						<div class="hidden peer-hover:block hover:block origin-top-right absolute right-0 z-10 pt-2 w-48 rounded-md shadow-lg">
							<div class="py-1 rounded-md bg-white shadow-xs">
								<a
									href="<%= viewPublicProfile%>${pageScope.user.email}"
									class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
									>View public profile</a>
								<a
									href="<%= editProfilePath%>"
									class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
									>Edit profile</a>
								<a
									href="<%= contactPath%>"
									class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
									>Contact support</a>
								<a
									href="<%= logoutPath%>"
									class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
									>Logout</a>
							</div>
						</div>
					</div>
				</div>
			</c:if>
		</div>
		<div x-show="open" @click.away="open = false" class="sm:hidden" id="mobile-menu">
			<div class="space-y-1 px-2 pt-2 pb-3">
				<c:if test="${not empty pageScope.user}">
					<a href="<%= homePath%>" 
						 x-bind:class="{ 'bg-gray-900 text-white block rounded-md px-3 py-2 text-base font-medium': <%= currentPage.contains(AppPaths.HOME)%>,
						 'hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium':<%= !currentPage.contains(AppPaths.HOME)%>}"
						 x-bind:aria-current="<%= currentPage.contains(AppPaths.HOME)%> && 'page'">Decks</a>
					<a href="<%= browsePath%>" 
						 x-bind:class="{ 'bg-gray-900 text-white block rounded-md px-3 py-2 text-base font-medium': <%= currentPage.contains(AppPaths.BROWSE)%>,
						 'hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium':<%= !currentPage.contains(AppPaths.BROWSE)%>}"
						 x-bind:aria-current="<%= currentPage.contains(AppPaths.BROWSE)%> && 'page'">Browse</a>
					<a href="<%= addCardsPath%>" 
						 x-bind:class="{ 'bg-gray-900 text-white block rounded-md px-3 py-2 text-base font-medium': <%= currentPage.contains(AppPaths.ADD_CARDS)%>,
						 'hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium':<%= !currentPage.contains(AppPaths.ADD_CARDS)%>}"
						 x-bind:aria-current="<%= currentPage.contains(AppPaths.ADD_CARDS)%> && 'page'">Add cards</a>
					<a href="<%= statisticsPath%>" 
						 x-bind:class="{ 'bg-gray-900 text-white block rounded-md px-3 py-2 text-base font-medium': <%= currentPage.contains(AppPaths.CONTACT)%>,
						 'hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium':<%= !currentPage.contains(AppPaths.CONTACT)%>}"
						 x-bind:aria-current="<%= currentPage.contains(AppPaths.STATISTICS)%> && 'page'">Statistics</a>
				</c:if>

				<c:if test="${empty pageScope.user}">
					<a href="<%= contactPath%>"
						 x-bind:class="{ 'bg-gray-900 text-white block rounded-md px-3 py-2 text-base font-medium': <%= currentPage.contains(AppPaths.CONTACT)%>,
						 'hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium':<%= !currentPage.contains(AppPaths.CONTACT)%>}"
						 x-bind:aria-current="<%= currentPage.contains(AppPaths.CONTACT)%> && 'page'">Contact</a>
					<a href="<%= signUpPath%>"
						 x-bind:class="{ 'bg-gray-900 text-white block rounded-md px-3 py-2 text-base font-medium': <%= currentPage.contains(AppPaths.SIGNUP)%>,
						 'hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium':<%= !currentPage.contains(AppPaths.SIGNUP)%>}"
						 x-bind:aria-current="<%= currentPage.contains(AppPaths.SIGNUP)%> && 'page'">Sign up</a>
					<a href="<%= loginPath%>"
						 x-bind:class="{ 'bg-gray-900 text-white block rounded-md px-3 py-2 text-base font-medium': <%= currentPage.contains(AppPaths.LOGIN)%>,
						 'hover:bg-gray-700 hover:text-white block rounded-md px-3 py-2 text-base font-medium':<%= !currentPage.contains(AppPaths.LOGIN)%>}"
						 x-bind:aria-current="<%= currentPage.contains(AppPaths.LOGIN)%> && 'page'">Log in</a>
				</c:if>
			</div>
		</div>
</nav>

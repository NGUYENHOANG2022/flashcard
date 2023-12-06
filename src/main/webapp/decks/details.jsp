<%-- 
    Document   : details
    Created on : Mar 13, 2023, 8:37:20 AM
    Author     : Hieu
--%>

<%@page import="com.prj.assignment301.utils.Constants"%>
<%@page import="com.prj.assignment301.javabean.DeckDetailsBean"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	if (request.getAttribute("deckInfo") == null) {
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
		rd.forward(request, response);
	}
	Gson gson = new Gson();
	DeckDetailsBean deckInfo = (DeckDetailsBean) request.getAttribute("deckInfo");
	String cards = gson.toJson(deckInfo.getCardsList());
	pageContext.setAttribute("deck", deckInfo);
	pageContext.setAttribute("cardsJson", cards);

	pageContext.setAttribute("user", session.getAttribute(Constants.SESSION_USER));
	pageContext.setAttribute("addCardsPath", request.getContextPath() + AppPaths.ADD_CARDS + "?deckId=" + deckInfo.getDeckId());
	pageContext.setAttribute("editCardPath", request.getContextPath() + AppPaths.EDIT_CARD + "?id=");
	pageContext.setAttribute("editDeckPath", request.getContextPath() + AppPaths.EDIT_DECK + "?id=" + deckInfo.getDeckId());
	pageContext.setAttribute("playDeckPath", request.getContextPath() + AppPaths.PLAY_DECK + "?id=" + deckInfo.getDeckId());
	pageContext.setAttribute("shareDeckPath", request.getContextPath() + AppPaths.SHARE_DECK + "?id=" + deckInfo.getDeckId());
	pageContext.setAttribute("deckDetailsPath", request.getContextPath() + AppPaths.DECK_DETAILS + "?id=" + deckInfo.getDeckId());
%>

<jsp:useBean id="deck" class="com.prj.assignment301.javabean.DeckDetailsBean" scope="page" />

<!DOCTYPE html>
<html>
	<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>FlashCard - Deck details</title>
    <tag:head
      alpine="true"
      icon="true"
      cssPath="/assets/css/index.css"
      contextPath="${pageContext.request.contextPath}"
			/>
	</head>
	<body>
		<!-- Navbar -->
		<jsp:include page="../WEB-INF/jspf/navbar.jsp" flush="true" />

    <div class="container py-8 md:py-12 px-6 mx-auto flex-1">
      <div class="max-w-3xl mx-auto p-6 pt-0">
				<div class="mb-10" x-data>
					<div class="flex justify-between items-start">
						<div class="overflow-hidden">
							<p class="block text-2xl font-bold text-gray-800 mb-2 pr-4 truncate" title="${deck.name}">${deck.name}<span 
									class="inline-flex relative top-[-4px] items-center align-middle ml-3 px-3 py-0.5 rounded-full text-sm font-medium" 
									x-bind:class="${deck.privateDeck == 0} ? 'bg-green-100 text-green-800 border-2 border-green-800' : 'bg-red-100 text-red-800 border-2 border-red-800'"
									x-text="${deck.privateDeck == 0} ? 'Public' : 'Private'">
								</span>
							</p>
							<p class="text-gray-500 text-base font-medium mb-4 break-words">${deck.description}</p>
						</div>
						<div class="space-x-3 text-2xl">
							<a href="${pageScope.playDeckPath}" class="transition hover:text-indigo-600" title="Play flashcards"><i class="fa-solid fa-play"></i></a>
								<c:if test="${not empty pageScope.user}">
									<c:if test="${pageScope.user.userId == deck.ownerId}">
									<a href="${pageScope.editDeckPath}" class="transition hover:text-indigo-600" title="Edit deck"><i class="fa-solid fa-pen-to-square"></i></a>
									<a href="${pageScope.shareDeckPath}" class="transition hover:text-indigo-600" title="Share deck"><i class="fa-solid fa-share-nodes"></i></a>
									</c:if>
								</c:if>
						</div>
					</div>
					<div class="border mt-4 mb-8"></div>
					<div class="flex justify-between items-center">
						<div class="flex items-center gap-4 overflow-hidden flex-1">
							<c:if test="${empty deck.ownerAvatar}">
								<div class="h-16 w-16 bg-gray-400 rounded-full mx-auto bg-gray-400 flex justify-center items-center text-2xl">
									<i class="fa-solid fa-user"></i>
								</div>
							</c:if>
							<c:if test="${not empty deck.ownerAvatar}">
								<img
									class="h-16 w-16 bg-gray-400 rounded-full mx-auto"
									src="${deck.ownerAvatar}"
									alt="Profile Image"
									/>
							</c:if>
							<div class="text-lg font-semibold overflow-hidden flex-1">
								<p class="text-gray-500 text-sm truncate">Created by</p>
								<p class="font-bold truncate">${not empty deck.ownerName? deck.ownerName:'Unknown'}</p>
							</div>
						</div>
						<div class="font-medium text-base">
							<p>Shared for <span class="text-red-700 font-bold">${deck.sharedUsersCount}</span> users</p>
							<p><span class="text-red-700 font-bold">${deck.deckStudiesToday}</span> studies today</p>
						</div>
					</div>
				</div>

				<div x-data="cardsList" 
						 x-init="$watch('currentPage', (value) => window.location.href = '${pageScope.deckDetailsPath}&page=' + currentPage + '&perPage=' + perPage)">
					<div class="flex justify-between items-center flex-wrap">
						<p class="text-xl font-bold text-gray-800 mb-2 pr-4 truncate" title="Deck name">Cards in this deck (${deck.cardCount} cards):</p>
						<c:if test="${pageScope.user.userId == deck.ownerId}">
							<a class="text-lg text-indigo-600 font-semibold hover:text-indigo-500 hover:underline hover:underline-offset-2" href="${pageScope.addCardsPath}">Add more card</a>
						</c:if>
					</div>

					<!--Table-->
					<div class="flex flex-col">
						<!-- Table header -->
						<div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
							<div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
								<div class="overflow-hidden border-b border-gray-300 shadow-md sm:rounded-lg">
									<table class="min-w-full divide-y divide-gray-200 table-fixed">
										<thead class="bg-gray-50">
											<tr>
												<th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">#</th>
												<th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Front</th>
												<th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Back</th>
												<th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tags</th>
													<c:if test="${pageScope.user.userId == deck.ownerId}">
													<th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
													</c:if>
											</tr>
										</thead>
										<!-- Table row -->
										<tbody class="bg-white divide-y divide-gray-200">
										<template x-for="(item, index) in cards" x-bind:key="index">
											<tr class="hover:bg-gray-200">
												<td class="px-6 py-4 whitespace-nowrap" x-text="(currentPage - 1)*perPage + 1 + index"></td>
												<td class="px-6 py-4 whitespace-nowrap max-w-[150px] truncate md:hover:overflow-visible md:hover:whitespace-normal" x-text="item.front"></td>
												<td class="px-6 py-4 whitespace-nowrap max-w-[150px] truncate md:hover:overflow-visible md:hover:whitespace-normal" x-text="item.back"></td>
												<td class="px-6 py-4 whitespace-nowrap max-w-[150px] truncate md:hover:overflow-visible md:hover:whitespace-normal" x-text="item.tags"></td>
												<c:if test="${pageScope.user.userId == deck.ownerId}">
													<td class="px-6 py-4 whitespace-nowrap"><a x-bind:href="'${pageScope.editCardPath}' + item.cardId" class="transition hover:text-indigo-600" title="Edit card"><i class="fa-solid fa-pen-to-square"></i></a></td></c:if>
												</tr>
											</template>
											</tbody>
										</table>
									</div>
								</div>
							</div>
						</div>

						<!--Pagination-->
						<div class="flex items-center justify-between border-t border-gray-200 px-4 py-3 sm:px-6">
							<div class="flex flex-1 justify-between sm:hidden">
								<a href="#"
									 class="relative inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
									 x-on:click.prevent="currentPage = Math.max(1, currentPage - 1)" x-bind:disabled="currentPage === 1">Previous</a>
								<a href="#"
									 class="relative ml-3 inline-flex items-center rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
									 x-on:click.prevent="currentPage = Math.min(lastPage, currentPage + 1)" x-bind:disabled="currentPage === lastPage">Next</a>
							</div>
							<div class="hidden sm:flex sm:flex-1 sm:items-center sm:justify-between">
								<div>
									<p class="text-sm text-gray-700">
										Showing
										<span class="font-medium" 
													x-text="(currentPage - 1)*perPage + 1 > totalCards ? totalCards : (currentPage - 1)*perPage + 1 < 0 ? 0 : (currentPage - 1)*perPage + 1"></span>
										to
										<span class="font-medium" x-text="(currentPage - 1)*perPage + perPage > totalCards ? totalCards : (currentPage - 1)*perPage + perPage"></span>
										of
										<span class="font-medium" x-text="totalCards"></span>
										results
									</p>
								</div>
								<div>
									<div>
										<nav class="isolate inline-flex -space-x-px rounded-md shadow-sm" aria-label="Pagination">
											<a href="#" 
												 class="relative inline-flex items-center rounded-l-md px-2 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0" 
												 x-on:click.prevent="currentPage = Math.max(1, currentPage - 1)" x-bind:disabled="currentPage === 1">
												<span class="sr-only">Previous</span>
												<svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
												<path fill-rule="evenodd" d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z" clip-rule="evenodd" />
												</svg>
											</a>
											<template x-for="pageNumber in 5">
												<a href="#" 
													 class="relative inline-flex items-center px-4 py-2 text-sm font-semibold ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0"
													 x-show="currentPage + pageNumber - 3 > 0 && currentPage + pageNumber - 3 <= lastPage"
													 x-on:click.prevent="currentPage = currentPage + pageNumber - 3"
													 x-bind:class="{ 'bg-indigo-600 text-white hover:bg-indigo-600 focus:outline-none focus:ring': currentPage === currentPage + pageNumber - 3, 'text-gray-900': currentPage !== currentPage + pageNumber - 3 }">
													<span x-text="currentPage + pageNumber - 3"></span>
												</a>
											</template>
											<a href="#" 
												 class="relative inline-flex items-center rounded-r-md px-2 py-2 text-gray-400 ring-1 ring-inset ring-gray-300 hover:bg-gray-50 focus:z-20 focus:outline-offset-0"
												 x-on:click.prevent="currentPage = Math.min(lastPage, currentPage + 1)"
												 x-bind:disabled="currentPage === lastPage">
												<span class="sr-only">Next</span>
												<svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
												<path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
												</svg>
											</a>
										</nav>
									</div>

								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

		<jsp:include page="../WEB-INF/jspf/footer.jsp" flush="true"/>
		<jsp:include page="../WEB-INF/jspf/notification.jsp" flush="true"/>

		<script>
			document.addEventListener("alpine:init", () => {
				let totalCards = ${deck.cardCount};
				let perPage = ${not empty param.perPage ? param.perPage : 5};
				let currentPage = ${not empty param.page ? param.page : 1}
				let lastPage = Math.ceil(totalCards / perPage);

				Alpine.data('cardsList', () => ({
						totalCards,
						perPage,
						lastPage,
						currentPage,
						cards: ${pageScope.cardsJson}
					}));
			});
		</script>
	</body>
</html>

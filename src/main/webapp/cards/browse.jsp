<%@page import="com.prj.assignment301.javabean.BrowseBean"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.prj.assignment301.utils.Constants"%>
<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%

	if (request.getAttribute("browse") == null && request.getRequestURI().endsWith(".jsp")) {
		String requestedUrl = request.getRequestURI() + "?" + request.getQueryString();
// Remove the '.jsp' part from the URL using a regex
		requestedUrl = requestedUrl.replaceAll("\\.jsp([?&].*)?$", "$1");
// Send the client to the modified URL
		response.sendRedirect(requestedUrl);
	}
	Gson gson = new Gson();
	String cards = gson.toJson(((BrowseBean) request.getAttribute("browse")).getCards());
	pageContext.setAttribute("cardsJson", cards);

	pageContext.setAttribute("deckDetailsPath", request.getContextPath() + AppPaths.DECK_DETAILS + "?id=");
	pageContext.setAttribute("editCardPath", request.getContextPath() + AppPaths.EDIT_CARD + "?id=");
	pageContext.setAttribute("searchPath", request.getContextPath() + AppPaths.BROWSE);
%>

<jsp:useBean id="browse" class="com.prj.assignment301.javabean.BrowseBean" scope="request" />

<!DOCTYPE html>
<html>
	<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>FlashWord - Browse</title>
		<tag:head alpine="true" icon="true" cssPath="/assets/css/index.css" contextPath="${pageContext.request.contextPath}" />
	</head>
	<body>
		<jsp:include page="../WEB-INF/jspf/navbar.jsp" flush="true"/>

		<div class="container py-8 md:py-12 px-6 mx-auto flex-1" x-data="browse">
			<main class="max-w-5xl mx-auto p-6 pt-0">
				<form action="${pageScope.searchPath}" method="GET">
					<div class="flex justify-center">
						<div class="relative">
							<input type="text" 
										 class="w-96 max-w-full border-gray-300 rounded-full py-2 px-4 leading-tight pl-12 border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600" 
										 placeholder="Search cards (type text, then press Enter)" 
										 name="search"
										 value="${param.search}"
										 >
							<button class="absolute inset-y-0 left-0 flex items-center pl-4" type="submit" title="Search">
								<i class="fa-solid fa-magnifying-glass"></i>
							</button>
						</div>
					</div>
					<div class="flex items-center justify-center gap-4 mt-2">
						<div class="inline-flex gap-2">
							<input type="radio" id="cardname" value="cardname" name="searchBy" x-bind:checked="searchBy === 'cardname'" />
							<label for="cardname">Card name</label>
						</div>
						<div class="inline-flex gap-2">
							<input type="radio" id="tagname" value="tagname" name="searchBy" x-bind:checked="searchBy === 'tagname'" />
							<label for="tagname">Tag name</label>
						</div>
						<div class="inline-flex gap-2">
							<input type="radio" id="deckname" value="deckname" name="searchBy" x-bind:checked="searchBy === 'deckname'" />
							<label for="deckname">Deck name</label>
						</div>
					</div>
				</form>

				<div class="border mt-4 mb-8"></div>

				<div x-data="cardsList" 
						 x-init="$watch('currentPage', (value) => window.location.href = '${pageScope.searchPath}?search=' + search + '&searchBy=' + searchBy + '&page=' + currentPage + '&perPage=' + perPage)">
					<div class="flex justify-between items-center flex-wrap">
						<p class="text-xl font-bold text-gray-800 mb-2 pr-4 truncate" title="Deck name">${browse.totalCards} cards found:</p>
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
												<th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Deck</th>
												<th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tags</th>
											</tr>
										</thead>
										<!-- Table row -->
										<tbody class="bg-white divide-y divide-gray-200">
										<template x-for="(item, index) in cards" x-bind:key="index">
											<tr class="hover:bg-gray-200">
												<td class="px-6 py-4 whitespace-nowrap" x-text="(currentPage - 1)*perPage + 1 + index"></td>
												<td class="px-6 py-4 whitespace-nowrap max-w-[150px] truncate md:hover:overflow-visible md:hover:whitespace-normal">
													<a x-bind:href="'${pageScope.editCardPath}' + item.cardId" 
														 class="transition hover:text-indigo-600" 
														 title="Edit card"
														 x-html="searchBy === 'cardname' ? highlight(item.front) : item.front"></a>
												</td>
												<td class="px-6 py-4 whitespace-nowrap max-w-[150px] truncate md:hover:overflow-visible md:hover:whitespace-normal">
													<a x-bind:href="'${pageScope.editCardPath}' + item.cardId" 
														 class="transition hover:text-indigo-600" 
														 title="Edit card"
														 x-html="searchBy === 'cardname' ? highlight(item.back) : item.back"></a>
												</td>
												<td class="px-6 py-4 whitespace-nowrap max-w-[150px] truncate md:hover:overflow-visible md:hover:whitespace-normal">
													<a x-bind:href="'${pageScope.deckDetailsPath}' + item.deckId" 
														 class="transition hover:text-indigo-600" 
														 title="Edit card"
														 x-html="searchBy === 'deckname' ? highlight(item.deckName) : item.deckName"></a>
												</td>
												<td class="px-6 py-4 whitespace-nowrap max-w-[150px] truncate md:hover:overflow-visible md:hover:whitespace-normal" 
														x-html="searchBy === 'tagname' ? highlight(item.tags) : item.tags"></td>
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
									<span class="font-medium" 
												x-text="(currentPage - 1)*perPage + perPage > totalCards ? totalCards : (currentPage - 1)*perPage + perPage"></span>
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
			</main>
		</div>

		<jsp:include page="../WEB-INF/jspf/footer.jsp" flush="true"/>
		<jsp:include page="../WEB-INF/jspf/notification.jsp" flush="true"/>

    <script>
			document.addEventListener("alpine:init", () => {
				function highlight(text) {
					if (!text || !this.search.trim())
						return text;
					const p = this.search.trim().replace(/[-/\\^$*+?.()|[\]{}]/g, '\\$&');
					const re = new RegExp(`(${"${"}p})`, 'gi');
					return text.replace(re, '<span class="bg-yellow-200">$1</span>');
				}

				let totalCards = ${browse.totalCards};
				let perPage = ${not empty param.perPage ? param.perPage : 10};
				let currentPage = ${not empty param.page ? param.page : 1}
				let lastPage = Math.ceil(totalCards / perPage);

				Alpine.data("browse", () => ({
						totalCards,
						perPage,
						lastPage,
						currentPage,
						cards: ${pageScope.cardsJson},
						search: '${param.search}',
						searchBy: "${not empty param.searchBy ? param.searchBy : 'cardname'}",
						highlight
					}));
			});
    </script>
	</body>
</html>

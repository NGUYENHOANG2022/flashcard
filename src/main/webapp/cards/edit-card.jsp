<%-- 
    Document   : edit-card
    Created on : Mar 12, 2023, 6:35:42 PM
    Author     : Hieu
--%>

<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	if (request.getAttribute("cardInfo") == null) {
		RequestDispatcher rd = request.getRequestDispatcher(AppPaths.NOT_FOUND_JSP);
		rd.forward(request, response);
	}
	pageContext.setAttribute("deleteCardPath", request.getContextPath() + AppPaths.DELETE_CARD);
	pageContext.setAttribute("editCardPath", request.getContextPath() + AppPaths.EDIT_CARD);
	pageContext.setAttribute("deckDetailsPath", request.getContextPath() + AppPaths.DECK_DETAILS);
	pageContext.setAttribute("card", request.getAttribute("cardInfo"));
%>

<!DOCTYPE html>
<html>
	<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>FlashCard - Edit card</title>
		<tag:head alpine="true" icon="true" cssPath="/assets/css/index.css" contextPath="${pageContext.request.contextPath}" />
	</head>
	<body>
		<jsp:include page="../WEB-INF/jspf/navbar.jsp" flush="true"/>

		<div class="container py-8 md:py-12 px-6 mx-auto flex-1">
			<main class="max-w-xl mx-auto p-6 bg-white rounded-lg shadow-md">
				<h2 class="text-2xl font-bold mb-4 text-center">Edit card</h2>
				<form class="space-y-4" action="${pageScope.editCardPath}" method="POST" x-data="editCard">
					<input id="cardId" name="cardId" required hidden value="${pageScope.card.cardId}" />
					<input id="deckId" name="deckId" required hidden value="${pageScope.card.deckId}" />
					<input id="deckName" name="deckName" required hidden value="${pageScope.card.deckName}" />
					<input id="privateDeck" name="privateDeck" required hidden value="${pageScope.card.privateDeck}" />
					<input name="tags" hidden value="${pageScope.card.tags}" x-bind:value="tags.join(',')" />
					<div class="flex items-center gap-4 mb-4">
						<label class="block text-gray-700 font-bold mb-2" for="spanId">Deck: </label>
						<div class="w-48">
							<span id="spanId" class="block truncate appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 select-none read-only:bg-gray-100">${pageScope.card.deckName} (${pageScope.card.privateDeck == 0 ? "Public" : "Private"})</span>
						</div>
					</div>
					<div class="mb-4">
						<label class="block text-gray-700 font-bold mb-2" for="card-front">
							Front:
						</label>
						<textarea 
							id="card-front"
							name="card-front"
							rows="4"
							cols="50"
							placeholder="Enter something for the front of your card"
							required
							class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600">${pageScope.card.front}</textarea>
					</div>

					<div class="mb-4">
						<label class="block text-gray-700 font-bold mb-2" for="card-back">
							Back:
						</label>
						<textarea 
							id="card-back"
							name="card-back"
							rows="4"
							cols="50"
							placeholder="Enter something for the back of your card"
							required
							class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600">${pageScope.card.back}</textarea>
					</div>
					<div class="mb-4">
						<label class="block text-gray-700 font-bold mb-2" for="tagsInput">
							Tags:
						</label>
						<div class="flex flex-wrap gap-2 border rounded p-2 ring-1 ring-inset ring-gray-300 border-0 outline-0">
							<template x-for="(tag, index) in tags" x-bind:key="index">
								<div class="bg-blue-400 rounded-full py-1 px-3 flex items-center">
									<span class="text-white text-sm mr-2" x-text="tag"></span>
									<button type="button" class="focus:outline-none" @click="tags.splice(index, 1)">x</button>
								</div>
							</template>
							<input 
								type="text" 
								id="tagsInput"
								class="bg-transparent focus:outline-none flex-grow" 
								placeholder="Type in your tag, then press Enter" 
								@keydown.enter.prevent="if(!tags.includes(tagInput.trim())){ tags.push(tagInput.trim()) } tagInput = ''" 
								x-model="tagInput"/>
						</div>
					</div>

					<div class="flex justify-end items-center gap-x-6">
						<button type="button"
										@click="deleteCard" 
										class="font-bold text-indigo-600 hover:text-indigo-500 hover:underline hover:underline-offset-2">
							Delete this card
						</button>
						<button class="bg-indigo-600 hover:bg-indigo-500 text-white font-bold py-2 px-4 rounded focus:shadow-outline" type="submit">
							Save changes
						</button>
					</div> 
				</form>
			</main>
		</div>

		<jsp:include page="../WEB-INF/jspf/footer.jsp" flush="true"/>
		<jsp:include page="../WEB-INF/jspf/notification.jsp" flush="true"/>

		<script>
			function deleteCard() {
				if (!confirm("Are you sure? Want to delete this card?")) {
					return;
				}
				fetch("${pageScope.deleteCardPath}?id=${pageScope.card.cardId}", {
							method: 'GET'
						}).then(response => response.json()).then(data => {
							console.log(data);
							window.location.href = "${pageScope.deckDetailsPath}?id=${pageScope.card.deckId}&success=Card removed successfully";
						}).catch(error => {
							console.error(error);
							this.$store.noti.notifications.push({
								title: "Error",
								message: "Something went wrong!",
								type: "error",
								show: true
							});
						});
					}

					function stringToArray(str) {
						if (!str || str.trim() === '') {
							return []; // if string is empty, return an empty array
						} else {
							return str.split(','); // otherwise, split the string by commas
						}
					}

					document.addEventListener('alpine:init', () => {
						Alpine.data("editCard", () => ({
								tags: stringToArray("${pageScope.card.tags}"),
								tagInput: "",
								deleteCard
							}));
					});
		</script>
	</body>
</html>

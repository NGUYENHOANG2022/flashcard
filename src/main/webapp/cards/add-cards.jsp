<%-- 
    Document   : add-cards
    Created on : Mar 11, 2023, 9:54:16 PM
    Author     : Hieu
--%>

<%@page import="com.prj.assignment301.utils.AppPaths"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>

<%
	pageContext.setAttribute("createDeckPath", request.getContextPath() + AppPaths.CREATE_DECK);
	pageContext.setAttribute("addCardsPath", request.getContextPath() + AppPaths.ADD_CARDS);
	pageContext.setAttribute("deleteCardPath", request.getContextPath() + AppPaths.DELETE_CARD);
	pageContext.setAttribute("editCardPath", request.getContextPath() + AppPaths.EDIT_CARD);
%>

<!DOCTYPE html>
<html>
	<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>FlashCard - Add cards</title>
		<tag:head alpine="true" icon="true" cssPath="/assets/css/index.css" contextPath="${pageContext.request.contextPath}" />
	</head>
	<body>
		<jsp:include page="../WEB-INF/jspf/navbar.jsp" flush="true"/>
		<div class="container py-8 md:py-12 px-6 mx-auto flex-1">
			<main class="max-w-5xl mx-auto p-6 bg-white rounded-lg shadow-md">
				<h2 class="text-2xl font-bold mb-4 text-center">Add cards</h2>
				<form class="grid grid-cols-6 gap-4" 
							action="${pageScope.addCardsPath}"
							@submit.prevent="submitForm" 
							x-data="addCards">
					<div class="col-span-6 flex items-center gap-4">
						<label class="block text-gray-700 font-bold" for="deckId">Deck: </label>
						<div class="relative w-48">
							<select 
								id="deckId"
								name="deckId"
								class="block truncate appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600">
								<c:forEach var="d" items="${requestScope.decksInfo}">
									<option value="${d.deckId}" x-bind:selected="${d.deckId == param.deckId}">${d.name} (${d.privateDeck == 0 ? "Public" : "Private"})</option>
								</c:forEach>
							</select>
							<div class="absolute inset-y-0 right-0 flex items-center px-2 pointer-events-none">
								<svg class="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M14.95 7.95l-3.97 3.97-3.97-3.97a.75.75 0 0 0-1.06 1.06l4.25 4.25a.75.75 0 0 0 1.06 0l4.25-4.25a.75.75 0 0 0-1.06-1.06z"/></svg>
							</div>
						</div>
						<a href="${pageScope.createDeckPath}" class="text-indigo-600 font-semibold hover:text-indigo-500 hover:underline hover:underline-offset-2">Create new deck</a>
					</div>
					<div class="col-span-6 md:col-span-4 md:pr-4">
						<div class="mb-4">
							<label class="block text-gray-700 font-bold mb-2" for="card-front">
								Front:
							</label>
							<textarea class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
												id="card-front"
												name="card-front"
												rows="4"
												cols="50"
												placeholder="Enter something for the front of your card"
												required
												x-model="frontText"
												></textarea>
						</div>

						<div class="mb-4">
							<label class="block text-gray-700 font-bold mb-2" for="card-back">
								Back:
							</label>
							<textarea class="appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 focus:ring-1 focus:ring-inset focus:ring-indigo-600"
												id="card-back"
												name="card-back"
												rows="4"
												cols="50"
												placeholder="Enter something for the back of your card"
												required
												x-model="backText"
												></textarea>
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
								<input type="text" 
											 id="tagsInput"
											 class="bg-transparent focus:outline-none flex-grow" 
											 placeholder="Type in your tag, then press Enter" 
											 @keydown.enter.prevent="if(!tags.includes(tagInput.trim())){ tags.push(tagInput.trim()) } tagInput = ''" 
											 x-model="tagInput">
							</div>
						</div>

						<div class="flex justify-end items-center gap-x-6">
							<button
								class="bg-indigo-600 hover:bg-indigo-500 text-white font-bold py-2 px-4 rounded focus:shadow-outline"
								x-bind:class="{ 'cursor-wait': isLoading }"
								x-bind:disabled="isLoading"
								x-text="isLoading ? 'Loading...' : 'Add card'"
								type="submit">
							</button>
						</div> 
					</div>
					<div class="col-span-6 md:col-span-2 md:pl-8 md:border-l-2 md:border-gray-300">
						<span class="block text-gray-700 font-bold mb-2">
							Added cards:
						</span>
						<div class="border rounded w-full py-2 px-3 text-gray-700 leading-tight border-0 ring-1 ring-inset ring-gray-300 outline-0 max-h-96 overflow-y-auto">

							<template x-for="(card, index) in addedCards" x-bind:key="index">
								<div x-transition:enter="transform ease-out duration-300 transition"
										 x-transition:enter-start="translate-y-2 opacity-0 sm:translate-y-0 sm:translate-x-2"
										 x-transition:enter-end="translate-y-0 opacity-100 sm:translate-x-0"
										 x-transition:leave="transition ease-in duration-100"
										 x-transition:leave-start="opacity-100"
										 x-transition:leave-end="opacity-0"
										 class="font-semibold rounded-lg p-1 mb-2 flex items-center border-0 ring-1 ring-inset ring-gray-300 outline-0 hover:ring-1 hover:ring-inset hover:ring-indigo-600"
										 <div class="flex items-center">
										<button type="button" 
														@click="deleteCard(card.cardId, index)" 
														x-data="{ isRemoving: false}"
														class="text-lg px-2 border-r-2 border-gray-300 hover:font-bold"
														x-bind:class="{ 'cursor-wait': isRemoving }"
														x-bind:disabled="isRemoving"
														>×</button>
										<a class="block pl-2 truncate hover:font-bold" x-bind:href="'${pageScope.editCardPath}?id='+card.cardId" x-text="card.front"></a>
									</div>
								</div>
							</template>

						</div>
					</div>
				</form>
			</main>
		</div>
		<jsp:include page="../WEB-INF/jspf/footer.jsp" flush="true"/>
		<jsp:include page="../WEB-INF/jspf/notification.jsp" flush="true"/>

		<script>
			function submitForm() {
				const formElement = this.$el;
				const formData = new FormData(formElement);
				const url = formElement.action;
				formData.append("tags", this.tags.join(','));

				// show the loading state
				this.isLoading = true;

				let params = '';
				for (const pair of formData.entries()) {
					if (params.length > 0) {
						params += '&';
					}
					params += encodeURIComponent(pair[0]) + '=' + encodeURIComponent(pair[1]);
				}

				// send the request
				fetch(url, {
					method: 'POST',
					body: params,
					headers: {
						'Content-Type': 'application/x-www-form-urlencoded'
					}
				}).then(response => response.json()).then(data => {
					console.log(data);
					this.addedCards.push(data);
					this.frontText = "";
					this.backText = "";
					this.$store.noti.notifications.push({
						title: "Success",
						message: "Card added successfully",
						type: "success",
						show: true
					});

				}).catch(error => {
					console.error(error);
					this.$store.noti.notifications.push({
						title: "Error",
						message: "Something went wrong!",
						type: "error",
						show: true
					});
				}).finally(() => {
					// hide the loading state
					this.isLoading = false;
				});
			}

			function deleteCard(cardId, index) {
				if (!confirm("Are you sure? Want to delete this card?")) {
					return;
				}
				this.isRemoving = true;
				fetch("${pageScope.deleteCardPath}?id=" + cardId, {
					method: 'GET'
				}).then(response => response.json()).then(data => {
					console.log(data);
					this.addedCards.splice(index, 1);
					this.$store.noti.notifications.push({
						title: "Success",
						message: "Card removed successfully",
						type: "success",
						show: true
					});

				}).catch(error => {
					console.error(error);
					this.$store.noti.notifications.push({
						title: "Error",
						message: "Something went wrong!",
						type: "error",
						show: true
					});
				}).finally(() => {
					// hide the loading state
					this.isRemoving = false;
				});
			}

			document.addEventListener('alpine:init', () => {
				Alpine.data("addCards", () => ({
						isLoading: false,
						frontText: "",
						backText: "",
						addedCards: [],
						submitForm,
						deleteCard,
						tags: [],
						tagInput: ""
					}));
			});
		</script>
	</body>
</html>

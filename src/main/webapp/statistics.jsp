<%-- 
    Document   : statistics
    Created on : Apr 25, 2023, 12:19:22 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib tagdir="/WEB-INF/tags/" prefix="tag"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8"/>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
		<title>Flashcard - Statistics</title>
		<tag:head
			alpine="true"
			icon="true"
			cssPath="/assets/css/index.css"
			contextPath="${pageContext.request.contextPath}"
			/>
	</head>
	<body>
		<!-- Navbar -->
		<jsp:include page="/WEB-INF/jspf/navbar.jsp" flush="true"/>

		<!-- Statistics -->
		<div class="container py-8 md:py-12 px-6 mx-auto flex-1" x-data>
			<h2 class="text-3xl font-bold mb-4 text-center">Statistics</h2>
			<main class="max-w-5xl mx-auto p-6 bg-white rounded-lg shadow-md w-96 mb-4">
				<h3 class="text-2xl font-bold mb-4 text-center">Today</h3>
				<div class="col-span-6 border"></div>
				<p class="text-lg font-medium break-words text-center mt-4">You've studied ${requestScope.decksStudiesNum} decks today.</p>
			</main>
			<div class="max-w-5xl mx-auto p-6 bg-white rounded-lg shadow-md">
				<h3 class="text-2xl font-bold mb-4 text-center">Studies</h3>
				<div class="col-span-6 border mb-4"></div>
				<div id="chart-container" style="position: relative;height:40vh;">
					<canvas id="barChart"></canvas>
				</div>
			</div>
		</div>

		<!-- Footer -->
		<jsp:include page="/WEB-INF/jspf/footer.jsp" flush="true"/>
		<jsp:include page="/WEB-INF/jspf/notification.jsp" flush="true"/>

		<script src="assets/js/plugin/jquery.3.2.1.min.js"></script>
		<script src="assets/js/plugin/popper.min.js"></script>
		<script src="assets/js/plugin/chart.min.js"></script>
		<script src="assets/js/plugin/bootstrap.min.js"></script>
		<script>
			let barChart = document.getElementById('barChart').getContext('2d');
			let data = ${requestScope.chartData};
			console.log(data);

			let myBarChart = new Chart(barChart, {
				type: 'bar',
				data: {
					labels: data.map((d) => d.date),
					datasets: [{
							label: "Studied",
							backgroundColor: 'rgb(23, 125, 255)',
							borderColor: 'rgba(23, 125, 255, 0.5)',
							data: data.map((d) => d.studyCount)
						}]
				},
				options: {
					responsive: true,
					maintainAspectRatio: false,
					scales: {
						yAxes: [{
								ticks: {
									beginAtZero: true
								}
							}]
					}
				}
			});
		</script>
	</body>
</html>

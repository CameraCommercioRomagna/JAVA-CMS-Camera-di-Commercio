<!--
	input richiesti:
	List<DocumentoWeb<?>> video
 -->

<div class="card" style="margin-top:1rem;">
	<div class="card-title-block-right bg_footer bg_footer_text" style="padding:0.3rem">
		<span class="glyphicon glyphicon-facetime-video"></span> Video
	</div>
	<div class="card-body-block-right" >
		<div class="row">
		<%	for (DocumentoWeb<?> v: video){%>
				<div class="col-lg-3 col-md-4 col-xs-6" style="margin-top:0.5rem;">
					<div class="embed-responsive embed-responsive-16by9">
						<%if(v.getLink().contains("youtube")){%>
							<iframe class="embed-responsive-item" src="<%=v.getLink()%>" allowfullscreen></iframe>
						<%}else{%>
							<video controls class="embed-responsive-item">
								<source src="<%=v.getLink()%>" type="video/mp4">
							</video>
						<%}%>
					</div>
					
				</div>
		<%	}%>
		</div>
	</div>
</div>	
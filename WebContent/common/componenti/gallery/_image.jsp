<!--
	input richiesti:
	List<Immagine> immagini;*/
 -->

<div class="card" style="margin-top:1rem;">
	<div class="card-title-block-right bg_footer bg_footer_text" style="padding:0.3rem">
		<span class="glyphicon glyphicon-camera"></span> Immagini
	</div>
	<div class="card-body-block-right" >
		<div class="row">
		<%	for (Immagine i: immagini){%>
				<div class="col-lg-3 col-md-4 col-xs-6 thumb">
					<a class="thumbnail" href="#" data-image-id="" data-toggle="modal" data-title="" data-image="<%=i.getIcona()%>" data-target="#image-gallery">
						<img class="img-thumbnail" src="<%=i.getIcona()%>" alt="Another alt text">
					</a>
				</div>
				<div class="modal fade" id="image-gallery" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog modal-lg">
						<div class="modal-content">
							<div class="modal-header">
								<h4 class="modal-title" id="image-gallery-title"></h4>
								<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span>Close</span></button>
							</div>
							<div class="modal-body">
								<img id="image-gallery-image" class="img-responsive col-md-12" src="">
							</div>
							<div class="modal-footer">
								<%if(immagini.size()>1){%>
									<button type="button" class="btn btn-secondary float-left" id="show-previous-image"><span class="glyphicon glyphicon-chevron-left"></span></button>
									<button type="button" id="show-next-image" class="btn btn-secondary float-right"><span class="glyphicon glyphicon-chevron-right"></span></button>
								<%}%>
							</div>
						</div>
					</div>
				</div>
		<%	}%>
		</div>
	</div>
</div>	
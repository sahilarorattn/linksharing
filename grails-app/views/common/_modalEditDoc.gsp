<div class="modal fade" id="editDocTemplate" tabindex="-1" role="dialog"
     aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <!-- Modal Header -->
            <div class="modal-header">
                <button type="button" class="close"
                        data-dismiss="modal">
                    <span aria-hidden="true">&times;</span>
                    <span class="sr-only">Close</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">
                    Edit Document Post
                </h4>
            </div>

        <!-- Modal Body -->


            <g:uploadForm class="form-horizontal" role="form" controller="resource" action="editDoc"  id="editDoc" name="editDoc">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label"
                               for="document">Document</label>
                        <input type="hidden" name="resId" id="resId" value="${topicPostsDTO.resId}"/>
                        <div class="col-sm-10">
                            <input type="file" class="form-control"
                                   id="document" placeholder="Document" name="document"  value="${topicPostsDTO.filePath}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label"
                               for="descriptionDoc">Description</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control"
                                   id="descriptionDoc" placeholder="Description" name="descriptionDoc" value="${topicPostsDTO.desc}"/>
                        </div>
                    </div>
                </div>
                <!-- Modal Footer -->
                <div class="modal-footer">
                    <button class="btn btn-primary" id="editDocBtn" name="editDocBtn">
                        Save changes
                    </button>
                    <button class="btn btn-default"
                            data-dismiss="modal">
                        Close
                    </button>
                </div>
            </g:uploadForm>
        </div>
    </div>
</div>
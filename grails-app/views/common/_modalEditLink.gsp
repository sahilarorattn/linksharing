<div class="modal fade" id="editLinkTemplate" tabindex="-1" role="dialog"
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
                    Edit Link Post
                </h4>
            </div>

        <!-- Modal Body -->


            <g:uploadForm class="form-horizontal" role="form" controller="resource" action="editLink"  id="editLink" name="editLink">
                <div class="modal-body">
                    <div class="form-group">
                        <input type="hidden" name="resId" id="resId" value="${topicPostsDTO.resId}"/>
                        <label class="col-sm-2 control-label"
                               for="link">Link</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control"
                                   id="link" placeholder="Link" name="link" value="${topicPostsDTO.url}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label"
                               for="descriptionLink">Description</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control"
                                   id="descriptionLink" placeholder="Description" name="descriptionLink" value="${topicPostsDTO.desc}"/>
                        </div>
                    </div>
                </div>
                <!-- Modal Footer -->
                <div class="modal-footer">
                    <button class="btn btn-primary" id="saveDoc" name="saveDoc">
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
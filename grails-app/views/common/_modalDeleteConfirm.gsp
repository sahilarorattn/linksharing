<div class="modal fade" id="deleteConfirm" tabindex="-1" role="dialog"
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
                    Delete Document
                </h4>
            </div>

        <!-- Modal Body -->


            <g:uploadForm class="form-horizontal" role="form" controller="topic" action="deleteTopic"  id="deleteTopic" name="deleteTopic">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-6 control-label"
                               >Are you sure to delete this topic?</label>
                        <input type="hidden" name="topicId" id="topicId"/>
                    </div>
                </div>
                <!-- Modal Footer -->
                <div class="modal-footer">
                    <button class="btn btn-primary" id="deleteTopic" name="deleteTopic">
                        Delete
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
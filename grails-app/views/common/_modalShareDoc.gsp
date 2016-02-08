<div class="modal fade" id="shareDocTemplate" tabindex="-1" role="dialog"
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
                    Create Document
                </h4>
            </div>

            <!-- Modal Body -->


                <g:uploadForm class="form-horizontal" role="form" controller="resource" action="createDocument"  id="createDocument" name="createDocument">
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="col-sm-2 control-label"
                                   for="document">Document</label>
                            <div class="col-sm-10">
                                <input type="file" class="form-control"
                                       id="document" placeholder="Document" name="document"/>
                            </div>
                        </div>
                        <div class="form-group">
                        <label class="col-sm-2 control-label"
                                for="description">Description</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control"
                                   id="description" placeholder="Description" name="description"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label"
                               for="topicSub" >Topic</label>
                        <div class="col-sm-10">
                            <g:select class="form-control" optionValue="value" optionKey="key"
                                   id="topicSub" placeholder="topics" from="${homeDTO.topicSub}" name="topicSub" ></g:select>
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
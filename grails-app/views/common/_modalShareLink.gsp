<div class="modal fade" id="shareLinkTemplate" tabindex="-1" role="dialog"
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
                    Share Link
                </h4>
            </div>

            <!-- Modal Body -->


                <g:form class="form-horizontal" role="form" controller="resource" action="createLink"  id="createLink" name="createLink">
                    <div class="modal-body">
                        <div class="form-group">
                            <label class="col-sm-2 control-label"
                                   for="link">Link</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control"
                                       id="link" placeholder="Link" name="link"/>
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
                        <button class="btn btn-primary" id="saveLink" name="saveLink">
                            Save changes
                        </button>
                        <button class="btn btn-default"
                                data-dismiss="modal">
                            Close
                        </button>
                    </div>
                </g:form>
        </div>
    </div>
</div>
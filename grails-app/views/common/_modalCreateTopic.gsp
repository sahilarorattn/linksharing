<div class="modal fade" id="createTopicTemplate" tabindex="-1" role="dialog"
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
                    Create Topic
                </h4>
            </div>

            <!-- Modal Body -->


                <g:form class="form-horizontal" role="form" controller="topic" action="createTopic"  id="createTopic" name="createTopic">
                    <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label"
                                for="topicName">Name</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control"
                                   id="topicName" placeholder="Topic Name" name="topicName"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label"
                               for="visibility" >Visibility</label>
                        <div class="col-sm-10">
                            <g:select class="form-control"
                                   id="visibility" placeholder="Visibility" from="${homeDTO.visibility}" name="visibility" ></g:select>
                        </div>
                    </div>
                    </div>
                    <!-- Modal Footer -->
                    <div class="modal-footer">
                        <button class="btn btn-primary" id="saveCreateTopic" name="saveCreateTopic">
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
<div class="modal fade" id="sendInvitationTemplate" tabindex="-1" role="dialog"
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
                    Send Invite
                </h4>
            </div>

            <!-- Modal Body -->


                <g:form class="form-horizontal" role="form" controller="topic" action="sendInvitation"  id="sendInvitation" name="sendInvitation">
                    <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label"
                                for="emailUser">Email</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control"
                                   id="emailUser" placeholder="Email" name="emailUser"/>
                        </div>
                    </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label"
                                   for="topicInv" >Topic</label>
                            <div class="col-sm-10">
                                <g:select class="form-control" optionValue="value" optionKey="key"
                                          id="topicInv" placeholder="topics" from="${homeDTO.topicSub}" name="topicInv" ></g:select>
                            </div>
                        </div>
                    </div>
                    <!-- Modal Footer -->
                    <div class="modal-footer">
                        <button class="btn btn-primary" id="sendInvite" name="sendInvite">
                            Invite
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
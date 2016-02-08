<div id="listTemplateDivId">
    <g:each in="${viewAllList}" var="subTopicDTO" status="i">

        <div class="subscriptions">
            <div class="userImage">
                <a href="/home/showUser?userId=${subTopicDTO.createdUserId}">
                <g:if test="${subTopicDTO.photo}">
                    <img src="/LinkSharing_Images/${subTopicDTO.photo}">
                </g:if>
                <g:else>
                    <asset:image src="user.jpeg"/>
                </g:else>
                    </a>
            </div>

            <div class="userData">
                <span id="subTopicNameSpan${subTopicDTO.topicId}"
                      name="subTopicNameSpan${subTopicDTO.topicId}" class="subTopicNameSpan">
                    <a href="#" id="tName${subTopicDTO.topicId}" class="tName"
                       name="tName${subTopicDTO.topicId}">${subTopicDTO.topicName}</a>
                    <input
                            type="hidden"
                            value="${subTopicDTO.topicName}"
                            id="hidSubTopName${subTopicDTO.topicId}"
                            name="hidSubTopName${subTopicDTO.topicId}"/>
                </span>
                <table class="greyText" width="100%">
                    <tr>
                        <td>
                            @${subTopicDTO.createdUserName}
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            Subscriptions
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            Posts
                        </td>
                    </tr>
                    <tr>
                        <td>
                            %{--<g:if test="${homeDTO.userId != subTopicDTO.createdUserId}">--}%
                                %{--<a href="/topic/unsubscribeTopic?topicId=${subTopicDTO.topicId}">Unsubscribe</a>--}%
                            %{--</g:if>--}%

                            <g:if test="${homeDTO.userId != subTopicDTO.createdUserId}">
                                <g:if test="${subTopicDTO.subscribed}">
                                    <a href="/topic/unsubscribeTopic?topicId=${subTopicDTO.topicId}">Unsubscribe</a>
                                </g:if>
                                <g:else>
                                    <a href="/topic/subscribeTopic?topicId=${subTopicDTO.topicId}" class="subSubAnc">Subscribe</a>
                                </g:else>
                            </g:if>
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            ${subTopicDTO.topicSubsCount}
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            ${subTopicDTO.topicPostsCount}
                        </td>
                    </tr>
                </table>

            </div>

            <div class="modifications">
                <g:select name="seriousnessSub${subTopicDTO.topicId}" from="${homeDTO.seriousness}"
                          class="seriousnessSub"
                          value="${subTopicDTO.seriousness}"></g:select>
                <g:if test="${subTopicDTO.createdUserId == homeDTO.userId || homeDTO.admin}">
                    <g:select name="visibilitySub${subTopicDTO.topicId}" from="${homeDTO.visibility}"
                              class="visibilitySub"
                              value="${subTopicDTO.visibility}"></g:select>
                </g:if>
                <span style="float: right; padding-right: 20px;">
                    <g:if test="${subTopicDTO.createdUserId == homeDTO.userId || homeDTO.admin}">
                        <a href="" id="editSub${subTopicDTO.topicId}" name="editSub${subTopicDTO.topicId}"
                           class="editSub">
                            <div class="glyphicon glyphicon-edit"></div>
                        </a>
                        <a data-toggle="modal" data-id="${subTopicDTO.topicId}" title="Delete Topic"
                           class="deleteTopic" href="#deleteConfirm"><div
                                class="glyphicon glyphicon-trash"></div></a>
                    </g:if>
                <a href="#sendInvitationSingleTemplate" data-toggle="modal" data-tid="${subTopicDTO.topicId}" data-tname="${subTopicDTO.topicName}"><div class="glyphicon glyphicon-envelope sendInvite"></div></a>

                </span>

            </div>
        </div>
    </g:each>
    <div class="paginateButtons">

    <util:remotePaginate controller="topic" action="fetchTopicList" total="${count}" update="listTemplateDivId"
                         pageSizes="[10:'10 Per Page', 20: '20 Per Page', 50:'50 Per Page']"/>

    </div>
</div>
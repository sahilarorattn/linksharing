<div id="listTemplateDivId">

    <g:each in="${trendTopicDTOList}" var="trendTopicDTO" status="i">
        <div class="subscriptions" id="sub${trendTopicDTO.topicId}" name="sub${trendTopicDTO.topicId}">
            <div class="userImage">
                <a href="/home/showUser?userId=${homeDTO.userId}">
                <g:if test="${homeDTO.photo}">
                    <img src="/LinkSharing_Images/${homeDTO.photo}">
                </g:if>
                <g:else>
                    <asset:image src="user.jpeg"/>
                </g:else>
                    </a>
            </div>

            <div class="userData">

                <span id="trendTopicNameSpan${trendTopicDTO.topicId}"
                      name="trendTopicNameSpan${trendTopicDTO.topicId}" class="subTopicNameSpan">
                    <a href="/topic/showTopic?topicId=${trendTopicDTO.topicId}">${trendTopicDTO.topicName}</a><input
                        type="hidden"
                        value="${trendTopicDTO.topicName}"
                        id="hidTrendTopName${trendTopicDTO.topicId}"
                        name="hidTrendTopName${trendTopicDTO.topicId}"/>
                </span>
                <table class="greyText" width="100%">
                    <tr>
                        <td>
                            @${trendTopicDTO.createdUserName}
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            Subscriptions
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            Topics
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <g:if test="${homeDTO.userId != trendTopicDTO.createdUserId}">
                                <g:if test="${trendTopicDTO.subscribed}">
                                    <a href="/topic/unsubscribeTopic?topicId=${trendTopicDTO.topicId}">Unsubscribe</a>
                                </g:if>
                                <g:else>
                                    <a href="/topic/subscribeTopic?topicId=${trendTopicDTO.topicId}">Subscribe</a>
                                </g:else>
                            </g:if>

                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            ${trendTopicDTO.topicSubsCount}
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            ${trendTopicDTO.topicPostsCount}
                        </td>
                    </tr>
                </table>

            </div>

            <div class="modifications">

                <g:select name="seriousnessTrend${trendTopicDTO.topicId}" from="${homeDTO.seriousness}"
                          class="seriousnessTrend"
                          value="${trendTopicDTO.seriousness}"></g:select>

                <g:if test="${trendTopicDTO.createdUserId == homeDTO.userId || homeDTO.admin}">
                    <g:select name="visibilityTrend${trendTopicDTO.topicId}" from="${homeDTO.visibility}"
                              class="visibilityTrend"
                              value="${trendTopicDTO.visibility}"></g:select>
                </g:if>
                <span style="float: right; padding-right: 20px;">

                    <g:if test="${trendTopicDTO.createdUserId == homeDTO.userId || homeDTO.admin}">
                        <a href="" id="editTrend${trendTopicDTO.topicId}"
                           name="editTrend${trendTopicDTO.topicId}"
                           class="editTrend">
                            <div class="glyphicon glyphicon-edit"></div>
                        </a>
                        <a data-toggle="modal" data-id="${trendTopicDTO.topicId}" title="Delete Topic"
                           class="deleteTopic" href="#deleteConfirm"><div
                                class="glyphicon glyphicon-trash"></div></a>
                    </g:if>
                <a href="#sendInvitationSingleTemplate" data-toggle="modal" data-tid="${trendTopicDTO.topicId}" data-tname="${trendTopicDTO.topicName}"><div class="glyphicon glyphicon-envelope sendInvite"></div></a>
                </span>
            </div>
        </div>
    </g:each>
    <div class="paginateButtons">
        <util:remotePaginate controller="home" action="showPaginatedEditProfile" total="${count}" update="listTemplateDivId"
                             pageSizes="[10: '10 Per Page', 20: '20 Per Page', 50: '50 Per Page']"/>

    </div>
</div>
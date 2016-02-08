<div id="listTemplateDivId2">
    <g:each in="${topicPostsDTOList}" var="topicPostsDTO" status="i">
        <div class="subscriptions">
            <div class="userImage">
                <a href="/home/showUser?userId=${topicPostsDTO.createdUserId}">
                    <g:if test="${topicPostsDTO.photo}">
                        <img src="/LinkSharing_Images/${topicPostsDTO.photo}">
                    </g:if>
                    <g:else>
                        <asset:image src="user.jpeg"/>
                    </g:else>
                </a>
            </div>

            <div class="userData">

                <div class="greyText" width="100%">
                    <div><a href="/topic/showTopic?topicId=${topicPostsDTO.topicId}">${topicPostsDTO.topicName}</a></div>

                    <div style="word-wrap: break-word">${topicPostsDTO.desc}</div>
                </div>

            </div>

            <div class="modifications">
                <div class="leftA">
                    <a href="#"><div class="glyphicon"><img style="width:13px; height: 13px;"
                                                            src="/images/facebook.png"></div></a>
                    <a href="#"><div class="glyphicon"><img style="width:13px; height: 13px;" src="/images/twitter.png">
                    </div></a>
                    <a href="#"><div class="glyphicon"><img style="width:13px; height: 13px;"
                                                            src="/images/googlePlus.png"></div></a>
                </div>

                <div class="rightA">
                    <g:if test="${topicPostsDTO.type.contains('DocumentResource')}">
                        <a target="_blank" href="/LinkSharing_Docs/${topicPostsDTO.filePath}">Download</a>
                    </g:if>
                    <g:else>
                        <a target="_blank" href="${topicPostsDTO.url}">View full site</a>
                    </g:else>
        <g:if test="${homeDTO}">
                    <g:if test="${topicPostsDTO.read}">
                        <a href="/home/markAsRead?resourceId=${topicPostsDTO.resId}&read=false">Mark as Unread</a>
                    </g:if>
                    <g:else>
                        <a href="/home/markAsRead?resourceId=${topicPostsDTO.resId}&read=true">Mark as read</a>
                    </g:else>
        </g:if>
                    <a href="/resource/viewPost?resourceId=${topicPostsDTO.resId}">View Post</a>
                </div>
            </div>

        </div>
    </g:each>
    <div class="paginateButtons">

        <util:remotePaginate controller="home" action="fetchAllPosts" total="${countPosts}" update="listTemplateDivId2"
                             id="${usersDTO.userId}"
                             pageSizes="[10: '10 Per Page', 20: '20 Per Page', 50: '50 Per Page']"/>

    </div>
</div>
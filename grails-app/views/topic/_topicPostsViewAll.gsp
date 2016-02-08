<div class="login img-rounded">
<g:if test="${topicPostsDTOList.size()>0}">
    <div class="modal-header lead">
        Posts: "${subTopicDTO.topicName}"
    </div>
    <g:render template="topicPostsViewAllDiv" model="[topicPostsDTOList:topicPostsDTOList]"></g:render>
</g:if>
    <g:else>
        <div class="modal-header lead">
            Posts: "${subTopicDTO.topicName}" :No posts available
        </div>

    </g:else>
</div>
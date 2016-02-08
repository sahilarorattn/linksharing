<%--
  Created by IntelliJ IDEA.
  User: ttnd
  Date: 24/1/16
  Time: 4:13 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="signedIn">
    <title>Link Sharing</title>

</head>

<body>

<div class="bodyClass">
    <div class="leftSmall">
        <div class="recentShares img-rounded">
            <div class="modal-header lead">
                Topic: "${subTopicDTO.topicName}"
            </div>

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
                        <a href="/topic/showTopic?topicId=${subTopicDTO.topicId}">${subTopicDTO.topicName}</a><input
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
                                <g:if test="${homeDTO}">
                                    <g:if test="${!subTopicDTO.subscribed}">
                                        <a href="/topic/subscribeTopic?topicId=${subTopicDTO.topicId}"
                                           class="subSubAnc">Subscribe</a>
                                    </g:if>
                                    <g:else>
                                        <a href="/topic/unsubscribeTopic?topicId=${subTopicDTO.topicId}">Unsubscribe</a>
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
                    <g:if test="${homeDTO}">
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
                    </g:if>
                </div>
            </div>

        </div>

        <div class="topPosts img-rounded">
            <div class="modal-header lead">
                Users: "${subTopicDTO.topicName}"
            </div>
            <g:each in="${usersDTOList}" var="userDTO" status="i">
                <div class="subscriptions">
                    <div class="userImage">
                        <a href="/home/showUser?userId=${userDTO.userId}">
                            <g:if test="${userDTO.photo}">
                                <img src="/LinkSharing_Images/${userDTO.photo}">
                            </g:if>
                            <g:else>
                                <asset:image src="user.jpeg"/>
                            </g:else>
                        </a>
                    </div>

                    <div class="userData">
                        <lead class="large">${userDTO.firstName + " " + userDTO.lastName}</lead>

                        <p class="greyText">@${userDTO.userName}</p>
                        <table class="greyText" width="100%">
                            <tr>
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
                                    ${userDTO.countSubcriptions}
                                </td>
                                <td>&nbsp;&nbsp;&nbsp;</td>
                                <td>
                                    ${userDTO.countTopics}
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </g:each>

        </div>

    </div>

    <div class="rightLarge">
        <div class="login img-rounded">
            <div class="modal-header lead">
                Posts: "${subTopicDTO.topicName}"
            </div>
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
                            <p></p>

                            <div style="word-wrap: break-word">${topicPostsDTO.desc}</div>
                        </div>

                    </div>

                    <div class="modifications">
                        <div class="leftA">
                            <g:if test="${homeDTO}">
                                <a href="#"><div class="glyphicon"><img style="width:13px; height: 13px;"
                                                                        src="/images/facebook.png"/></div></a>
                                <a href="#"><div class="glyphicon"><img style="width:13px; height: 13px;"
                                                                        src="/images/twitter.png"></div></a>
                                <a href="#"><div class="glyphicon"><img style="width:13px; height: 13px;"
                                                                        src="/images/googlePlus.png"></div></a>
                            </g:if>
                        </div>

                        <div class="rightA">
                            <g:if test="${topicPostsDTO.type.contains('DocumentResource')}">
                                <a target="_blank" href="/LinkSharing_Docs/${topicPostsDTO.filePath}">Download</a>
                            </g:if>
                            <g:else>
                                <a target="_blank" href="${topicPostsDTO.url}">View full site</a>
                            </g:else>
                            <g:if test="${subTopicDTO.subscribed}">
                                <g:if test="${topicPostsDTO.read}">
                                    <a href="/resource/markAsRead?resourceId=${topicPostsDTO.resId}&read=false&topicId=${subTopicDTO.topicId}">Mark as Unread</a>
                                </g:if>
                                <g:else>
                                    <a href="/resource/markAsRead?resourceId=${topicPostsDTO.resId}&read=true&topicId=${subTopicDTO.topicId}">Mark as read</a>
                                </g:else>
                            </g:if>
                            <a href="/resource/viewPost?resourceId=${topicPostsDTO.resId}">View Post</a>
                        </div>
                    </div>

                </div>
            </g:each>

        </div>

    </div>
</div>
</body>
</html>
<%--
  Created by IntelliJ IDEA.
  User: ttnd
  Date: 1/2/16
  Time: 1:02 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="signedIn">
    <title>Search Link Sharing</title>

</head>

<body>

<div class="bodyClass">
    <div class="leftSmall">
        <div class="recentShares img-rounded">
            <div class="modal-header lead ">
                Trending Topics
            </div>
            <g:each in="${trendTopicDTOList}" var="trendTopicDTO" status="i">
                <div class="subscriptions" id="sub${trendTopicDTO.topicId}" name="sub${trendTopicDTO.topicId}">
                    <div class="userImage">
                        <a href="/home/showUser?userId=${trendTopicDTO.createdUserId}">
                            <g:if test="${trendTopicDTO.photo}">
                                <img src="/LinkSharing_Images/${trendTopicDTO.photo}">
                            </g:if>
                            <g:else>
                                <asset:image src="user.jpeg"/>
                            </g:else></a>
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
                                    <g:if test="${homeDTO && homeDTO.userId != trendTopicDTO.createdUserId}">
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
                        <g:if test="${homeDTO}">
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
                                    <a href="/topic/deleteTopic?topicId=${trendTopicDTO.topicId}"><div
                                            class="glyphicon glyphicon-trash"></div></a>
                                </g:if>
                                <a href="#"><div class="glyphicon glyphicon-envelope"></div></a>
                            </span>
                        </g:if>
                    </div>
                </div>
            </g:each>

        </div>

        <div class="topPosts img-rounded">
            <div class="modal-header lead">
                Top Posts
            </div>
            <g:each in="${topPostsList}" var="topicPostsDTO" status="i">
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
                            <div><a href="/topic/showTopic?topicId=${topicPostsDTO.topicId}">${topicPostsDTO.topicName}</a>
                            </div>

                            <div style="word-wrap: break-word">${topicPostsDTO.desc}</div>
                        </div>

                    </div>

                    <div class="modifications">
                        <div class="leftA">
                <g:if test="${homeDTO}">
                            <a href="#"><div class="glyphicon"><img style="width:13px; height: 13px;"
                                                                    src="/images/facebook.png"></div></a>
                            <a href="#"><div class="glyphicon"><img style="width:13px; height: 13px;"
                                                                    src="/images/twitter.png">
                            </div></a>
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
                            <g:if test="${homeDTO && topicPostsDTO.isSubscribed}">
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

        </div>

    </div>

    <div class="rightLarge">

        <div class="login img-rounded">
            <div class="modal-header lead">
                Search for "${searchText}"
            </div>

            <g:render template="searchPosts" model="[searchPostsList: searchPostsList]"></g:render>

        </div>

    </div>

</div>
</div>
<g:javascript src="application.js"></g:javascript>
</body>
</html>
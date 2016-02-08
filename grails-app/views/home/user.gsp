<%--
  Created by IntelliJ IDEA.
  User: ttnd
  Date: 26/1/16
  Time: 4:33 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="signedIn">
    <title>User Profile</title>

</head>

<body>

<div class="bodyClass">
    <div class="leftSmall">
        <div class="recentShares img-rounded">
            <div class="modal-header lead">
                User <Profile></Profile>
            </div>
            <div class="userImage">
                <a href="/home/showUser?userId=${usersDTO.userId}">
                <g:if test="${usersDTO.photo}">
                    <img src="/LinkSharing_Images/${usersDTO.photo}">
                </g:if>
                <g:else>
                    <asset:image src="user.jpeg"/>
                </g:else>
                    </a>
            </div>

            <div class="userData">
                <lead class="large">${usersDTO.firstName+" "+usersDTO.lastName}</lead>

                <p class="greyText">@${usersDTO.userName}</p>
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
                            ${usersDTO.countSubcriptions}
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            ${usersDTO.countTopics}
                        </td>
                    </tr>
                </table>
            </div>

        </div>

        <div class="topPosts img-rounded">
            <div class="modal-header lead ">
                Topics
            </div>
            <g:render template="userTopics" model="[trendTopicDTOList:trendTopicDTOList]"></g:render>

        </div>
    </div>

    <div class="rightLarge">

        <div class="login img-rounded">
            <div class="modal-header lead">
                Posts
            </div>

            <g:render template="allPosts" model="[topicPostsDTOList:topicPostsDTOList]"></g:render>
        </div>
    </div>

</div>
</div>
<g:javascript src="application.js"></g:javascript>
</body>
</html>
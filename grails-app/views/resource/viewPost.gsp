<%--
  Created by IntelliJ IDEA.
  User: ttnd
  Date: 20/1/16
  Time: 4:44 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="signedIn">
    <title>Link Sharing</title>
    <asset:stylesheet src="star-rating.min.css"></asset:stylesheet>
    <asset:javascript src="star-rating.min.js"></asset:javascript>
    <style>
.glyphicon-minus-sign:before {
    content: ""!important;
}
</style>
</head>

<body>
<div class="bodyClass">
    <div class="left">
        <div class="recentShares img-rounded">
            <div class="modal-header lead">
                Post
            </div>

            <div class="userImage">
                <g:if test="${topicPostsDTO.photo}">
                    <img src="/LinkSharing_Images/${topicPostsDTO.photo}">
                </g:if>
                <g:else>
                    <asset:image src="user.jpeg"/>
                </g:else>
            </div>

            <div class="userData">
                <div style="overflow: auto;"><lead class="large">${topicPostsDTO.fullName}</lead>

                    <p style="float:right;"><a
                            href="/topic/showTopic?topicId=${topicPostsDTO.topicId}">${topicPostsDTO.topicName}</a></p>

                    <p class="greyText" style="float:left; clear: both;">@${topicPostsDTO.userName}</p>
                    <g:if test="${homeDTO}">
                        <div style="clear: both;float: left;">
                            <input id="input-id" type="number" class="rating" min=0 max=5 step=1 data-size="sm" value="${topicPostsDTO.rating}"
                                   name="rating${topicPostsDTO.resId}">
                        </div>
                    </g:if>
                    <div id="ratingData" style="float: right">${topicPostsDTO.countUsersRated} user(s) rated this post at <g:if test="${topicPostsDTO.avgRating}">${topicPostsDTO.avgRating}</g:if> <g:else>0</g:else></div>

                </div>


                <div width="100%">
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
                                                                src="/images/twitter.png">
                        </div></a>
                        <a href="#"><div class="glyphicon"><img style="width:13px; height: 13px;"
                                                                src="/images/googlePlus.png"></div></a>
                    </g:if>
                </div>
                <g:if test="${homeDTO}">
                    <g:include view="common/_modalEditDoc.gsp"/>
                    <g:include view="common/_modalEditLink.gsp"/>
                    <g:include view="common/_modalDeletePost.gsp"/>
                </g:if>
                <div class="rightA">
                    <g:if test="${homeDTO && (topicPostsDTO.createdUserId == homeDTO.userId || homeDTO.admin)}">
                        <a data-toggle="modal" href="#deletePostTemplate">Delete</a>
                        <g:if test="${topicPostsDTO.type.contains('DocumentResource')}">
                            <a data-toggle="modal" href="#editDocTemplate">Edit</a>
                        </g:if>
                        <g:else>
                            <a data-toggle="modal" href="#editLinkTemplate">Edit</a>
                        </g:else>
                    </g:if>
                    <g:if test="${topicPostsDTO.type.contains('DocumentResource')}">
                        <a target="_blank" href="/LinkSharing_Docs/${topicPostsDTO.filePath}">Download</a>
                    </g:if>
                    <g:else>
                        <a target="_blank" href="${topicPostsDTO.url}">View full site</a>
                    </g:else>
                    <g:if test="${topicPostsDTO.isSubscribed}">
                        <g:if test="${topicPostsDTO.read}">
                            <a href="/resource/markAsReadPost?resourceId=${topicPostsDTO.resId}&read=false">Mark as Unread</a>
                        </g:if>
                        <g:else>
                            <a href="/resource/markAsReadPost?resourceId=${topicPostsDTO.resId}&read=true">Mark as read</a>
                        </g:else>
                    </g:if>
                </div>
            </div>

        </div>

    </div>

    <div class="right">
        <div class="login img-rounded">
            <div class="modal-header lead">
                Trending Topics
            </div>

            <g:render template="viewPostTopics" model="[trendTopicDTOList: trendTopicDTOList]"></g:render>

        </div>

    </div>
</div>
<script>

    $(document).ready(function () {

        $(document).on('change', '.rating', function () {
            var rating = $(this).val();
            var name = $(this).attr('name');
            var resId = name.substring(name.lastIndexOf('ing') + 3);
            $.ajax({
                url: "/resource/setRating",
                data: {resId: resId, rating: rating},
                dataType: "json",
                success: function (model) {
                    $('#ratingData').text(model.countUsers + ' user(s) rated this post at ' + model.avgRating);
                }
            });
        });

        $('#editDoc').validate({
            rules: {
                document: {required: true},
                descriptionDoc: {required: true, minlength: 5, maxlength: 254}
            },
            messages: {
                document: {
                    required: "Please select a document"
                },
                descriptionDoc: {
                    required: "Please enter description",
                    minlength: "Description should be atleat 5 characters long",
                    maxlength: "Description can be max 254 characters long"
                }
            }
        });
        $('#editLink').validate({
            rules: {
                link: {required: true, url: true},
                descriptionLink: {required: true, minlength: 5, maxlength: 254}
            },
            messages: {
                link: {
                    required: "Please enter a link",
                    url: "URL is invalid"
                },
                descriptionLink: {
                    required: "Please enter description",
                    minlength: "Description should be atleat 5 characters long",
                    maxlength: "Description can be max 254 characters long"
                }
            }
        });
    });
</script>
</body>
</html>
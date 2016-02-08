<%--
  Created by IntelliJ IDEA.
  User: ttnd
  Date: 24/1/16
  Time: 10:07 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="signedIn">
    <title>View All Topics</title>

</head>

<body>

<div class="bodyClass">
    <div class="leftSmall">
        <div class="recentShares img-rounded">

            <div class="modal-header lead" id="topicNameDiv">
                Topics:
            </div>
            <g:render template="topicEntity" model="[viewAllList: viewAllList]"></g:render>

        </div>
    </div>


    <div class="rightLarge" id="rightLarge">
        <div class="login img-rounded">
            <div class="modal-header lead">
                Posts: Select any topic to show posts
            </div>
            <div style="height: 100px">
                Select any topic to show posts

            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        $(document).on('click', '.tName', function (event) {
            event.preventDefault();
            var name = $(this).attr('name');
            var topicId = name.substring(5);
            var topicName = $(this).text();
            $.ajax({
                url: '/topic/showTopicPosts',
                data: {'topicId': topicId, 'topicName': topicName},
                success: function (response) {
                    $('.rightLarge').empty();
                    $('.rightLarge').append(response);
                    $('#topicNameDiv').empty();
                    $('#topicNameDiv').append('Topic: "' + topicName + '"');
                }
            });

        });
    });
</script>
</body>
</html>
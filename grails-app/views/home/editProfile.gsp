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
    <title>Edit Profile</title>

</head>

<body>

<div class="bodyClass">
    <div class="leftSmall">
        <div class="recentShares img-rounded">

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
                <lead class="large">${homeDTO.fullName}</lead>

                <p class="greyText">@${homeDTO.userName}</p>
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
                            ${homeDTO.topicSub.size()}
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                        <td>
                            ${homeDTO.topicsCreatedCount}
                        </td>
                    </tr>
                </table>
            </div>

        </div>

        <div class="topPosts img-rounded">
            <div class="modal-header lead ">
                Topics
            </div>
            <g:render template="editProfileTopics" model="[trendTopicDTOList:trendTopicDTOList]"></g:render>

        </div>
    </div>

    <div class="rightLarge">

        <div class="login img-rounded">
            <div class="modal-header lead">
                Profile
            </div>
            <g:uploadForm class="form-horizontal" controller="home" action="editProfile" id="editProfile-form"
                          name="editProfile-form">
                <div class="form-group">
                    <div class="col-lg-4 col-sm-3">
                        <label for="firstName" class="control-label">First Name*</label>
                    </div>

                    <div class="col-lg-7 col-sm-6">
                        <input type="text" id="firstName" name="firstName" placeholder="First Name" value="${homeDTO.firstName}"
                               class="form-control"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-lg-4 col-sm-3">
                        <label for="lastName" class="control-label">Last Name*</label>
                    </div>

                    <div class="col-lg-7 col-sm-6">
                        <input type="text" id="lastName" name="lastName" placeholder="Last Name" class="form-control" value="${homeDTO.lastName}"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-lg-4 col-sm-3">
                        <label for="userName" class="control-label">User Name*</label>
                    </div>

                    <div class="col-lg-7 col-sm-6">
                        <input type="text" id="userName" name="userName" placeholder="User Name" class="form-control" value="${homeDTO.userName}"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-lg-4 col-sm-3">
                        <label for="photo" class="control-label">Photo</label>
                    </div>

                    <div class="col-lg-7 col-sm-6">
                        <input type="file" id="photo" placeholder="Photo" name="photo" class="form-control"/>
                    </div>
                </div>

                <div class="form-group">

                    <div class="col-lg-11 col-sm-9">
                        <g:submitButton id="submitEditProfile" name="submitEditProfile" value="Update"
                                        class="form-control marginclass"/>
                    </div>
                </div>

            </g:uploadForm>

        </div>

        <div class="register img-rounded">
            <g:uploadForm class="form-horizontal" controller="home" action="updatePassword" id="updatePassword-form"
                          name="updatePassword-form">
                <div class="modal-header lead ">
                    Change Password
                </div>

                <div class="form-group">
                    <div class="col-lg-4 col-sm-3">
                        <label for="password" class="control-label">Password*</label>
                    </div>

                    <div class="col-lg-7 col-sm-6">
                        <input type="password" id="password" name="password" placeholder="Password" class="form-control"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-lg-4 col-sm-3">
                        <label for="cnfpassword" class="control-label">Confirm Password*</label>
                    </div>

                    <div class="col-lg-7 col-sm-6">
                        <input type="password" id="cnfpassword" name="cnfpassword" placeholder="Confirm Password"
                               class="form-control"/>
                    </div>
                </div>

                <div class="form-group">

                    <div class="col-lg-11 col-sm-9">
                        <g:submitButton id="submitUpdatePassword" name="submitUpdatePassword" value="Update"
                                        class="form-control marginclass"/>
                    </div>
                </div>

            </g:uploadForm>
        </div>

    </div>

</div>
</div>
<script>

    //validations start
    $(document).ready(function () {
        $('#editProfile-form').validate({
            rules: {
                firstName: {required: true, minlength: 5, maxlength: 254},
                lastName: {required: true, minlength: 5, maxlength: 254},
                userName: {
                    required: true, minlength: 5, maxlength: 254,
                    remote: {
                        url: "${request.contextPath}/home/validateUserName",
                        type: "get",
                        data: {
                            userName: function () {
                                return $("#editProfile-form input[name=userName]").val().trim();
                            }
                        }
                    }
                }
            },
            messages: {
                firstName: {
                    required: "Please enter firstname",
                    minlength: "Your firstname must be at least 5 characters long",
                    maxlength: "Your firstname must be max 254 characters long"
                },
                lastName: {
                    required: "Please enter lastName",
                    minlength: "Your lastName must be at least 5 characters long",
                    maxlength: "Your lastName must be max 254 characters long"
                },
                userName: {
                    required: "Please enter username",
                    minlength: "Your user name must be at least 5 characters long",
                    maxlength: "Your user name must be max 254 characters long",
                    remote: "Username not available"

                }
            }
        });


        $('#updatePassword-form').validate({
            rules: {
                password: {
                    required: true,
                    minlength: 5, maxlength: 254
                },
                cnfpassword: {
                    required: true,
                    equalTo: "#password"
                }
            },
            messages: {
                password: {
                    required: "Please provide a password",
                    minlength: "Your password must be at least 5 characters long",
                    maxlength: "Your password must be max 254 characters long"
                },
                cnfpassword: {
                    required: "Please confirm password",
                    minlength: "Password and Confirm password should be same"
                }
            }
        });

    });


</script>
</body>
</html>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="layout" content="signedIn">
    <title>Link Sharing</title>
    %{--<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">--}%
</head>

<body>
<div class="wrapper">

    <div class="bodyClass">
        <div class="left">
            <div class="recentShares img-rounded">
                <div class="modal-header lead ">
                    Recent Shares
                </div>
                <g:each in="${recentSharesList}" var="topicPostsDTO" status="i">
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
            <div class="topPosts img-rounded">
                <div class="modal-header lead ">
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
        <div class="right">
            <div class="login img-rounded">
                <div class="modal-header lead">
                    Login
                </div>
                <g:uploadForm class="form-horizontal" controller="login" action="loginHandler" id="login-form"
                              name="login-form">
                    <div class="form-group">
                        <div class="col-lg-4 col-sm-3">
                            <label for="emailLogin" class="control-label">Email*</label>
                        </div>

                        <div class="col-lg-7 col-sm-6">
                            <g:textField name="emailLogin" id="emailLogin" placeholder="Email" class="form-control"/>
                            <label id="errorEmailId"></label>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-lg-4 col-sm-3">
                            <label for="passwordLogin" class="control-label">Password</label>
                        </div>

                        <div class="col-lg-7 col-sm-6">
                            <g:passwordField name="passwordLogin" id="passwordLogin" placeholder="Password"
                                             class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">

                        <div class="col-lg-4 col-sm-3">
                            %{--<a href="/login/forgotPassword" id="forgotPassword"
                               name="forgotPassword">Forgot Password</a>--}%
                            <g:actionSubmit class="form-control" action="forgotPassword" value="Forgot Password"
                                            id="forgotPassword"
                                            name="forgotPassword"></g:actionSubmit>
                        </div>
                        <div class="col-lg-7 col-sm-6">
                            <g:submitButton id="submit" name="Submit" value="Login" class="form-control"/>
                        </div>
                    </div>
                </g:uploadForm>
            </div>
            <div class="register img-rounded">
                <g:uploadForm class="form-horizontal" controller="login" action="registerUser" id="register-form"
                              name="register-form">
                    <div class="modal-header lead ">
                        Register
                    </div>
                    <div class="form-group">
                        <div class="col-lg-4 col-sm-3">
                            <label for="firstName" class="control-label">First Name*</label>
                        </div>

                        <div class="col-lg-7 col-sm-6">
                            <input type="text" id="firstName" name="firstName" placeholder="First Name"
                                   class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-lg-4 col-sm-3">
                            <label for="lastName" class="control-label">Last Name*</label>
                        </div>
                        <div class="col-lg-7 col-sm-6">
                            <input type="text" id="lastName" name="lastName" placeholder="Last Name"
                                   class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-lg-4 col-sm-3">
                            <label for="email" class="control-label">Email*</label>
                        </div>

                        <div class="col-lg-7 col-sm-6">
                            <input type="text" id="email" name="email" placeholder="Email" class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-lg-4 col-sm-3">
                            <label for="userName" class="control-label">User Name*</label>
                        </div>

                        <div class="col-lg-7 col-sm-6">
                            <input type="text" id="userName" name="userName" placeholder="User Name"
                                   class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="col-lg-4 col-sm-3">
                            <label for="password" class="control-label">Password*</label>
                        </div>

                        <div class="col-lg-7 col-sm-6">
                            <input type="password" id="password" name="password" placeholder="Password"
                                   class="form-control"/>
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
                        <div class="col-lg-4 col-sm-3">
                            <label for="photo" class="control-label">Photo</label>
                        </div>

                        <div class="col-lg-7 col-sm-6">
                            <input type="file" id="photo" placeholder="Photo" name="photo" class="form-control"/>
                        </div>
                    </div>

                    <div class="form-group">

                        <div class="col-lg-11 col-sm-9">
                            <g:submitButton id="submitRegister" name="Submit" value="Register"
                                            class="form-control"/>
                        </div>
                    </div>

                </g:uploadForm>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">

    $('#login-form').validate({
        rules: {
            emailLogin: {
                required: true,
                minlength: 5,
                maxlength: 254,
                myEmail: true,
                remote: {
                    url: "${request.contextPath}/login/validateForgotPassEmail",
                    type: "post",
                    data: {
                        email: function () {
                            return $("#login-form input[name=emailLogin]").val().trim();
                        }
                    }
                }
            }
        },
        messages: {
            emailLogin: {
                required: "Please enter email",
                minlength: "Your email should be min 5 characters long",
                maxlength: "Your email can be max 254 characters long",
                remote: "Your email is not registered. Please create an account"
            }
        }
    });
    $(document).ready(function () {

        $(document).on('click', '#forgotPassword', function (e) {
            $('#login-form').validate();
            if ($("#login-form").valid()) {
                return true;
            }
            else {
                return false;
            }
        });

        $(document).on('click', '#submit', function () {
            $('#login-form').validate({
                rules: {
                    emailLogin: {required: true, minlength: 5, maxlength: 254, myEmail: true},
                    passwordLogin: {required: true, maxlength: 254}
                },
                messages: {
                    emailLogin: {
                        required: "Please enter email",
                        minlength: "Your email should be min 5 characters long",
                        maxlength: "Your email can be max 254 characters long"
                    },
                    passwordLogin: {
                        required: "Please enter password",
                        minlength: "Your password should be min 5 characters long",
                        maxlength: "Your password can be max 254 characters long"
                    }
                }
            });
        });


        $('#register-form').validate({
            rules: {
                firstName: {alphabet: true, required: true, minlength: 5, maxlength: 254},
                lastName: {alphabet: true, required: true, minlength: 5, maxlength: 254},
                userName: {
                    required: true, minlength: 5, maxlength: 254, username: true,
                    remote: {
                        url: "${request.contextPath}/login/validateUserName",
                        type: "post",
                        data: {
                            userName: function () {
                                return $("#register-form input[name=userName]").val().trim();
                            }
                        }
                    }
                },
                email: {
                    required: true,
                    myEmail: true, minlength: 5, maxlength: 254,
                    remote: {
                        url: "${request.contextPath}/login/validateEmail",
                        type: "post",
                        data: {
                            email: function () {
                                return $("#register-form input[name=email]").val().trim();
                            }
                        }
                    }
                },
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
                    remote: "Username not available",
                    minlength: "Your user name must be at least 5 characters long",
                    maxlength: "Your user name must be max 254 characters long"
                },
                password: {
                    required: "Please provide a password",
                    minlength: "Your password must be at least 5 characters long",
                    maxlength: "Your password must be max 254 characters long"
                },
                cnfpassword: {
                    required: "Please confirm password",
                    equalTo: "Password and Confirm Password do not match"
                },
                email: {
                    required: "Please enter email address",
                    remote: "Email already registered",
                    minlength: "Your email address must be at least 5 characters long",
                    maxlength: "Your email address must be max 254 characters long"
                }
            }
        });
        $(document).bind("keypress", function (e) {
            if (e.keyCode == 13) {
                $("#submit").click();
                return false;
            }
        });
    });
</script>
<asset:stylesheet src="home.css"></asset:stylesheet>

<asset:stylesheet src="bootstrap.min.css"></asset:stylesheet>

</body>
</html>
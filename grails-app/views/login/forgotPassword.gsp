<%--
  Created by IntelliJ IDEA.
  User: ttnd
  Date: 3/2/16
  Time: 12:51 PM
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="layout" content="signedIn">
    <title>Forgot Password</title>
</head>
<body>
<div class="wrapper">


    <div class="bodyClass">

        <div style="width: 50%;margin-left: 25%;">
            <div class="login img-rounded">
                <div class="modal-header lead">
                    Update Password
                </div>
                <g:form class="form-horizontal" controller="login" action="changeForgotPassword" id="password-form" name="password-form">

                    <div class="form-group">
                        <div class="col-lg-4 col-sm-3">
                            <label for="email" class="control-label">Email*</label>
                        </div>
                        <div class="col-lg-7 col-sm-6">
                            <input type="text" id="email" name="email" placeholder="Email" class="form-control"/>
                        </div>
                    </div>

                    <div class="form-group">

                        <div class="col-lg-11 col-sm-9">
                            <g:submitButton id="submit" name="Submit" value="Reset Password" class="form-control" style="margin-left: 10px"/>
                        </div>
                    </div>

                </g:form>
            </div>

        </div>
    </div>
</div>

</body>
</html>
<%--
  Created by IntelliJ IDEA.
  User: ttnd
  Date: 22/1/16
  Time: 2:48 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="signedIn">
    <title>Link Sharing Users</title>

</head>

<body>

<div class="bodyClass">
    <div class="container">
        <div class="row">
            <div class="table-responsive">
                <table id="myTable" class="table table-bordered table-hover table-striped">
                    <thead>
                    <tr>
                        <th>User Id</th>
                        <th>User Name</th>
                        <th>Email</th>
                        <th>First Name</th>
                        <th>Last Name</th>
                        <th>Active</th>
                        <th>Manage</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${usersDTOList}" var="userDto" status="i">
                        <tr>
                            <th scope="row">${userDto.userId}</th>
                            <td>${userDto?.userName}</td>
                            <td>${userDto?.email}</td>
                            <td>${userDto?.firstName}</td>
                            <td>${userDto?.lastName}</td>

                            <g:if test="${userDto.active}">
                                <td>Yes</td>
                                <g:if test="${userDto.admin}">
                                    <td>ADMIN</td>
                                </g:if>
                                <g:else>
                                    <td><a href="/home/deactivateUser?userId=${userDto.userId}">Deactivate</a></td>
                                </g:else>

                            </g:if>
                            <g:else>
                                <td>No</td>
                                <td><a href="/home/activateUser?userId=${userDto.userId}">Activate</a></td>
                            </g:else>
                        </tr>
                    </g:each>

                    </tbody>
                </table>
            </div>

            <div class="col-md-12 text-center dataTables_paginate">
                <input type="button" value="First" name="first" id="first">
                <input type="button" value="Previous" name="previous" id="previous">
                <input type="button" value="Next" name="next" id="next">
                <input type="button" value="Last" name="last" id="last">
            </div>
        </div>
    </div>

</div>
<script>

    $(document).ready(function () {

        var oTable = $('#myTable').dataTable();
        oTable.fnPageChange('first');
    });
</script>
</body>
</html>
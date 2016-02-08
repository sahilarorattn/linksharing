<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
                    data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a href="/login/index" class="navbar-brand">Link Sharing</a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse navbar-right" id="bs-example-navbar-collapse-1">

            <g:form controller="resource" action="searchPosts" id="searchForm" class="pull-left" role="search"
                    style="display: inline-flex;margin-top: 10px;">

                <a href="#" class="">
                    <span class="glyphicon glyphicon-search "
                          style="background: white;padding: 10px 8px;border-radius: 50% 0 0 50%;border-right: 0;"></span>
                </a>
                <input style="border-radius: 0; margin-top: 1px;height: 35px;border: 0;" value="${searchText}"
                       placeholder="Search..." class="form-control searchingInp" type="text" name="searchText"
                       id="searchText"/>
                <a href="#" class="clearSearch"><span class="glyphicon glyphicon-remove-circle"
                                                      style="background: white; padding: 10px 8px;border-radius: 0 50% 50% 0;border-left: 0;"></span>
                </a>

            </g:form>

            <g:if test="${homeDTO}">
                <ul class="nav navbar-nav ">
                    <li><a href="#createTopicTemplate" data-toggle="modal"><div
                            class="glyphicon glyphicon-comment"></div>
                    </a>
                    </li>
                    <li><a href="#sendInvitationTemplate" data-toggle="modal"><div class="glyphicon glyphicon-envelope"></div></a>
                    </li>
                    <li><a href="#shareLinkTemplate" data-toggle="modal"><div class="glyphicon glyphicon-upload"></div>
                    </a>
                    </li>
                    <li><a href="#shareDocTemplate" data-toggle="modal"><div class="glyphicon glyphicon-file"></div></a>
                    </li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                           aria-expanded="false"><span
                                class="glyphicon glyphicon-user"></span> &nbsp;${homeDTO.userName} <span
                                class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li class=""><a href="/home/index">Home</a></li>
                            <li class=""><a href="/home/showEditProfile">Profile</a></li>
                            <g:if test="${homeDTO && homeDTO.admin == true}">
                                <li><a href="/home/fetchUsers">Users</a></li>
                                <li><a href="/topic/viewAll">Topics</a></li>
                            </g:if>
                            <li><a href="/login/logout">Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </g:if>
        </div><!-- /.navbar-collapse -->
    </div><!-- /.container-fluid -->
</nav>

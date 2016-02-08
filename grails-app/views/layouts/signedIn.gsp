<%--
  Created by IntelliJ IDEA.
  User: ttnd
  Date: 19/1/16
  Time: 10:04 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:layoutTitle/></title>

    <asset:javascript src="jquery-1.11.1.min.js"></asset:javascript>
    <asset:javascript src="jquery.dataTables.min.js"></asset:javascript>
    <asset:stylesheet src="jquery.dataTables.min.css"></asset:stylesheet>
    <asset:javascript src="jquery.validate.js"></asset:javascript>
    <g:javascript src="application.js"></g:javascript>
    <asset:javascript src="bootstrap.min.js"></asset:javascript>
    <asset:stylesheet src="home.css"></asset:stylesheet>
    <asset:stylesheet src="bootstrap.min.css"></asset:stylesheet>
    <asset:javascript src="jquery.dataTables.js"></asset:javascript>
    <asset:stylesheet src="dataTables.bootstrap.min.css"></asset:stylesheet>
    <script>

        $(document).ready(function () {

            $('#createTopic').validate({
                rules: {
                    topicName: {
                        required: true,
                        alphaNumeric: true,
                        remote: {
                            url: "${request.contextPath}/topic/validateTopic",
                            type: "post",
                            data: {
                                topicName: function () {
                                    return $("#createTopic input[name=topicName]").val().trim();
                                }
                            }
                        }
                    }
                },
                messages: {
                    topicName: {
                        required: "Please enter topic name",
                        remote: "Topic already exists"
                    }
                }
            });
            $('#sendInvitation').validate({
                rules: {
                    emailUser: {
                        required: true,
                        alphaNumeric: true,
                        myEmail:true
                    }
                },
                messages: {
                    emailUser: {
                        required: "Please enter topic name",
                        remote: "Topic already exists"
                    }
                }
            });
            $('#createDocument').validate({
                rules: {
                    document: {required: true},
                    description: {required: true}
                },
                messages: {
                    document: {
                        required: "Please select a document"
                    },
                    description: {
                        required: "Please enter description"
                    }
                }
            });
            $('#createLink').validate({
                rules: {
                    link: {required: true, url: true},
                    description: {required: true, minlength: 5}
                },
                messages: {
                    link: {
                        required: "Please enter a link",
                        url: "URL is invalid"
                    },
                    description: {
                        required: "Please enter description",
                        minlength: "Description should be atleat 5 characters long"
                    }
                }
            });
        });
    </script>
    <script>
        $.fn.pageMe = function (opts) {
            var $this = this,
                    defaults = {
                        perPage: 10,
                        showPrevNext: false,
                        hidePageNumbers: false
                    },
                    settings = $.extend(defaults, opts);

            var listElement = $this;
            var perPage = settings.perPage;
            var children = listElement.children();
            var pager = $('.pager');

            if (typeof settings.childSelector != "undefined") {
                children = listElement.find(settings.childSelector);
            }

            if (typeof settings.pagerSelector != "undefined") {
                pager = $(settings.pagerSelector);
            }

            var numItems = children.size();
            var numPages = Math.ceil(numItems / perPage);

            pager.data("curr", 0);

            if (settings.showPrevNext) {
                $('<li><a href="#" class="prev_link">«</a></li>').appendTo(pager);
            }

            var curr = 0;
            while (numPages > curr && (settings.hidePageNumbers == false)) {
                $('<li><a href="#" class="page_link">' + (curr + 1) + '</a></li>').appendTo(pager);
                curr++;
            }

            if (settings.showPrevNext) {
                $('<li><a href="#" class="next_link">»</a></li>').appendTo(pager);
            }

            pager.find('.page_link:first').addClass('active');
            pager.find('.prev_link').hide();
            if (numPages <= 1) {
                pager.find('.next_link').hide();
            }
            pager.children().eq(1).addClass("active");

            children.hide();
            children.slice(0, perPage).show();

            pager.find('li .page_link').click(function () {
                var clickedPage = $(this).html().valueOf() - 1;
                goTo(clickedPage, perPage);
                return false;
            });
            pager.find('li .prev_link').click(function () {
                previous();
                return false;
            });
            pager.find('li .next_link').click(function () {
                next();
                return false;
            });

            function previous() {
                var goToPage = parseInt(pager.data("curr")) - 1;
                goTo(goToPage);
            }

            function next() {
                goToPage = parseInt(pager.data("curr")) + 1;
                goTo(goToPage);
            }

            function goTo(page) {
                var startAt = page * perPage,
                        endOn = startAt + perPage;

                children.css('display', 'none').slice(startAt, endOn).show();

                if (page >= 1) {
                    pager.find('.prev_link').show();
                }
                else {
                    pager.find('.prev_link').hide();
                }

                if (page < (numPages - 1)) {
                    pager.find('.next_link').show();
                }
                else {
                    pager.find('.next_link').hide();
                }

                pager.data("curr", page);
                pager.children().removeClass("active");
                pager.children().eq(page + 1).addClass("active");

            }
        };
        function showMessages(message) {
            $('#allMessages').html('<div class="alert alert-success" role="alert" id="message">' +
                    '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
                    '<span aria-hidden="true">&times;</span></button>' +
                    '<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>' +
                    '<span class="sr-only">Info:</span><span id="messageSpan">' + message + '</span>' +
                    '</div>');
        }

        function showErrors(message) {
            $('#allMessages').html('<div class="alert alert-warning" role="alert" id="message">' +
                    '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
                    '<span aria-hidden="true">&times;</span></button>' +
                    '<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>' +
                    '<span class="sr-only">Info:</span><span id="messageSpan">' + message + '</span>' +
                    '</div>');
        }
    </script>
    <g:layoutHead/>
</head>

<body>
<div>
%{--<g:if test="${flash.errors}">
    ${flash.errors}
</g:if>--}%

    <g:hasErrors bean="${registerCO}">
        <ul>
            <g:eachError var="err" bean="${registerCO}">
                <li>${err}</li>
            </g:eachError>
        </ul>
    </g:hasErrors>


%{-- <g:if test="${flash.errors}">
     <div class="alert alert-danger" role="alert">
         <button type="button" class="close" data-dismiss="alert" aria-label="Close">
             <span aria-hidden="true">&times;</span></button>
         <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
         <span class="sr-only">Error:</span>${flash.errors}
     </div>
 </g:if>

--}%

</div>

<div class=" ">
    <g:include view="common/_signedInHeader.gsp"/>
    <g:if test="${homeDTO}">
        <g:include view="common/_modalCreateTopic.gsp"/>
        <g:include view="common/_modalShareLink.gsp"/>
        <g:include view="common/_modalShareDoc.gsp"/>
        <g:include view="common/_modalDeleteConfirm.gsp"/>
        <g:include view="common/_modalSendInvittion.gsp"/>
        <g:include view="common/_modalSendSingleInvittion.gsp"/>
    </g:if>
    <g:if test="${flash.message}">
        <div class="alert alert-success" role="alert">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span></button>
            <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
            <span class="sr-only">Info:</span>${flash.message}
        </div>
    </g:if>
    <g:if test="${flash.error}">
        <div class="alert alert-warning" role="alert">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span></button>
            <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
            <span class="sr-only">Info:</span>${flash.error}
        </div>
    </g:if>
    <div id="allMessages"></div>

    <div>
        <g:layoutBody/>
    </div>
</div>
<script>
    $(document).ready(function () {
        $('.clearSearch').click(function (e) {
            e.preventDefault();
            $('.searchingInp').val('');
        });

        $('#searchText').keypress(function (e) {
            if (e.which == 13) {
                $('form#searchForm').submit();
            }
        });
        $(document).on("click", ".deleteTopic", function () {
            var myId = $(this).data('id');
            $("#deleteConfirm #topicId").val( myId);
            // As pointed out in comments,
            // it is superfluous to have to manually call the modal.
            // $('#addBookDialog').modal('show');
        });
        /*$(document).on("click", ".sendInvite", function () {
            alert($(this).data('data-tname'));
//            $("#tname").val($(this).data('tname'));
            // As pointed out in comments,
            // it is superfluous to have to manually call the modal.
            // $('#addBookDialog').modal('show');
        });*/
        $('#sendInvitationSingleTemplate').on('show.bs.modal', function(e) {
            var tid = e.relatedTarget.dataset.tid;
            var tname = e.relatedTarget.dataset.tname;
            $("#sendInvitationSingleTemplate #tname").val(tname);
            $("#sendInvitationSingleTemplate #topicInv").val(tid);

        });
    });
</script>
</body>
</html>
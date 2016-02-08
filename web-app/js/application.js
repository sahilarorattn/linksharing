$(document).ready(function () {
    var anc = $("a.trendSubAnc:contains('Subscribe')");
    for (var i = 0; i < anc.length; i++) {
        var an = anc[i];
        var theHref = an.href;
        var topicId1 = theHref.substring(theHref.lastIndexOf('=') + 1);
        var seriousness = $('#seriousnessTrend'+topicId1).val();
        if (undefined == seriousness) {
            seriousness = "CASUAL"
        }
        an.href = theHref + "&seriousness=" + seriousness;
        seriousness = null;
    }
    var ancSub = $("a.subSubAnc:contains('Subscribe')");
    for (var i = 0; i < ancSub.length; i++) {
        var an = ancSub[i];
        var theHref = an.href;
        var topicId1 = theHref.substring(theHref.lastIndexOf('=') + 1);
        var seriousness = $('#seriousnessSub'+topicId1).val();
        if (undefined == seriousness) {
            seriousness = "CASUAL"
        }
        an.href = theHref + "&seriousness=" + seriousness;
        seriousness = null;
    }

    $(document).on('change', '.seriousnessSub', function () {
        var seriousness = $(this).val();
        var name = $(this).attr('name');
        var topicId = name.substring(name.lastIndexOf('Sub') + 3);
        $.ajax({
            url: "/topic/updateSeriousness",
            data: {seriousness: seriousness, topicId: topicId},
            success: function (result) {
                showMessages(result);
            }
        });
    });

    $(document).on('change', '.seriousnessTrend', function () {
        var seriousness = $(this).val();
        var name = $(this).attr('name');
        var topicId = name.substring(name.lastIndexOf('end') + 3);
        $.ajax({
            url: "/topic/updateSeriousness",
            data: {seriousness: seriousness, topicId: topicId},
            success: function (result) {
                showMessages(result);
            }
        });
    });

    $(document).on('change', '.visibilityTrend', function () {
        var visibility = $(this).val();
        var name = $(this).attr('name');
        var topicId = name.substring(name.lastIndexOf('end') + 3);
        $.ajax({
            url: "/topic/updateVisibility",
            data: {visibility: visibility, topicId: topicId},
            success: function (result) {
                showMessages(result);
            }
        });
    });

    $(document).on('change', '.visibilitySub', function () {
        var visibility = $(this).val();
        var name = $(this).attr('name');
        var topicId = name.substring(name.lastIndexOf('Sub') + 3);
        $.ajax({
            url: "/topic/updateVisibility",
            data: {visibility: visibility, topicId: topicId},
            success: function (result) {
                showMessages(result);
            }
        });
    });

    //Subscriptions Start
    $(document).on('click', '.editSub', function () {
        var name = $(this).attr('name');
        var topicId1 = name.substring(name.lastIndexOf('Sub') + 3);
        var anc = $('#subTopicNameSpan' + topicId1 + '>a');
        var value = anc.text();
        anc.replaceWith('<input type="text" value="' + value + '" id="inp' + name + '" name="inp' + name + '" class="inps"/><input type="button" value="Save" id="save' + name + '" name="save' + name + '" class="saveSub"/><input type="button" value="Cancel" id="can' + name + '" name="can' + name + '" class="canSub"/>');
        anc.hide();
        return false;
    });

    $(document).on('click', '.canSub', function () {
        var name = $(this).attr('name');
        var topicId1 = name.substring(name.lastIndexOf('Sub') + 3);
        var topicName = $('#hidSubTopName' + topicId1 + '').val();
        var dad = $(this).parent();
        $('#caneditSub' + topicId1).remove();
        $('#saveeditSub' + topicId1).remove();
        $('#inpeditSub' + topicId1).remove();
        dad.append('<a href="/topic/showTopic?topicId=' + topicId1 + '" >' + topicName + '</a>');
    });

    $(document).on('click', '.saveSub', function () {
        var name = $(this).attr('name');
        var topicId1 = name.substring(name.lastIndexOf('Sub') + 3);
        var topicName = $('#hidSubTopName' + topicId1 + '').val();
        var newTopicName = $('#inpeditSub' + topicId1 + '').val();
        var dad = $(this).parent();
        if(topicName.toUpperCase()===newTopicName.toUpperCase()){
            $('#caneditSub' + topicId1).remove();
            $('#saveeditSub' + topicId1).remove();
            $('#inpeditSub' + topicId1).remove();
            dad.append('<a href="/topic/showTopic?topicId=' + topicId1 + '" >' + newTopicName + '</a>');
            $('#hidSubTopName' + topicId1 + '').val(newTopicName);
            showMessages('Topic name updated successfully.');
        }
        else{
            $.ajax({
                url: "/topic/updateTopicName",
                data: {topicName: newTopicName, topicId: topicId1},
                success: function (result) {
                    if (result=="true") {
                        $('#caneditSub' + topicId1).remove();
                        $('#saveeditSub' + topicId1).remove();
                        $('#inpeditSub' + topicId1).remove();
                        dad.append('<a href="/topic/showTopic?topicId=' + topicId1 + '" >' + newTopicName + '</a>');
                        $('#hidSubTopName' + topicId1 + '').val(newTopicName);
                        showMessages('Topic name updated successfully.');
                    }
                    else {
                        showErrors('Topic name already exists.');
                    }
                }
            });
        }
    });


    //Trending Topics Start
    $(document).on('click', '.editTrend', function () {
        var name = $(this).attr('name');
        var topicId1 = name.substring(name.lastIndexOf('end') + 3);
        var anc = $('#trendTopicNameSpan' + topicId1 + '>a');
        var value = anc.text();
        anc.replaceWith('<input type="text" value="' + value + '" id="inp' + name + '" name="inp' + name + '" class="inps"/><input type="button" value="Save" id="save' + name + '" name="save' + name + '" class="saveTrend"/><input type="button" value="Cancel" id="can' + name + '" name="can' + name + '" class="canTrend"/>');
        anc.hide();
        return false;
    });

    $(document).on('click', '.canTrend', function () {
        var name = $(this).attr('name');
        var topicId1 = name.substring(name.lastIndexOf('end') + 3);
        var topicName = $('#hidTrendTopName' + topicId1 + '').val();
        var dad = $(this).parent();
        $('#caneditTrend' + topicId1).remove();
        $('#saveeditTrend' + topicId1).remove();
        $('#inpeditTrend' + topicId1).remove();
        dad.append('<a href="/topic/showTopic?topicId=' + topicId1 + '" >' + topicName + '</a>');
    });

    $(document).on('click', '.saveTrend', function () {
        var name = $(this).attr('name');
        var topicId1 = name.substring(name.lastIndexOf('end') + 3);
        var topicName = $('#hidTrendTopName' + topicId1 + '').val();
        var newTopicName = $('#inpeditTrend' + topicId1 + '').val();
        var dad = $(this).parent();
        if(topicName.toUpperCase()===newTopicName.toUpperCase()){
            $('#caneditTrend' + topicId1).remove();
            $('#saveeditTrend' + topicId1).remove();
            $('#inpeditTrend' + topicId1).remove();
            dad.append('<a href="/topic/showTopic?topicId=' + topicId1 + '" >' + newTopicName + '</a>');
            $('#hidTrendTopName' + topicId1 + '').val(newTopicName);
            showMessages('Topic name updated successfully.');
        }
        else{
            $.ajax({
                url: "/topic/updateTopicName",
                data: {topicName: newTopicName, topicId: topicId1},
                success: function (result) {
                    if (result=="true") {
                        $('#caneditTrend' + topicId1).remove();
                        $('#saveeditTrend' + topicId1).remove();
                        $('#inpeditTrend' + topicId1).remove();
                        dad.append('<a href="/topic/showTopic?topicId=' + topicId1 + '" >' + newTopicName + '</a>');
                        $('#hidTrendTopName' + topicId1 + '').val(newTopicName);
                        showMessages('Topic name updated successfully.');
                    }
                    else {
                        showErrors('Topic name already exists.');
                    }
                }
            });
        }
    });


});
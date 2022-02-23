<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>">

    <link href="jquery/bootstrap-3.3.7-dist/css/bootstrap.css" type="text/css" rel="stylesheet"/>
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-3.3.7-dist/js/bootstrap.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>

    <link href="jquery/bootstrap-switch.min.css" type="text/css" rel="stylesheet" />
    <script src="jquery/bootstrap-switch.min.js"></script>

    <script type="text/javascript">

        var rsc_bs_pag = {
            go_to_page_title: 'Go to page',
            rows_per_page_title: 'Rows per page',
            current_page_label: 'Page',
            current_page_abbr_label: 'p.',
            total_pages_label: 'of',
            total_pages_abbr_label: '/',
            total_rows_label: 'of',
            rows_info_records: 'records',
            go_top_text: '首页',
            go_prev_text: '上一页',
            go_next_text: '下一页',
            go_last_text: '末页'
        };

        $.fn.datetimepicker.dates['zh-CN'] = {
            days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
            daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
            daysMin: ["日", "一", "二", "三", "四", "五", "六", "日"],
            months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
            monthsShort: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
            today: "今天",
            suffix: [],
            meridiem: ["上午", "下午"]
        };

        $(function () {

            pageList(1, 3);

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                dataFormat: 'yyyy-mm-dd',
                timeFormat: 'HH:mm:ss',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            // 为查询按钮绑定事件，执行查询操作，触发pageList()方法
            $("#searchBtn").click(function () {
                /*
                   点击查询按钮的时候，我们应该先将搜索框中的信息保存起来，保存到隐藏域中
                */
                $("#hidden-name").val($.trim($("#search-name").val()))

                pageList(1, $("#buyerPage").bs_pagination('getOption', 'rowsPerPage'));
            })

            // 为全选的复选框绑定事件，触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked", this.checked)
            })

            $("#buyerBody").on("click",$("input[name=xz]"), function () {
                $("#qx").prop("checked", $("input[name=xz]").length==$("input[name=xz]:checked").length);
            })
        });


        function pageList(pageNum, pageSize) {

            // 将全选的复选框的√干掉
            $("#qx").prop("checked", false);

            // 查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()))

            $.ajax({
                url: "workbench/settings/buyer/pageList",
                data: {
                    "pageNum": pageNum,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    var html = "";

                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td>'+(i+1)+'</td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/settings/buyer/detail?id=' + n.id + '\';">' + n.loginAct + '</a></td>';
                        html += '<td>' + n.email + '</td>';
                        html += '<td><input name="switch" value="'+n.lockState+'" id="'+n.id+'" type="checkbox"></td>';
                        html += '</tr>';
                    })

                    $("#buyerBody").html(html);

                    //name值和input标签的name值一样
                    $("[name='switch']").bootstrapSwitch({
                        onText : "启用",      // 设置ON文本
                        offText : "禁用",    // 设置OFF文本
                        onColor : "success",// 设置ON文本颜色(info/success/warning/danger/primary)
                        offColor : "info",  // 设置OFF文本颜色 (info/success/warning/danger/primary)
                        size : "normal",    // 设置控件大小,从小到大  (mini/small/normal/large)
                        // 当开关状态改变时触发
                        onSwitchChange : function(event, state) {
                        }
                    });

                    $.each($("[name='switch']"), function () {
                        var status = $(this).val();
                        if (status == 0) {
                            $(this).bootstrapSwitch('state',false);
                        } else {
                            $(this).bootstrapSwitch('state',true);
                        }

                        $(this).bootstrapSwitch("onSwitchChange",function(event,state){
                            if (confirm("请确定是否修改该用户的状态！")) {
                                var id = $(this).attr("id");
                                var lockState = 0;
                                if(state==true){
                                    lockState = 1;
                                }else{
                                    lockState = 0;
                                }
                                $.ajax({
                                    url: "workbench/settings/buyer/updateStatus",
                                    data: {
                                        id: id,
                                        lockState: lockState
                                    },
                                    dataType: "json",
                                    success: function (data) {
                                        if (data.success) {
                                            alert("修改状态成功！");
                                        } else {
                                            alert("修改状态失败！");
                                        }
                                    }
                                })
                            } else {
                                var status = $(this).val();
                                if (status == 0) {
                                    $(this).bootstrapSwitch('state',false);
                                    return;
                                }
                                $(this).bootstrapSwitch('state',true);
                            }
                        });
                        })

                    // 计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1

                    // 数据处理完毕后，结合分页查询，对前端展现分页信息
                    $("#buyerPage").bs_pagination({
                        currentPage: pageNum, // 页码
                        rowsPerPage: pageSize, // 每页显示的记录条数
                        maxRowsPerPage: 20, // 每页最多显示的记录条数
                        totalPages: totalPages, // 总页数
                        totalRows: data.total, // 总记录条数
                        visiblePageLinks: 3, // 显示几个卡片
                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        // 该回调函数是在，点击分页组件的时候触发的
                        onChangePage: function (event, data) {
                            pageList(data.currentPage, data.rowsPerPage);
                        }
                    });
                }
            })
        }
    </script>
</head>
<body>

<input type="hidden" id="hidden-name"/>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>买家列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">买家账号</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <span>
                        <button type="button" class="btn btn-default" style="margin-left: 10px" id="searchBtn">
                            <span class="glyphicon glyphicon-search"></span> 查询
                        </button>
                    </span>
                </div>

            </form>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>#</td>
                    <td>买家账号</td>
                    <td>邮箱</td>
                    <td>锁定状态</td>
                </tr>
                </thead>
                <tbody id="buyerBody">
                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="buyerPage"></div>

        </div>

    </div>

</div>
</body>
</html>
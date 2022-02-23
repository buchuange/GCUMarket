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

            pageList(1, 2);

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            $(".time").datetimepicker({
                minView: "month",
                language: 'zh-CN',
                format: 'yyyy-mm-dd',
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
                $("#hidden-features").val($.trim($("#search-features").val()))

                pageList(1, $("#categoryPage").bs_pagination('getOption', 'rowsPerPage'));
            })

            $("#saveBtn").click(function () {
                $.ajax({
                    url: "workbench/category/save",
                    data: {
                        'name': $.trim($("#create-name").val()),
                        'features': $.trim($("#create-features").val()),
                        'description': $.trim($("#create-description").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        if (data.success) {

                            // 做完添加操作后，回到第一页，维持每页展现的记录数
                            pageList(1, $("#categoryPage").bs_pagination('getOption', 'rowsPerPage'));

                            // 清空添加操作模态窗口中的数据
                            $("#categoryAddForm").get(0).reset()

                            // 关闭添加操作的模态窗口
                            $("#createCategoryModal").modal("hide")
                        } else {
                            alert("产品类别录入失败！")
                        }
                    }
                })
            })

            // 为全选的复选框绑定事件，触发全选操作
            $("#qx").click(function () {
                $("input[name=xz]").prop("checked", this.checked)
            })

            $("#categoryBody").on("click",$("input[name=xz]"), function () {
                $("#qx").prop("checked", $("input[name=xz]").length==$("input[name=xz]:checked").length);
            })

            // 为删除按钮绑定事件，执行删除操作
            $("#deleteBtn").click(function () {

                // 找到复选框中所有挑√的复选框的jquery对象
                var $xz = $("input[name=xz]:checked")

                if ($xz.length == 0) {
                    alert("请选择要删除的产品类别")
                } else {
                    if (confirm("注：删除产品类别时，会将该类产品连同删除!\n确定删除所选中的记录吗？")) {

                        var param = "";
                        for (var i = 0; i < $xz.length; i++) {
                            param += "id=" + $($xz[i]).val();

                            // 如果不是最后一个元素, 需要在后面追加一个&符
                            if (i < $xz.length - 1) {
                                param += "&";
                            }
                        }

                        $.ajax({
                            url: "workbench/category/delete",
                            data: param,
                            type: "post",
                            dataType: "json",
                            success: function (data) {

                                if (data.success) {
                                    // 回到第一页，维持每页展现的记录数
                                    pageList(1, $("#categoryPage").bs_pagination('getOption', 'rowsPerPage'));
                                } else {
                                    alert("删除产品类别失败")
                                }
                            }
                        })
                    }
                }
            })


            // 为修改按钮绑定事件，打开修改操作的模态窗口
            $("#editBtn").click(function () {

                var $xz = $("input[name=xz]:checked")
                if ($xz.length == 0) {
                    alert("请选择要修改的记录")
                } else if ($xz.length > 1) {
                    alert("只能选择一条记录进行修改")
                } else {
                    var id = $xz.val()

                    $.ajax({
                        url: "workbench/category/getCategoryById",
                        data: {
                            id: id
                        },
                        type: "post",
                        dataType: "json",
                        success: function (category) {

                            $("#edit-id").val(category.id)
                            $("#edit-name").val(category.name)
                            $("#edit-features").val(category.features)
                            $("#edit-description").val(category.description)

                            $("#editCategoryModal").modal("show")
                        }
                    })
                }
            })

            $("#updateBtn").click(function () {

                $.ajax({
                    url: "workbench/category/update",
                    data: {
                        'id': $.trim($("#edit-id").val()),
                        'name': $.trim($("#edit-name").val()),
                        'features': $.trim($("#edit-features").val()),
                        'description': $.trim($("#edit-description").val())
                    },
                    type: "post",
                    dataType: "json",
                    success: function (data) {

                        if (data.success) {

                            /*
                              修改操作后，维持在当前页，维持每页展现的记录数
                             */
                            pageList($("#categoryPage").bs_pagination('getOption', 'currentPage')
                                ,$("#categoryPage").bs_pagination('getOption', 'rowsPerPage'));

                            // 关闭修改操作的模态窗口
                            $("#editCategoryModal").modal("hide")
                        } else {
                            alert("修改产品类别信息失败")
                        }
                    }
                })
            });
        });


        function pageList(pageNum, pageSize) {

            // 将全选的复选框的√干掉
            $("#qx").prop("checked", false);

            // 查询前，将隐藏域中保存的信息取出来，重新赋予到搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()))
            $("#search-features").val($.trim($("#hidden-features").val()))

            $.ajax({
                url: "workbench/category/pageList",
                data: {
                    "pageNum": pageNum,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "features": $.trim($("#search-features").val()),
                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    var html = "";

                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td><input type="checkbox" name="xz" value="' + n.id + '"/></td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/category/detail?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.features + '</td>';
                        html += '</tr>';
                    })

                    $("#categoryBody").html(html);

                    // 计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1

                    // 数据处理完毕后，结合分页查询，对前端展现分页信息
                    $("#categoryPage").bs_pagination({
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
<input type="hidden" id="hidden-features"/>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>商家列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">商家名称</div>
                        <input class="form-control" type="text" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人</div>
                        <input class="form-control" type="text" id="search-features">
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
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>商家名称</td>
                    <td>联系人</td>
                    <td>联系电话</td>
                    <td>锁定状态</td>
                </tr>
                </thead>
                <tbody id="categoryBody">

                </tbody>
            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="categoryPage"></div>

        </div>

    </div>

</div>
</body>
</html>
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

        $(function () {

            pageList(1, 4);

            $("#searchBtn").click(function () {
                /*
                   点击查询按钮的时候，我们应该先将搜索框中的信息保存起来，保存到隐藏域中
                */
                $("#hidden-name").val($.trim($("#search-name").val()))
                $("#hidden-category").val($.trim($("#search-category").val()))

                pageList(1, $("#productPage").bs_pagination('getOption', 'rowsPerPage'));
            })


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

        });
        function pageList(pageNum, pageSize) {

            $("#search-name").val($.trim($("#hidden-name").val()))
            $("#search-category").val($.trim($("#hidden-category").val()))

            $.ajax({
                url: "workbench/buyer/shopping/pageList",
                data: {
                    "pageNum": pageNum,
                    "pageSize": pageSize,
                    "name": $.trim($("#search-name").val()),
                    "category": $.trim($("#search-category").val())
                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    var html = "";

                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td>' + (i + 1) + '</td>';
                        html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/buyer/shopping/detail?id=' + n.id + '\';">' + n.name + '</a></td>';
                        html += '<td>' + n.category + '</td>';
                        html += '<td>￥' + n.price + '</td>';
                        html += '<td>' + n.inventory + '</td>';
                        html += '</tr>';
                    })

                    $("#productBody").html(html);

                    // 计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1

                    // 数据处理完毕后，结合分页查询，对前端展现分页信息
                    $("#productPage").bs_pagination({
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
<input type="hidden" id="hidden-category"/>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>商品列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">商品名称</div>
                        <input class="form-control" type="text" placeholder="请输入商品名称" id="search-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">商品分类</div>
                        <input class="form-control" type="text" placeholder="请输入商品的分类" id="search-category">
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
                    <td>商品名称</td>
                    <td>商品类别</td>
                    <td>商品售价</td>
                    <td>库存</td>

                </tr>
                </thead>
                <tbody id="productBody">

                </tbody>

            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="productPage"></div>

        </div>

    </div>

</div>
</body>
</html>
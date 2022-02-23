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
                $("#hidden-orderNumber").val($.trim($("#search-orderNumber").val()))

                pageList(1, $("#orderPage").bs_pagination('getOption', 'rowsPerPage'));
            })


            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            $("#updateRemarkBtn").click(function () {

                $.ajax({
                    url: "workbench/buyer/order/updateRemark",
                    data: {
                        "productId": $.trim($("#productId").val()),
                        "noteContent": $.trim($("#noteContent").val()),
                        'createBy': '${user.id}'
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            alert("评价成功")
                            $("#noteContent").val('')
                            $("#addRemarkModal").modal("hide")
                        } else {
                            alert("评价失败")
                        }
                    }
                })
            })
        });

        function cancelOrder(id) {

            if (confirm("确定要取消该订单吗")) {
                $.ajax({
                    url: "workbench/buyer/order/cancelOrder",
                    data: {
                        "id": id,
                        "editBy": "${user.realName}"
                    },
                    dataType: "json",
                    success: function (data) {
                        if (data.success) {
                            alert("取消订单成功")
                            pageList(1, 4);
                            $("#productModal").modal("hide")
                        } else {
                            alert("取消订单成功")
                        }
                    }
                })
            }
        }
        function confirmHarvest(orderNumber, id) {
            $.ajax({
                url: "workbench/buyer/order/confirmHarvest",
                data: {
                    "orderNumber": orderNumber,
                    "id": id,
                    "editBy": "${user.realName}"
                },
                dataType: "json",
                success: function (data) {
                    if (data.success) {
                        alert("收获成功")
                        pageList(1, 4);
                        $("#productModal").modal("hide")
                    } else {
                        alert("收获失败")
                    }
                }
            })
        }

        function updateRemark(id) {
            $("#productId").val(id)
            $("#addRemarkModal").modal("show")
        }


        function addProductModal(id) {
            $.ajax({
                url: "workbench/buyer/order/getGoodsList",
                data: {
                    "orderNumber" : id
                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    var html = "";

                    $.each(data, function (i, n) {
                        html += '<tr>';
                        html += '<td>'+(i+1)+'</td>'
                        html += '<td>'+n.goodsName+'</td>';
                        html += '<td>'+n.goodsNumber+'</td>';
                        html += '<td>'+n.goodsAmount+'</td>';
                        if (n.deliveryStatus == '4') {
                            html += '<td>交易取消</td>';
                            html += '<td></td>';
                        } else if (n.deliveryStatus == '0') {
                            html += '<td>等待卖家发货</td>';
                            html += '<td><a title="取消订单" href="javascript:void(0);" onclick="cancelOrder(\''+n.id+'\')" style="color: #bb8fbc;text-decoration: none;"><span class="glyphicon glyphicon-remove-circle"></span></a></td>';
                        } else if(n.deliveryStatus == '1') {
                            html += '<td>物流配送中</td>';
                            html += '<td><a title="确认收获" href="javascript:void(0);" onclick="confirmHarvest(\''+n.orderNumber+'\',+\''+n.id+'\')" style="color: darkseagreen;text-decoration: none;"><span class="glyphicon glyphicon-ok-circle"></span></a></td>';
                        } else {
                            html += '<td>已完成</td>';
                            html += '<td><a title="点击评价" href="javascript:void(0);" onclick="updateRemark(\''+n.productId+'\')" style="color: orangered;text-decoration: none;"><span class="glyphicon glyphicon-edit"></span></a></td>';

                        }
                        html += '</tr>';

                    })

                    $("#productBody").html(html)

                    $("#productModal").modal("show")
                }
            })
        }
        function pageList(pageNum, pageSize) {

            $("#search-orderNumber").val($.trim($("#hidden-orderNumber").val()))

            $.ajax({
                url: "workbench/buyer/order/pageList",
                data: {
                    "pageNum": pageNum,
                    "pageSize": pageSize,
                    "orderNumber": $.trim($("#search-orderNumber").val()),
                    "buyerId": '${user.id}'
                },
                type: "get",
                dataType: "json",
                success: function (data) {

                    var html = "";

                    $.each(data.dataList, function (i, n) {
                        html += '<tr class="active">';
                        html += '<td>' + (i + 1) + '</td>';
                        html += '<td style="color: #d9534f">'+ n.orderNumber + '</td>';
                        html += '<td>' + n.createTime + '</td>';
                        html += '<td>' + n.orderDestination + '</td>';
                        html += '<td>' + n.orderStatus + '</td>';
                        html += '<td><a class="myHref" href="javascript:void(0);" onclick="addProductModal(\''+n.orderNumber +'\')"><span class="glyphicon glyphicon-shopping-cart"style="font-size: 20px; color: #f0ad4e;"></span></a></td>';
                        html += '</tr>';
                    })

                    $("#orderBody").html(html);

                    // 计算总页数
                    var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1

                    // 数据处理完毕后，结合分页查询，对前端展现分页信息
                    $("#orderPage").bs_pagination({
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

<div class="modal fade" id="productModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">商品详情</h4>
            </div>
            <div class="modal-body">
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td>#</td>
                        <td>商品名称</td>
                        <td>商品数量</td>
                        <td>商品总价</td>
                        <td>状态</td>
                        <td>操作</td>
                    </tr>
                    </thead>
                    <tbody id="productBody">

                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 评价的模态窗口 -->
<div class="modal fade" id="addRemarkModal" role="dialog">
    <input type="hidden" id="productId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">发表评价</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">确定</button>
            </div>
        </div>
    </div>
</div>

<input type="hidden" id="hidden-orderNumber"/>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>订单列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">订单号</div>
                        <input class="form-control" type="text" placeholder="请输入订单号" id="search-orderNumber">
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
                    <td>订单号</td>
                    <td>订单创建时间</td>
                    <td>目的地</td>
                    <td>订单状态</td>
                    <td>操作</td>

                </tr>
                </thead>
                <tbody id="orderBody">

                </tbody>

            </table>
        </div>

        <div style="height: 50px; position: relative;top: 30px;">

            <div id="orderPage"></div>

        </div>

    </div>

</div>
</body>
</html>